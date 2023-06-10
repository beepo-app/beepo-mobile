import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../Constants/network.dart';
import 'package:http/http.dart' as http;

import '../Models/user_model.dart';
import '../Widgets/toasts.dart';

class UsersService {
  //get user details with username
  Future<Map> getUserDetails({String username}) async {
    try {
      // final response = await http.get(
      //   Uri.parse('$baseUrl/users/$username'),
      //   headers: {
      //     'Content-Type': 'application/json',
      //     'Accept': 'application/json',
      //     Headers.bearer: AuthService().accessToken,
      //   },

      // );

      var request = http.Request('GET', Uri.parse('${baseUrl}users/detail'));

      request.headers.addAll({
        'Content-Type': 'application/json',
        // 'Accept': 'application/json',
        // Headers.bearer: AuthService().accessToken,
      });

      request.body = json.encode({"searchQuery": username});

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map result = jsonDecode(await response.stream.bytesToString());
        print(result);
        return result;
      } else {
        log(await response.stream.bytesToString());
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  //get user from by address
  Future<UserModel> getUserByAddress(String address) async {
    try {
      var request = http.Request(
        'GET',
        Uri.parse('${baseUrl}users/detail'),
      );
      request.body = json.encode({"searchQuery": address});
      request.headers.addAll({'Content-Type': 'application/json'});

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();

        print(data);
        var result = jsonDecode(data);
        return UserModel(
          name: result['displayName'],
          userName: result['username'],
          image: result['profilePictureUrl'],
          uid: result['uid'],
          hdWalletAddress: result['hdWalletAddress'],
          bitcoinWalletAddress: result['bitcoinWalletAddress'],
        );
      } else {
        print(await response.stream.bytesToString());

        print(response.statusCode);
        print(response.reasonPhrase);
        // return ;
        throw Exception('No user found');
      }
    } catch (e) {
      // return ;
      throw Exception('No user found');
    }
  }

  Future<UserModel> searchUser(String address) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('hdWalletAddress', isEqualTo: address)
          .get();

      if (snapshot.size > 0) {
        final data = snapshot.docs.first.data();

        print(data);
        return UserModel(
          name: data['displayName'],
          userName: data['username'],
          image: data['profilePictureUrl'],
          uid: data['uid'],
          hdWalletAddress: data['hdWalletAddress'],
          bitcoinWalletAddress: data['bitcoinWalletAddress'],
        );
      } else {
        // return ;
        throw Exception('No user found');
      }
    } catch (e) {
      // return ;
      throw Exception('No user found');
    }
  }
}
