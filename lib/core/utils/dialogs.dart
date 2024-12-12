import 'package:ezbooking/core/config/app_colors.dart';
import 'package:ezbooking/core/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DialogUtils {
  static Future<void> showLoadingDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Center(
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
          ),
        );
      },
    );
  }

  static void showWarningDialog({
    required BuildContext context,
    required String title,
    bool canDismissible = true,
    required VoidCallback onClickOutSide,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: canDismissible,
      barrierLabel: '',
      pageBuilder: (BuildContext context, _, __) {
        return Container(
          margin: const EdgeInsets.only(left: 12, right: 12),
          alignment: Alignment.center,
          child: Material(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              height: 175,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 28,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: Lottie.asset(
                      "${assetAnimationLink}warning.json",
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: "BeVietnam",
                        color: Color(0xff1b1e25),
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).then((value) {
      // ìf click outside => value = null
      if (value == null) {
        onClickOutSide();
      }
    });
  }

  static Future showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String textCancelButton,
    required String textAcceptButton,
    required VoidCallback acceptPressed,
    bool reverseButton = false,
  }) async {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (BuildContext context, _, __) {
        return Container(
          margin: const EdgeInsets.only(left: 12, right: 12),
          alignment: Alignment.center,
          child: Material(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 36),
                      Expanded(
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: const Color(0xffEEEEEE),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                textCancelButton,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: acceptPressed,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                textAcceptButton,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 36),
                    ],
                  ),
                ],
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
