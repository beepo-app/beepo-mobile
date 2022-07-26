import 'package:cryptography/cryptography.dart';

import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:pointycastle/api.dart' as crypto;

//Future to hold our KeyPair
Future<crypto.AsymmetricKeyPair> futureKeyPair;

//to store the KeyPair once we get data from our future
crypto.AsymmetricKeyPair keyPair;

Future<String> getKeyPair() async {
// Future<crypto.AsymmetricKeyPair<crypto.PublicKey, crypto.PrivateKey>> getKeyPair() async {
  var helper = RsaKeyHelper();
  crypto.AsymmetricKeyPair<crypto.PublicKey, crypto.PrivateKey> key =
      await helper.computeRSAKeyPair(helper.getSecureRandom());

  // print(key.publicKey);

  // print(helper.encodePublicKeyToPemPKCS1(key.publicKey));
  return helper.encodePublicKeyToPemPKCS1(key.publicKey);

  // return helper.computeRSAKeyPair(helper.getSecureRandom());
}

class EncryptionService {
  //Generate rsa key pair
  static Future<RsaKeyPair> generateRsaKeyPair() async {
    // final algorithm = RsaPublicKey(e: e, n: n);
    // final keyPair = await algorithm.generateKeyPair(bits: 2048);
    // return keyPair;
  }
}
