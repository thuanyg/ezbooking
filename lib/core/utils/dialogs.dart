import 'package:ezbooking/core/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DialogUtils {
  static Future<void> showLoadingDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Lottie.asset(
                '${assetAnimationLink}loading.json',
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context).pop(); // Đóng dialog
  }
}