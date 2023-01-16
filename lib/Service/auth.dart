import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:beepo/Constants/app_constants.dart';
import 'package:beepo/Service/encryption.dart';
import 'package:beepo/Widgets/toasts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../Constants/network.dart';
import '../Models/user_model.dart';
import '../generate_keywords.dart';
import 'media.dart';

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
  // String get accessToken => box.get('EAT', defaultValue: '');
  String get accessToken => box.get('accessToken', defaultValue: '');

  //Get Context Id
  String get contextId => box.get('contextId', defaultValue: '');

  //Create User
  Future<bool> createUser(String displayName, File img, String pin) async {
    try {
      //To generate keys and contextId
      Map keys = await isolateFunction();
      box.put('privateKey', keys['privateKey']);
      Map contextResult = await AuthService().createContext(keys['publicKey']);

      //Encrypt PIN
      String encryptedPin = await EncryptionService().encrypt(pin);

      // Upload image and get image url
      String imageUrl = "";
      if (img != null) {
        imageUrl = await MediaService.uploadProfilePicture(img);
      }

      //If image was selected, add to the body of the request

      var body = {'displayName': displayName, "encrypted_pin": encryptedPin};

      if (img != null) {
        body['profilePictureUrl'] = imageUrl;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/users'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          Headers.context: contextResult['contextId'],
        },
        body: json.encode(body),
      );

      log(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        var data = json.decode(response.body);

        box.put('seedphrase', data['encrypted_seedphrase']);
        box.put('accessToken', data['access_token']);
        box.put('isLogged', true);
        box.put('userData', data['user']);

        UserModel user = UserModel(
          uid: data['user']['uid'],
          searchKeywords: createKeywords(data['user']['username']),
          name: displayName,
          image: imageUrl,
          userName: data['user']['username'],
        );
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
      print(e);
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
        },
      );

      log(response.body.toString());

      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        box.put('userData', data);
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
  Future<bool> loginWithSecretPhrase(String seedPhrase, String pin) async {
    try {
      //Step 1. Create RSA keys and context
      Map keys = await isolateFunction();
      await AuthService().createContext(keys['publicKey']);

      box.put('privateKey', keys['privateKey']);
      box.put('publicKey', keys['publicKey']);

      String encryptedSeedphrase =
          await EncryptionService().encrypt(seedPhrase);
      String encryptedPin = await EncryptionService().encrypt(pin);

      bool acctFound = await verifyPhrase(encryptedSeedphrase);

      if (acctFound != null) {
        return await login(encryptedSeedphrase, encryptedPin);
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

  //Verify Seedphrase is from beepo
  Future<bool> verifyPhrase(String seedPhrase) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/verify'),
        headers: {
          Headers.context: contextId,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"encrypted_seedphrase": seedPhrase}),
      );

      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      showToast(e.toString());
      return false;
    }
  }

  //Login for access token
  Future<bool> login(String encryptedSeedphrase, String encryptedPin) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {
          Headers.context: contextId,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "encrypted_seedphrase": encryptedSeedphrase,
          "encrypted_pin": encryptedPin,
        }),
      );

      print(response.body);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        box.put('accessToken', data['access_token']);
        box.put('seedphrase', data['encrypted_seedphrase']);
        box.put('isLogged', true);
        box.put('userData', data['user']);
        return true;
      } else {
        throw Exception("Invalid Credentials");
      }
    } catch (e) {
      print(e);
      showToast(e.toString());
      return false;
    }
  }

  //Retrieve Passphrase
  Future<String> retrievePassphrase() async {
    try {
      String encryptedPin = await EncryptionService().encrypt('1234');
      print(AuthService().accessToken);
      final response = await http.post(
        Uri.parse('$baseUrl/wallet/recover-seedphrase'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          Headers.bearer: AuthService().accessToken,
        },
        body: jsonEncode({
          'encrypted_pin': encryptedPin,
          'encrypted_seedphrase': box.get('seedphrase'),
        }),
      );

      log(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map result = jsonDecode(response.body);

        String dd = await EncryptionService()
            .getSeedPhrase(seedPhrase: result['seedPhrase']);
        return dd;
      } else {
        print(response.body);
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  //Edit profile
  Future<bool> editProfile({
    String displayName,
    String username,
    String imgUrl,
    String description,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/edit'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          Headers.bearer: AuthService().accessToken,
        },
        body: jsonEncode({
          'displayName': displayName,
          'username': username,
          'profilePictureUrl': imgUrl,
          'description': description,
        }),
      );

      var data = json.decode(response.body);
     Map me = await getUser();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(me['uid'])
          .update(UserModel(
                  name: displayName,
                  userName: username,
                  image: imgUrl,
                  uid: me['uid'])
              .toJson());
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        showToast(data['message']);
        return false;
      }
    } catch (e) {
      showToast(e.toString());
      return false;
    }
  }
}
