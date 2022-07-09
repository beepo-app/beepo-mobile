import 'dart:convert';
import 'dart:io';

import 'package:beepo/Utils/constants.dart';
import 'package:beepo/WIdgets/toasts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static Box box = Hive.box('beepo');
  static Reference storageReference = FirebaseStorage.instance.ref('ProfilePictures');

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
        box.put('userId', data['identifier']);
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
  static Future<Map> getUser() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/${box.get('userId')}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      // print(response.body);
      if (response.statusCode == 200) {
        Map data = json.decode(response.body);
        box.put('userData', data);
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
  Future<String> keyExchange() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/new-ecdh-session?user_identifier=${box.get('userId')}'),
        headers: {'Accept': 'application/json'},
        body: {
          'peerPublicKey': '123456',
        },
      );

      print(response.body);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data['key'];
      } else {
        return null;
      }
    } catch (e) {
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
