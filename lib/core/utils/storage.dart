import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageUtils {
  // FlutterSecureStorage instance
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
      aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ));

  // Private constructor to prevent instance creation
  StorageUtils._privateConstructor();

  // Method to store a token (Static)
  static Future<void> storeValue({
    required String key,
    required String value,
  }) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      // Handle exceptions (optional)
      print("Error storing value: $e");
    }
  }

  // Method to retrieve a token (Static)
  static Future<String?> getValue({required String key}) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      // Handle exceptions (optional)
      print("Error retrieving value: $e");
      return null; // Return null if an error occurs
    }
  }

  // Method to remove a token (Static)
  static Future<void> remove({required String key}) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      // Handle exceptions (optional)
      print("Error removing value: $e");
    }
  }
}
