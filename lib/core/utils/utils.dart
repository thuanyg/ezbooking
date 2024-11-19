// Helper function to format currency
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

enum ValidateType { email, password, name, phone }

class AppUtils {

  static String formatDate(DateTime dateTime){
    return DateFormat("dd/MM/yyyy").format(dateTime);
  }

  static get secretKey => "d1a39f24af928102cbba80a577d9989c98bbb753ceffd9a8d2c272e1f94046cf";

  static String encryptData(String data, String secretKey) {
    try {
      final key = encrypt.Key.fromUtf8(secretKey.padRight(32, ' ').substring(0, 32)); // Đảm bảo độ dài 32 ký tự
      final iv = encrypt.IV.fromLength(16); // IV dài 16 byte

      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      // Mã hóa dữ liệu và lưu IV cùng với dữ liệu mã hóa (base64)
      final encrypted = encrypter.encrypt(data, iv: iv);
      // Lưu IV cùng với dữ liệu mã hóa (hoặc sử dụng một cách khác để lưu trữ IV)
      return iv.base64 + encrypted.base64; // Gộp IV và dữ liệu mã hóa
    } on Exception catch (e) {
      print("Error: $e");
      rethrow;
    }
  }

  static String decryptData(String encryptedData, String secretKey) {
    try {
      final key = encrypt.Key.fromUtf8(secretKey.padRight(32, ' ').substring(0, 32)); // Đảm bảo độ dài 32 ký tự

      // Tách IV và dữ liệu mã hóa
      final ivBase64 = encryptedData.substring(0, 24); // IV có độ dài 16 byte (24 ký tự base64)
      final encryptedBase64 = encryptedData.substring(24); // Dữ liệu mã hóa còn lại

      final iv = encrypt.IV.fromBase64(ivBase64); // Chuyển đổi IV từ base64
      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      // Giải mã dữ liệu
      final decrypted = encrypter.decrypt64(encryptedBase64, iv: iv);
      return decrypted;
    } on Exception catch (e) {
      print("Error during decryption: $e");
      rethrow;
    }
  }


  static String generateRandomString(int len) {
    var r = Random();
    const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
  }

  static String formatCurrency(double value) {
    return NumberFormat.compact(locale: 'en_US').format(value.round());
  }

  static bool validate({required ValidateType type, required String value}) {
    switch (type) {
      case ValidateType.email:
        final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
        return emailRegex.hasMatch(value);
      case ValidateType.password:
        return value.length >= 8;
      case ValidateType.phone:
        final phoneRegex = RegExp(r'^\d{10}$');
        return phoneRegex.hasMatch(value);
      default:
        return false;
    }
  }

  static String convertMetersToKilometers(double meters) {
    double kilometers = meters / 1000;
    return kilometers.toStringAsFixed(2);
  }
}
