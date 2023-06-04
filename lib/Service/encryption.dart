import 'package:beepo/Service/auth.dart';
import 'package:beepo/Utils/crypto.dart';
import 'package:convert/convert.dart';
import 'package:cryptography/dart.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:encrypt/encrypt.dart' as encrypter;

class EncryptionService {
  Box box = Hive.box('beepo');

  //GETTERS
  String get privateKey => box.get('privateKey');

  String get publicKey => box.get('serverPublicKey');

  String get seedPhrase => box.get('seedphrase');

  Future<void> encryption() async {
    try {
      var helper = RsaKeyHelper();

      var key = CryptoUtils.generateRSAkeyPair();

      String publicKey = helper.encodePublicKeyToPemPKCS1(key.publicKey);
      // dev.log(publicKey);

      // box.put('publicKey', publicKey);

      String privateKey = helper.encodePrivateKeyToPemPKCS1(key.privateKey);
      box.put('privateKey', privateKey);

      await AuthService().createContext(publicKey);
    } catch (e) {
      print('error');
      print(e);
    }
  }

  Future<bool> decryptSeedPhrase({String seedPhrase}) async {
    try {
      String decryptedSecretPhrase;
      var helper = RsaKeyHelper();

      String serverPublicKey = box.get('serverPublicKey');

      String privateKey = box.get('privateKey');

      print(privateKey);

      // print(serverPublicKey);

      final encrypterer = encrypter.Encrypter(
        encrypter.RSA(
          publicKey: helper.parsePublicKeyFromPem(serverPublicKey),
          privateKey: helper.parsePrivateKeyFromPem(privateKey),
          encoding: encrypter.RSAEncoding.PKCS1,
        ),
      );

      decryptedSecretPhrase = seedPhrase ?? encrypterer.decrypt16(box.get('seedphrase'));

      var hash256Bytes = await const DartSha256().hash(decryptedSecretPhrase.codeUnits);

      var hash512Bytes = await const DartSha512().hash(decryptedSecretPhrase.codeUnits);

      String hash256 = hex.encode(hash256Bytes.bytes);
      String hash512 = hex.encode(hash512Bytes.bytes);

      //Encrypt hash256
      var encryptedHash256 = encrypterer.encrypt(hash256);
      var encryptedHash512 = encrypterer.encrypt(hash512);

      // String accessToken = await AuthService().login(
      //   encryptedHash256.base16,
      //   encryptedHash512.base16,
      // );

      //Access token must be decrypted and re-encrypted with the server public key
      // var encryptedAccessToken = encrypterer.encrypt(encrypterer.decrypt16(accessToken));
//
      // box.put('EAT', encryptedAccessToken.base16);

      // dev.log(encryptedAccessToken.base16);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<String> getSeedPhrase({String seedPhrase}) async {
    try {
      // String seedphrase = box.get('seedphrase', defaultValue: '');
      String seedphrase = seedPhrase ?? box.get('seedphrase', defaultValue: '');
      print(seedphrase);

      if (seedphrase == '') {
        await AuthService().retrievePassphrase();
      }
      var helper = RsaKeyHelper();

      String serverPublicKey = box.get('serverPublicKey');

      String privateKey = box.get('privateKey');

      final encrypterer = encrypter.Encrypter(
        encrypter.RSA(
          publicKey: helper.parsePublicKeyFromPem(serverPublicKey),
          privateKey: helper.parsePrivateKeyFromPem(privateKey),
          encoding: encrypter.RSAEncoding.PKCS1,
        ),
      );

      return encrypterer.decrypt16(seedphrase);
    } catch (e) {
      print(e);
      return '';
    }
  }

  Future<String> encrypt(String pin) async {
    // String seedphrase = box.get('seedphrase', defaultValue: '');
    // if (seedphrase == '') {
    //   await AuthService().retrievePassphrase();
    // }
    var helper = RsaKeyHelper();

    String serverPublicKey = box.get('serverPublicKey');

    String privateKey = box.get('privateKey');

    final encrypterer = encrypter.Encrypter(
      encrypter.RSA(
        publicKey: helper.parsePublicKeyFromPem(serverPublicKey),
        privateKey: helper.parsePrivateKeyFromPem(privateKey),
        encoding: encrypter.RSAEncoding.PKCS1,
      ),
    );

    return encrypterer.encrypt(pin).base16;
  }
}

Future<Map> encryption(String box) async {
  var helper = RsaKeyHelper();

  var key = CryptoUtils.generateRSAkeyPair();

  String publicKey = helper.encodePublicKeyToPemPKCS1(key.publicKey);

  String privateKey = helper.encodePrivateKeyToPemPKCS1(key.privateKey);

  return {'publicKey': publicKey, 'privateKey': privateKey};
}

Future<Map> isolateFunction() async {
  return await compute(encryption, '');
}
