import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math';
import 'dart:typed_data';

import 'package:beepo/Service/auth.dart';
import 'package:beepo/Service/keys.dart';
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

      // box.put('privateKey', privateKey);
      // box.put('publicKey', publicKey);

      // String privateKey = helper.encodePrivateKeyToPemPKCS1(key.privateKey);

      Map publics = await AuthService().keyExchange(publicKey);
      String pwd = publics['password'];
      String serverPublicKey = publics['peerPublicKey'];

      final encrypterer = encrypter.Encrypter(
        encrypter.RSA(
          publicKey: helper.parsePublicKeyFromPem(serverPublicKey),
          privateKey: key.privateKey,
          encoding: encrypter.RSAEncoding.PKCS1,
        ),
      );

      //Decrypt the password (ciphertext)
      final encryptedPwd = encrypterer.decrypt16(pwd);

      //Encrypt the password (plaintext)
      var encryPwd = encrypterer.encrypt(encryptedPwd);

      print(encryPwd.base16);
      box.put('password', encryPwd.base16);

      await AuthService().login(encryPwd.base16);
    } catch (e) {
      print('error');
      print(e);
    }
  }

  // Uint8List rsaEncrypt(RSAPublicKey myPublic, Uint8List dataToEncrypt) {
  //   final encryptor = PKCS1Encoding(RSAEngine())
  //     ..init(true, PublicKeyParameter<RSAPublicKey>(myPublic)); // true=encrypt

  //   return _processInBlocks(encryptor, dataToEncrypt);
  // }

  // Uint8List rsaDecrypt(RSAPrivateKey myPrivate, Uint8List cipherText) {
  //   final decryptor = PKCS1Encoding(RSAEngine())
  //     ..init(false, PrivateKeyParameter<RSAPrivateKey>(myPrivate)); // false=decrypt

  //   return _processInBlocks(decryptor, cipherText);
  // }

  // Uint8List _processInBlocks(AsymmetricBlockCipher engine, Uint8List input) {
  //   final numBlocks = input.length ~/ engine.inputBlockSize +
  //       ((input.length % engine.inputBlockSize != 0) ? 1 : 0);

  //   final output = Uint8List(numBlocks * engine.outputBlockSize);

  //   var inputOffset = 0;
  //   var outputOffset = 0;
  //   while (inputOffset < input.length) {
  //     final chunkSize = (inputOffset + engine.inputBlockSize <= input.length)
  //         ? engine.inputBlockSize
  //         : input.length - inputOffset;

  //     outputOffset +=
  //         engine.processBlock(input, inputOffset, chunkSize, output, outputOffset);

  //     inputOffset += chunkSize;
  //   }

  //   return (output.length == outputOffset) ? output : output.sublist(0, outputOffset);
  // }

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
