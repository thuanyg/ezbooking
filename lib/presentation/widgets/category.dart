import 'package:ezbooking/core/config/app_styles.dart';
import 'package:flutter/material.dart';

Widget buildCategory(
    {required String categoryName,
    required Color color,
    required VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 39,
      margin: const EdgeInsets.symmetric(horizontal: 6.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          categoryName,
          style: AppStyles.h5.copyWith(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ),
  );
}
