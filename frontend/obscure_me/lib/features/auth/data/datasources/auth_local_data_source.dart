import 'package:flutter/foundation.dart';
import 'package:obscure_me/core/services/secure_storage_service.dart';

abstract interface class AuthLocalDataSource {
  Future<void> saveToken(String value, [String key]);
  Future<String?> getToken(String key);
  Future<void> deleteToken(String key);
  Future<void> deleteLockPattern(String key);
  Future<bool> containsToken(String key);
  Future<bool> containsLockPattern(String key);
  Future<bool> saveLockPattern(List<int> pattern, [String key]);
  Future<List<int>?> getLockPattern(String key);

  Future<bool> verifyLockPattern(List<int> pattern);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorageService _secureStorageService;

  AuthLocalDataSourceImpl({required SecureStorageService secureStorageService})
    : _secureStorageService = secureStorageService;

  @override
  Future<bool> containsLockPattern([String key = 'LOCK_PATTERN_KEY']) async {
    return await _secureStorageService.containsKey(key);
  }

  @override
  Future<bool> containsToken([String key = 'JWT_TOKEN_KEY']) async {
    return await _secureStorageService.containsKey(key);
  }

  @override
  Future<void> deleteLockPattern([String key = 'LOCK_PATTERN_KEY']) async {
    await _secureStorageService.deleteString(key);
  }

  @override
  Future<void> deleteToken([String key = 'JWT_TOKEN_KEY']) async {
    await _secureStorageService.deleteString(key);
  }

  @override
  Future<List<int>?> getLockPattern([String key = 'LOCK_PATTERN_KEY']) async {
    return await _secureStorageService.getIntList(key);
  }

  @override
  Future<String?> getToken([String key = 'JWT_TOKEN_KEY']) async {
    return await _secureStorageService.getString(key);
  }

  @override
  Future<bool> saveLockPattern(
    List<int> value, [
    String key = 'LOCK_PATTERN_KEY',
  ]) async {
    await _secureStorageService.saveIntList(key, value);
    final lockPattern = await getLockPattern();
    debugPrint('The lock Pattern is : $lockPattern');
    return await _secureStorageService.containsKey('LOCK_PATTERN_KEY');
  }

  @override
  Future<void> saveToken(String value, [String key = 'JWT_TOKEN_KEY']) async {
    await _secureStorageService.saveString(key, value);
  }

  @override
  Future<bool> verifyLockPattern(
    List<int> pattern, [
    String key = 'LOCK_PATTERN_KEY',
  ]) async {
    final savedPattern = await _secureStorageService.getIntList(key);
    if (savedPattern != null) {
      return listEquals(savedPattern, pattern);
    }
    return false;
  }
}
