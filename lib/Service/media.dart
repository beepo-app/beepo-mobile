import 'dart:convert';

import 'package:beepo/Utils/functions.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import '../Utils/constants.dart';
import '../Widgets/toasts.dart';

class MediaService {
  //Upload picture through form data
  static Future<String> uploadProfilePicture(File image) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/static/profile-photo'),
      );
      request.fields['uid'] = generateRandomString(32);
      request.files.add(await http.MultipartFile.fromPath(
        'photo',
        image.path,
      ));

      http.StreamedResponse response = await request.send();

      var data = json.decode(await response.stream.bytesToString());
      print(data);
      if (response.statusCode == 200) {
        return data['url'];
      } else {
        return null;
      }
    } catch (e) {
      showToast(e.toString());
      return null;
    }
  }
}
