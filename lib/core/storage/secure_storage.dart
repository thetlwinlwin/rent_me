import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _storage = const FlutterSecureStorage();

  Future<String?> read({required String key}) => _storage.read(key: key);
  Future<void> write({required String key, required String value}) =>
      _storage.write(key: key, value: value);
  Future<void> delete({required String key}) => _storage.delete(key: key);
}

final secureStorageProvider = Provider<SecureStorage>((_) => SecureStorage());
