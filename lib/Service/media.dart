import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../Constants/network.dart';
import '../Widgets/toasts.dart';

class MediaService {
  //Upload picture through form data
  static Future<String> uploadProfilePicture(File image) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/users/upload'),
      );
      request.files.add(await http.MultipartFile.fromPath(
        '',
        image.path,
      ));

      http.StreamedResponse response = await request.send();

      var data = json.decode(await response.stream.bytesToString());
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
