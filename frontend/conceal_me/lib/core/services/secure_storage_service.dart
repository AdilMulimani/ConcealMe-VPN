import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class SecureStorageService {
  Future<void> saveString(String key, String value);
  Future<String?> getString(String key);
  Future<void> deleteString(String key);
  Future<bool> containsKey(String key);
  Future<void> saveIntList(String key, List<int> value);
  Future<List<int>?> getIntList(String key);
}

class SecureStorageServiceImpl implements SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageServiceImpl({required FlutterSecureStorage storage})
    : _storage = storage;

  @override
  Future<void> saveString(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Future<String?> getString(String key) async {
    return await _storage.read(key: key);
  }

  @override
  Future<void> deleteString(String key) async {
    await _storage.delete(key: key);
  }

  @override
  Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: key);
  }

  @override
  Future<void> saveIntList(String key, List<int> value) async {
    final stringValue = value.join(',');
    await _storage.write(key: key, value: stringValue);
  }

  @override
  Future<List<int>?> getIntList(String key) async {
    final stringValue = await _storage.read(key: key);
    if (stringValue == null || stringValue.isEmpty) {
      return null;
    }
    return stringValue
        .split(',')
        .map((string) => int.tryParse(string) ?? 0)
        .toList();
  }
}
