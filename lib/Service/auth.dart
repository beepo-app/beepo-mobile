import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:beepo/Service/encryption.dart';
import 'package:beepo/Utils/constants.dart';
import 'package:beepo/WIdgets/toasts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../Constants/network.dart';
import '../Screens/Auth/onboarding.dart';

class AuthService {
  Box box = Hive.box('beepo');
  static Reference storageReference = FirebaseStorage.instance.ref('ProfilePictures');

  String get userPin => box.get('PIN', defaultValue: '');

  //Get UserID
  String get userID => box.get('userId', defaultValue: '');

  //Get User token
  String get token => box.get('token', defaultValue: '');

  //Get Context Id
  String get contextId => box.get('contextId', defaultValue: '');

  //Create User
  Future<bool> createUser(String displayName, {String imgUrl}) async {
    try {
      //To generate keys and contextId
      await EncryptionService().encryption();
      final response = await http.post(
        Uri.parse('$baseUrl/users'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'beepo-core-context-id': box.get('contextId'),
        },
        body: json.encode({
          'displayName': displayName,
          'profilePictureUrl': imgUrl,
        }),
      );

      print(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        var data = json.decode(response.body);
        print(data);
        box.put('seedphrase', data['seedphrase']);
        box.put('uid', data['user']['uid']);
        box.put('isLogged', true);
        return true;
      } else {
        return null;
      }
    } catch (e) {
      showToast(e.toString());
      return null;
    }
  }

