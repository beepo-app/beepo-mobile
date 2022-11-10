import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:beepo/Constants/app_constants.dart';
import 'package:beepo/Service/encryption.dart';
import 'package:beepo/Widgets/toasts.dart';
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

  //Get Access token
  String get accessToken => box.get('EAT', defaultValue: '');

  //Get Context Id
  String get contextId => box.get('contextId', defaultValue: '');

  //Create User
  Future<bool> createUser(String displayName, {String imgUrl}) async {
    try {
      //To generate keys and contextId
      await EncryptionService().encryption();
      Map keys = await isolateFunction();
      box.put('privateKey', keys['privateKey']);
      // log(key);
      Map contextResult = await AuthService().createContext(keys['publicKey']);
      final response = await http.post(
        Uri.parse('$baseUrl/users'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'beepo-core-context-id': contextResult['contextId'],
        },
        body: json.encode({
          'displayName': displayName,
          'profilePictureUrl': imgUrl,
        }),
      );

      print('object');
      print(response.statusCode);
      if (response.statusCode == 201 || response.statusCode == 200) {
        var data = json.decode(response.body);
        print(data);
        box.put('seedphrase', data['seedphrase']);
        box.put('uid', data['user']['uid']);
        box.put('isLogged', true);
        box.put('userData', data['user']);
        return true;
      } else {
        showToast(response.body);
        return false;
      }
    } catch (e) {
      showToast(e.toString());
      return false;
    }
  }

  //Get User
  Future<Map> getUser() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/authenticated'),
        headers: {
          'Accept': 'application/json',
          Headers.bearer: AuthService().accessToken,
          Headers.context: AuthService().contextId,
        },
      );

      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        Hive.box('beepo').put('userData', data);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      showToast(e.toString());
      return null;
    }
  }

  //Login user with secret phrase
  Future<bool> loginWithSecretPhrase(String seedPhrase) async {
    try {
      //Step 1. Create keys and context
      //Step 2. Get seedphrase hashes
      // await EncryptionService().encryption();
      Map keys = await isolateFunction();
      await AuthService().createContext(keys['publicKey']);

      box.put('privateKey', keys['privateKey']);

      await EncryptionService().decryptSeedPhrase(seedPhrase: seedPhrase);

      await getUser();

      print('fuck u');

      return true;
    } catch (e) {
      showToast(e.toString());
      return false;
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
        Hive.box(kAppName).put('contextId', data['contextId']);
        Hive.box(kAppName).put('serverPublicKey', data['serverPublicKey']);
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
  Future<String> login(String hash256, String hash512) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {
          Headers.context: contextId,
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
        return data['accessToken'];
      } else {
        return '';
      }
    } catch (e) {
      print(e);
      showToast(e.toString());
      return '';
    }
  }

  //Retrieve Passphrase
  Future<void> retrievePassphrase() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/wallet/recover-seedphrase'),
        headers: {
          Headers.bearer: AuthService().accessToken,
          Headers.context: AuthService().contextId,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map result = jsonDecode(response.body);
        if (result['encrypted_passphrase']) {}
      }
    } catch (e) {
      return {};
    }
  }

  //Retrieve Passphrase
  Future<void> retrievePassphraseLocal() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/wallet/recover-seedphrase'),
        headers: {
          // 'Accept': 'application/json',
          Headers.bearer: AuthService().accessToken,
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
