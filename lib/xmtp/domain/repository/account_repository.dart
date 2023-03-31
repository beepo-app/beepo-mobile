abstract class AccountRepository {
  Future<void> savePrivateKey(String privateKey);

  Future<String> getPrivateKey();

  Future<void> deletePrivateKey();
}
