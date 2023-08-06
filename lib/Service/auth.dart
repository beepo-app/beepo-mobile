import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:beepo/Service/encryption.dart';
import 'package:beepo/Widgets/toasts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../Constants/network.dart';
import '../Models/user_model.dart';
import '../Utils/functions.dart';
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
  Future<bool> createUser(String displayName, File? img, String pin) async {
    try {
      //To generate keys and contextId
      Map keys = await isolateFunction();
      box.put('privateKey', keys['privateKey']);
      Map contextResult = await AuthService().createContext(keys['publicKey']);

      //Encrypt PIN
      String encryptedPin = await EncryptionService().encrypt(pin);

      // Upload image and get image url
      String imageUrl = "";
      //If image was selected, add to the body of the request

      var body = {'displayName': displayName, "encrypted_pin": encryptedPin};

      if (img != null) {
        imageUrl = await MediaService.uploadProfilePicture(img);
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

      log('testing auth' + response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        var data = json.decode(response.body);

        await box.put('seedphrase', data['encrypted_seedphrase']);
        await box.put('accessToken', data['access_token']);
        await box.put('isLogged', true);
        await box.put('userData', data['user']);

        UserModel user = UserModel(
          uid: data['user']['uid'],
          searchKeywords: createKeywords(data['user']['username']),
          name: displayName,
          image: imageUrl,
          userName: data['user']['username'],
          hdWalletAddress: data['hdWalletAddress'],
          bitcoinWalletAddress: data['bitcoinWalletAddress'],
          firebaseToken: '',
          stories: [],
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
      log(AuthService().accessToken);
      final response = await http.post(
        Uri.parse('$baseUrl/users/authenticated'),
        headers: {
          'Accept': 'application/json',
          Headers.bearer: AuthService().accessToken,
        },
      );

      log(response.body.toString());

      Map data = json.decode(response.body);
      box.put('userData', data);
      return data;
    } catch (e) {
      print(e);
      showToast(e.toString());
      rethrow;
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
      print(response.statusCode);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        box.put('contextId', data['contextId']);
        box.put('serverPublicKey', data['serverPublicKey']);
        return data;
      }
      return {};
    } catch (e) {
      print(e);
      showToast(e.toString());
      rethrow;
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
  Future<String> retrievePassphrase({String? pin}) async {
    try {
      String encryptedPin;
      print('pin: $pin');
      print('seedphrase: ${box.get('seedphrase')}');
      print('accessToken: ${box.get('accessToken')}');
      if (pin != null) {
        encryptedPin = pin;
      } else {
        encryptedPin = await EncryptionService().encrypt(userPin);
      }
      final response = await http.post(
        Uri.parse('$baseUrl/wallet/recover-seedphrase'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          Headers.bearer: box.get('accessToken'),
        },
        body: jsonEncode({
          'encrypted_pin': encryptedPin,
          'encrypted_seedphrase': box.get('seedphrase'),
        }),
      );

      print(response.statusCode);

      print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map result = jsonDecode(response.body);

        String phrase = await EncryptionService().getSeedPhrase(
          seedPhrase: result['seedPhrase'],
        );
        return phrase;
      } else {
        print("error retrieving phrase" + response.body);
        return "";
      }
    } catch (e) {
      print("error retrieving phrase" + e.toString());
      return "";
    }
  }

  //Edit profile
  Future<bool> editProfile({
    String? displayName,
    String? username,
    String? imgUrl,
    String? description,
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
      final search = createKeywords(username!);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(me['uid'])
          .update(UserModel(
              name: displayName!,
              userName: username,
              image: imgUrl!,
              searchKeywords: search,
              hdWalletAddress: data['hdWalletAddress'],
              bitcoinWalletAddress: data['bitcoinWalletAddress'],
              uid: me['uid'],
              firebaseToken: '',
              stories: []).toJson());
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

  //get user from by address
  // Future<UserModel> getUserByAddress(String address) async {
  //   try {
  //     var request = http.Request(
  //       'GET',
  //       Uri.parse('${baseUrl}users/detail'),
  //     );
  //     request.body = json.encode(
  //         {"searchQuery": "0xFbBB4bc46c5f32D0013711E60222Ad41e4AB5AB5"});
  //     request.headers.addAll({'Content-Type': 'application/json'});

  //     http.StreamedResponse response = await request.send();

  //     if (response.statusCode == 200) {
  //       var data = await response.stream.bytesToString();

  //       print(data);
  //       var result = jsonDecode(data);
  //       return UserModel(
  //         name: result['displayName'],
  //         userName: result['username'],
  //         image: result['profilePictureUrl'],
  //         uid: result['uid'],
  //         hdWalletAddress: result['hdWalletAddress'],
  //         bitcoinWalletAddress: result['bitcoinWalletAddress'],
  //       );
  //     } else {
  //       print(await response.stream.bytesToString());

  //       print(response.statusCode);
  //       print(response.reasonPhrase);
  //     }
  //   } catch (e) {
  //     showToast(e.toString());
  //     return null;
  //   }
  // }
}
