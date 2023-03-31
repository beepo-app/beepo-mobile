import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/repository/account_repository.dart';

class AccountRepositoryImpl implements AccountRepository {
   FlutterSecureStorage _secureStorage;

  AccountRepositoryImpl(_secureStorage, {FlutterSecureStorage secureStorage}) {
    _secureStorage = secureStorage;
  }

  static const storageKey = "private_key";

  @override
  Future<String> getPrivateKey() async {
    return await _secureStorage.read(key: storageKey);
  }

  @override
  Future<void> savePrivateKey(String privateKey) async {
    await _secureStorage.write(key: storageKey, value: privateKey);
  }

  @override
  Future<void> deletePrivateKey() async {
    await _secureStorage.delete(key: storageKey);
  }
}
