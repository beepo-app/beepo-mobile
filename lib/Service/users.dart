import 'dart:convert';
import 'dart:developer';

import '../Constants/network.dart';
import 'package:http/http.dart' as http;

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
}
