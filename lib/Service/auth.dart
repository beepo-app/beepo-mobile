import 'dart:convert';

import 'package:beepo/Utils/constants.dart';
import 'package:beepo/WIdgets/toasts.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static Box box = Hive.box('beepo');

  //Create User
  static Future<bool> createUser(String displayName) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'displayName': displayName,
          'profilePhotoUrl': 'https://i.pravatar.cc/300',
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
}
