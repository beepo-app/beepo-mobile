import 'dart:convert';
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
  static Future<bool> createUser(String displayName, String imgUrl) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'displayName': displayName,
          'profilePhotoUrl': imgUrl,
        }),
      );

      print(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        var data = json.decode(response.body);
        Hive.box('beepo').put('userId', data['identifier']);
        Hive.box('beepo').put('isLogged', true);
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
  static Future<Map> getUser() async {
    try {
      // print(box.get('userId'));
      // Hive.box('beepo').put('password',
      //     '3493a28652e18c8c65290411571bd4774ba37ec0e600e079c692688c6ebd27af37abcb1583fb478942c9c610908c994f353cb3c52603a0bf13b02e4503ff043d4c64efa01f51d841099ec4ed1f74953bcfd0d89e4ed45f384c5f8c5703ededf245b0d67282ce933a8089d01226a42fb175def127290a90b91e8a259bb5378801');

      final response = await http.get(
        Uri.parse(
            '$baseUrl/users/fetch-user?user_identifier=${Hive.box('beepo').get('userId')}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print(response.body);
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
        body: jsonEncode({
          'peerPublicKey': key,
        }),
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

  //Login for access token
  Future<bool> login(String pwd) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Accept': 'application/json'},
        body: {
          'username': userID,
          'password': pwd,
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

  static Future<String> updateUserProfileImage(File image) async {
    try {
      //Upload image to firebase storage
      String id = DateTime.now().millisecondsSinceEpoch.toString();
      UploadTask uploadTask = storageReference.child(id).putFile(image);

      //Get image url
      //  imageUrl;
      TaskSnapshot shot = await uploadTask;
      String imageUrl = await shot.ref.getDownloadURL();
      // await usersCollection.doc(auth.currentUser!.uid).update({
      //   'imageLink': imageUrl,
      //   'imageUploaded': true,
      // });
      // auth.currentUser?.updatePhotoURL(imageUrl);
      // showToast('Profile image updated successfully');
      print(imageUrl);
      return imageUrl;
    } catch (e) {
      print(e);
      showToast(e.toString());
      return null;
    }
  }
}
