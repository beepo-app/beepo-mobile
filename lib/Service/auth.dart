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

import '../Screens/Auth/onboarding.dart';

class AuthService {
  Box box = Hive.box('beepo');
  static Reference storageReference = FirebaseStorage.instance.ref('ProfilePictures');

  String get userPin => box.get('PIN', defaultValue: '');

  //Get UserID
  String get userID => box.get('userId', defaultValue: '');

  //Get User token
  String get token => box.get('token', defaultValue: '');

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
  Future<bool> login(String pwd) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Accept': 'application/json'},
        body: {
          'encryptedSeedPhraseHash256': userID,
          'encryptedSeedPhraseHash512': pwd,
        },
      );

      print(response.body);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        box.put('token', data['access_token']);
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
      final response = await http.post(
        Uri.parse('$baseUrl/users/retreive-passphrase'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${AuthService().token}',
          'Content-Type': 'application/json'
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
