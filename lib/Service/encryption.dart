import 'dart:math';
import 'dart:typed_data';

import 'package:beepo/Service/auth.dart';
import 'package:cryptography/dart.dart';
import 'package:hive/hive.dart';

import 'package:pointycastle/export.dart';

import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:encrypt/encrypt.dart' as encrypter;

class EncryptionService {
  Box box = Hive.box('beepo');

  Future<void> encryption() async {
    try {
      var helper = RsaKeyHelper();

      var key = generateRSAkeyPair(exampleSecureRandom());

      String publicKey = helper.encodePublicKeyToPemPKCS1(key.publicKey);
      // dev.log(publicKey);

      // box.put('publicKey', publicKey);

      String privateKey = helper.encodePrivateKeyToPemPKCS1(key.privateKey);
      box.put('privateKey', privateKey);

      Map publics = await AuthService().createContext(publicKey);
      // String pwd = publics['password'];
      // String serverPublicKey = publics['peerPublicKey'];

      // final encrypterer = encrypter.Encrypter(
      //   encrypter.RSA(
      //     publicKey: helper.parsePublicKeyFromPem(serverPublicKey),
      //     privateKey: key.privateKey,
      //     encoding: encrypter.RSAEncoding.PKCS1,
      //   ),
      // );

      // //Decrypt the password (ciphertext)
      // final encryptedPwd = encrypterer.decrypt16(pwd);

      // //Encrypt the password (plaintext)
      // var encryPwd = encrypterer.encrypt(encryptedPwd);

      // print(encryPwd.base16);
      // box.put('password', encryPwd.base16);

      // await AuthService().login(encryPwd.base16);
    } catch (e) {
      print('error');
      print(e);
    }
  }

  Future<String> decryptSeedPhrase() async {
    try {
      String seedphrase = box.get('seedphrase');
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

      final encryptedPwd = encrypterer.decrypt16(seedphrase);

      print(encryptedPwd);
      var hash = await DartSha256().hash(encryptedPwd.codeUnits);
    } catch (e) {
      print(e);
    }
  }

  static AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateRSAkeyPair(
      SecureRandom secureRandom,
      // {int bitLength = 2048}) {
      {int bitLength = 1024}) {
    // Create an RSA key generator and initialize it

    final keyGen = RSAKeyGenerator()
      ..init(
        ParametersWithRandom(
            RSAKeyGeneratorParameters(BigInt.parse('65537'), bitLength, 64),
            secureRandom),
      );

    // Use the generator

    final pair = keyGen.generateKeyPair();

    // Cast the generated key pair into the RSA key types

    final myPublic = pair.publicKey as RSAPublicKey;
    final myPrivate = pair.privateKey as RSAPrivateKey;

    return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(myPublic, myPrivate);
  }

  static SecureRandom exampleSecureRandom() {
    final secureRandom = FortunaRandom();

    final seedSource = Random.secure();
    final seeds = <int>[];
    for (int i = 0; i < 32; i++) {
      seeds.add(seedSource.nextInt(255));
    }
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));

    return secureRandom;
  }
}
