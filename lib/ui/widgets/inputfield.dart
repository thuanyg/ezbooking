import 'package:ezbooking/utils/app_styles.dart';
import 'package:ezbooking/utils/constants.dart';
import 'package:ezbooking/utils/image_helper.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget CustomInputField(
    {String? label,
    String? prefixIconName,
    TextEditingController? controller,
    FormFieldValidator<String>? validator}) {
  return TextFormField(
    controller: controller,
    validator: validator,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red.shade300),
      ),
      prefixIcon: prefixIconName != null
          ? ImageHelper.loadAssetImage(assetImageLink + prefixIconName)
          : null,
      label: Text(
        label!,
        style: AppStyles.inputField.copyWith(color: Colors.grey),
      ),
    ),
  );
}
