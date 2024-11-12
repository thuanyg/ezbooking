// Helper function to format currency
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

enum ValidateType { email, password, name, phone }

class AppUtils {

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
