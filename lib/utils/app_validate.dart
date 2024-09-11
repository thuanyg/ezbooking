import 'package:flutter/material.dart';

class Validator {
  static bool isEmpty(String text){
    return text.isEmpty ? true : false;
  }

  static String? validateFullName(String? value) {
    const pattern = r'\d';
    final regex = RegExp(pattern);
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    } else if (regex.hasMatch(value)) {
      return 'Enter a valid name';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    const pattern = r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
    final regex = RegExp(pattern);
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    } else if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }

    // Kiểm tra độ dài tối thiểu của mật khẩu
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    // Kiểm tra xem mật khẩu có chứa ít nhất một chữ hoa không
    // if (!RegExp(r'[A-Z]').hasMatch(value)) {
    //   return 'Password must contain at least one uppercase letter';
    // }

    // Kiểm tra xem mật khẩu có chứa ít nhất một chữ thường không
    // if (!RegExp(r'[a-z]').hasMatch(value)) {
    //   return 'Password must contain at least one lowercase letter';
    // }

    // Kiểm tra xem mật khẩu có chứa ít nhất một số không
    // if (!RegExp(r'\d').hasMatch(value)) {
    //   return 'Password must contain at least one number';
    // }

    // Kiểm tra xem mật khẩu có chứa ít nhất một ký tự đặc biệt không
    // if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
    //   return 'Password must not contain special character';
    // }

    return null;
  }

  static String? validateConfirmPassword(String? value, TextEditingController  _passwordController) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value.compareTo(_passwordController.text) != 0) {
      return 'Password does not match.';
    }
    return null;
  }

  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }

    if (value.trim().length < 4) {
      return 'Username must be at least 4 characters long';
    }

    if (value.length > 20) {
      return 'Username must not exceed 20 characters';
    }

    // Kiểm tra chỉ cho phép ký tự chữ cái và số
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }

    return null;
  }
}