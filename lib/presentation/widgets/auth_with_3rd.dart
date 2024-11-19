import 'package:ezbooking/core/config/app_colors.dart';
import 'package:ezbooking/core/config/app_styles.dart';
import 'package:ezbooking/core/config/constants.dart';
import 'package:ezbooking/core/utils/image_helper.dart';
import 'package:flutter/material.dart';

Widget buildAuthWithGoogle(VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    splashColor: Colors.white70,
    child: Container(
      height: mainButtonHeight,
      width: mainButtonWidth,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageHelper.loadAssetImage("${assetImageLink}ic_google.png",
                height: 26),
            const SizedBox(width: 8.0),
            Text(
              "Login with Google",
              style: AppStyles.title2,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildAuthWithFacebook(VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    splashColor: Colors.white70,
    child: Container(
      height: mainButtonHeight,
      width: mainButtonWidth,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageHelper.loadAssetImage("${assetImageLink}ic_facebook.png",
                height: 26),
            const SizedBox(width: 8.0),
            Text(
              "Login with Facebook",
              style: AppStyles.title2,
            ),
          ],
        ),
      ),
    ),
  );
}
