import 'dart:convert';
import 'dart:developer';

import 'package:beepo/Constants/app_constants.dart';
import 'package:beepo/Service/encryption.dart';
import 'package:beepo/Widgets/toasts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../Constants/network.dart';
import '../Models/user_model.dart';
import '../generate_keywords.dart';

class AuthService {
  Box box = Hive.box('beepo');

  //GETTERS
  String get userPin => box.get('PIN', defaultValue: '');

  //Get UserID
  String get userID => box.get('userId', defaultValue: '');
  String get uid => box.get('uid', defaultValue: '');

  //Get User token
  String get token => box.get('token', defaultValue: '');

  //Get Access token
  String get accessToken => box.get('EAT', defaultValue: '');

  //Get Context Id
  String get contextId => box.get('contextId', defaultValue: '');

  //Create User
  Future<bool> createUser(String displayName, String imgUrl) async {
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

      if (response.statusCode == 201 || response.statusCode == 200) {
        var data = json.decode(response.body);
        print(data);
        box.put('seedphrase', data['seedphrase']);
        box.put('uid', data['user']['uid']);
        box.put('isLogged', true);
        box.put('userData', data['user']);

        UserModel user = UserModel(
            uid: data['user']['uid'],
            searchKeywords: createKeywords(data['user']['username']),
            name: displayName,
            image: imgUrl,
            userName: data['user']['username']);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(data['user']['uid'])
            .set(user.toJson());

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

      print(AuthService().accessToken);

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
      Map keys = await isolateFunction();
      await AuthService().createContext(keys['publicKey']);

      box.put('privateKey', keys['privateKey']);
      box.put('publicKey', keys['publicKey']);

      bool logIn = await EncryptionService().decryptSeedPhrase(seedPhrase: seedPhrase);

      if (logIn) {
        Map result = await getUser();

        if (result != null) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
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
        throw Exception("Invalid Credentials");
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

      log(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map result = jsonDecode(response.body);

        box.put('seedphrase', result['seedPhrase']);
      }
    } catch (e) {
      return {};
    }
  }

  //Retrieve Passphrase
  // Future<void> retrievePassphraseLocal() async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('$baseUrl/wallet/recover-seedphrase'),
  //       headers: {
  //         // 'Accept': 'application/json',
  //         Headers.bearer: AuthService().accessToken,
  //         Headers.context: AuthService().contextId,
  //       },
  //     );
  //     print(response.body);
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       Map result = jsonDecode(response.body);
  //       if (result['encrypted_passphrase']) {}
  //     }
  //   } catch (e) {
  //     return {};
  //   }
  // }

  //Edit profile
  Future<bool> editProfile({
    String displayName,
    String username,
    String imgUrl,
  }) async {
    try {
      print(AuthService().contextId);

      final response = await http.post(
        Uri.parse('$baseUrl/users/edit'),
        headers: {
          'Accept': 'application/json',
          Headers.context: AuthService().contextId,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'displayName': displayName,
          'username': username,
          'profilePictureUrl': imgUrl,
          'description': 'nnn'
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = json.decode(response.body);
        print(data);

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
}