  //Get User
  Future<Map> getUser() async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/users/fetch-user?user_identifier=${Hive.box('beepo').get('userId')}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      log(box.get('privateKey'));
      log(response.body);

      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        Hive.box('beepo').put('userData', data);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      showToast(e.toString());
      return null;
    }
  }

  //Perform Key Exchange
  Future<Map> keyExchange(String key) async {
    try {
      final response = await http.post(
        Uri.parse(
            '$baseUrl/auth/new-key-exchange-session?user_identifier=${box.get('userId')}'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'peerPublicKey': key}),
      );

      print(response.body);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        // box.put('password', data['password']);
        // print(data['peerPublicKey']);
        box.put('peerPublicKey', data['peerPublicKey']);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      showToast(e.toString());
      return null;
    }
  }

  //Perform Key Exchange
  Future<Map> createContext(String key) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/crypto/rsa/new-context'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'publicKey': key}),
      );

      print(response.body);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print(data);
        box.put('contextId', data['contextId']);
        box.put('serverPublicKey', data['serverPublicKey']);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      showToast(e.toString());
      return null;
    }
  }

  //Login for access token
  Future<bool> login(String hash256, String hash512) async {
    try {
      log(hash512);
      log(contextId);

      // var headers = {
      //   'beepo-core-context-id': '633c88b0164a34c99fe3a4e7',
      //   'Content-Type': 'application/json',
      //   // 'Cookie':
      //   //     'ARRAffinity=a47db015dbfb7e15c9d914a37590375874b5381c490f2580157be63832b72049; ARRAffinitySameSite=a47db015dbfb7e15c9d914a37590375874b5381c490f2580157be63832b72049'
      // };
      // var request = http.Request(
      //     'POST', Uri.parse('https://core.api.beepoapp.net/api/v1/auth/login'));
      // request.body = json.encode({
      //   "encryptedSeedPhraseHash256":
      //       "c54c44389871f4d1a9497bb36b99417db902ab27e054bd3aae88783066951965db2839659acbd6ddde306c5147b6140c2e791217d647d9bf9d0df42f5015f4ff36fc904aad910a672baf5584471fcbf4ab1e8651ab5fdfcbd02e3dcb2c9aa901d615fb7faefd07810267b706d9b4413cb651d5a061e173799e9926cd957b6d783e6730e23163223985907e60e43506ca9bdabf54118a1a3fc4eb19ca07e9023ef2e9f36b84aa66238a5be2f1cfba160e259c49f6624a0ade0f4e5be9f8915b14235d54cc3a6c4805abc32ddd62a0f1b47c23d6d8499549e6222d43eeb60d648d0a6304b24c021428dd29af1bb3cade12f11353d472811e2d81b03375b3e59f3fcbd43f0ad643dc0dadd1b8a1f8d58e0282b013de830b231c0e7ee538e377a3807acdb3e3edc65a61c417736af02db228cb80952db73229c130d777eb8da818c2430e9544fae2be1bc071701bf726875fd50ebb5a9469a0ee856ec8bf91d32965a63f83f3d4a07971ecfa8d7f62bdaaa79609429b119f24001fdc4a48f1fd43e16301c1d2a01d0ed6a4127179daf491a50806ef525bc3fa45262ad2d94bdeae254c2ee008eb27eb5cf8c6cb13a05929585c729e1e34c49d3f23e9b9275eded9b699711a2cc79a29b18f39776b5b0f2c58c48f55a28f22d336813fa8a032823d2dc1331d195cd00477b2bd710c48789f581726fe99f906027b899e9fbc6825c71a",
      //   "encryptedSeedPhraseHash512":
      //       "0b3464204ceba099c88b009f147df3f63d962a815903dd12d073081e2aa6221e231c7b20500d12b32d097ca17245ed336ecfe733867dc86ebd0235da5e8efa5832b82263a922d17153a37b8baf0c33145016cc5d5547daa6fbb303756e8918c36124364b55988b8a5334d5e7cac86ec522d50167ab5927d08399b4d63d026e320bcc006cc393d4e1027f8868c4a9bf5d0ad2263814727b029729fac0c0a6b1536fd289c2c3a46929115f36ce0a8f8fbcc63bfdbfef40ff44425e54812a11cba5a703eaca79b6416d0b0698d1fa4ba788b77ec91d63cd2485c906efffedfeda508a89bf057279051b87056de6e187829670ca4348a8eee7c9e65c369063ca4a8a58729a8ada6c9ddda4d49ea0924465a9419c38a99fb06b6574d621e380a17199baa1257838f09afc58baf89ae678942d396266557e34b4374993756903d9f29c33c1a50440f5c830210c1be66102a4ef05fbcfaf1fd7987da14d62bfd79f23bb6b3db9a99a307f8e788e1bedcc1772c10f79123331cdeae0841c255ce7bce55fb3e21941628fa2a58f645902d25697c7bc7d93bcd37e133632c0cc68d95a12ac8b6a6063a079b2e574f2ebcccbbfe1d1800c22377408d7e2e5ebadc6c8a2ab25b11d1a09dc759650282f4a7a20935a0488f21d73f3c90527ac617ec1cf3c0d83c86a46c45ef24012d4cbd4f9278dfd4b5c0bf658ca608049f98b83f3a5082731"
      // });
      // request.headers.addAll(headers);

      // http.StreamedResponse response = await request.send();

      // if (response.statusCode == 200) {
      //   print(await response.stream.bytesToString());
      // } else {
      //   print(response.reasonPhrase);
      // }

      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {
          'beepo-core-context-id': contextId,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "encryptedSeedPhraseHash256": hash256,
          "encryptedSeedPhraseHash512": hash512,
        }),
      );

      print(response.body);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        box.put('token', data['accessToken']);
        box.put('isLogged', true);
        return true;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      showToast(e.toString());
      return null;
    }
  }

  //Retrieve Passphrase
  Future<void> retrievePassphrase() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/wallet/recover-seedphrase'),
        headers: {
          // 'Accept': 'application/json',
          Headers.bearer: AuthService().token,
          Headers.context: AuthService().contextId,
        },
      );
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map result = jsonDecode(response.body);
        if (result['encrypted_passphrase']) {}
      }
    } catch (e) {
      return {};
    }
  }
}
