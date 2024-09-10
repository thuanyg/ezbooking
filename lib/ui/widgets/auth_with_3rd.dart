import 'package:ezbooking/utils/app_colors.dart';
import 'package:ezbooking/utils/app_styles.dart';
import 'package:ezbooking/utils/constants.dart';
import 'package:ezbooking/utils/image_helper.dart';
import 'package:flutter/material.dart';

Widget buildAuthWithGoogle(VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: 56,
      width: 273,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.transparent),
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
    child: Container(
      height: 56,
      width: 273,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.transparent),
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
