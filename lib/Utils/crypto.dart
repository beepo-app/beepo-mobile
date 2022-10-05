import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';
import 'package:encrypt/encrypt.dart' as encrypter;

class CryptoUtils {
  Future<String> hash256(String message) async {
    var hash = await Sha256().hash(message.codeUnits);

    return hex.encode(hash.bytes);
  }
}
