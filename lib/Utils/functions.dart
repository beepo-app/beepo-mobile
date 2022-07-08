//Generate key pair
import 'dart:io';

import 'package:cryptography/cryptography.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

Future<String> generateKey() async {
  // Generate a keypair.
  final algorithm = X25519();
  final keyPair = await algorithm.newKeyPair();

  final key = await keyPair.extract();

  return key.bytes.toString();
}

class ImageUtil {
  Future<File> cropProfileImage(XFile file) async {
    try {
      CroppedFile croppedFile = await ImageCropper().cropImage(
        sourcePath: file.path,
        compressQuality: 50,
        cropStyle: CropStyle.circle,
        aspectRatio: const CropAspectRatio(
          ratioX: 1,
          ratioY: 1,
        ),
      );

      if (croppedFile != null) {
        return File(croppedFile.path);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
