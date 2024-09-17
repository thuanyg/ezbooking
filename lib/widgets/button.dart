import 'package:ezbooking/utils/app_colors.dart';
import 'package:ezbooking/utils/constants.dart';
import 'package:ezbooking/utils/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:ezbooking/utils/app_styles.dart';

Widget MainElevatedButton(
    {double width = 320,
    double height = 58,
    String textButton = "",
    String iconName = "",
    Function()? onTap}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(15),
    child: Container(
      clipBehavior: Clip.antiAlias,
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 24.0),
          Expanded(
            child: Center(
              child: Text(
                textButton,
                style: AppStyles.button.copyWith(color: Colors.white),
              ),
            ),
          ),
          iconName != ""
              ? ImageHelper.loadAssetImage(assetImageLink + iconName)
              : const SizedBox.shrink(),
          const SizedBox(width: 8.0),
        ],
      ),
    ),
  );
}

// ignore: non_constant_identifier_names
Widget MainOutlineButton(
    {double width = 320,
    double height = 58,
    String textButton = "",
    String iconName = "",
    Function()? onTap}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(15),
    child: Container(
      clipBehavior: Clip.antiAlias,
      height: height,
      width: width,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryColor),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 16.0),
          Expanded(
            child: Center(
              child: Text(
                textButton,
                style: AppStyles.button.copyWith(color: AppColors.primaryColor),
              ),
            ),
          ),
          iconName != ""
              ? ImageHelper.loadAssetImage(assetImageLink + iconName)
              : const SizedBox.shrink(),
          const SizedBox(width: 8.0),
        ],
      ),
    ),
  );
}

// ignore: non_constant_identifier_names
Widget RIConOutlineButton(
    {double width = 154,
    double height = 50,
    String textButton = "",
    String iconName = "",
    Function()? onTap}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(15),
    child: Container(
      clipBehavior: Clip.antiAlias,
      height: height,
      width: width,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryColor),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconName != ""
              ? ImageHelper.loadAssetImage(assetImageLink + iconName)
              : const SizedBox.shrink(),
          const SizedBox(width: 16.0),
          Center(
            child: Text(
              textButton,
              style: AppStyles.button.copyWith(
                  color: AppColors.primaryColor, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget RIConElevatedButton(
    {double width = 154,
    double height = 50,
    String textButton = "",
    String iconName = "",
    Function()? onTap}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(15),
    child: Container(
      clipBehavior: Clip.antiAlias,
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconName != ""
              ? ImageHelper.loadAssetImage(assetImageLink + iconName,
                  tintColor: Colors.white)
              : const SizedBox.shrink(),
          const SizedBox(width: 16.0),
          Center(
            child: Text(
              textButton,
              style: AppStyles.button.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget StandardElevatedButton(
    {double height = 28, String textButton = "", Function()? onTap}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(15),
    child: Container(
      clipBehavior: Clip.antiAlias,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Center(
        child: Text(
          textButton,
          style: AppStyles.button.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: 12),
        ),
      ),
    ),
  );
}

Widget StandardOutlinedButton(
    {double height = 28, String textButton = "", Function()? onTap}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(15),
    child: Container(
      clipBehavior: Clip.antiAlias,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.outlinedButtonColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Center(
        child: Text(
          textButton,
          style: AppStyles.button.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.primaryColor,
              fontSize: 12),
        ),
      ),
    ),
  );
}
