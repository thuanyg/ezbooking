// Helper function to format currency
import 'package:intl/intl.dart';

enum ValidateType { email, password, name, phone }

class AppUtils {
  static String formatCurrency(double value) {
    return NumberFormat.compact(locale: 'en_US')
        .format(value.round());
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
}
