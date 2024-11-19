import 'package:ezbooking/core/config/app_colors.dart';
import 'package:ezbooking/core/config/app_styles.dart';
import 'package:ezbooking/presentation/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VerificationPage extends StatelessWidget {
  static String routeName = "/VerificationPage";

  VerificationPage({super.key});

  String email = "thuan2682k3@gmail.com";

  final List<TextEditingController> _otpController = List.generate(4, (index) => TextEditingController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
        child: Center(
          child: Column(
            children: [
              Text(
                "Verification",
                style: AppStyles.h3.copyWith(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "We’ve send you the verification code on $email",
                style: AppStyles.title1.copyWith(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w200,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              buildOTP(context),
              const SizedBox(height: 24),
              Text(
                "Re-send code in 0:20",
                style: AppStyles.title2.copyWith(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w200,
                    color: AppColors.primaryColor),
                textAlign: TextAlign.center,
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: MainElevatedButton(
                      iconName: "ic_button_next.png",
                      textButton: "CONTINUE",
                      onTap: () {}),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOTP(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (int i = 0; i < 4; i++)
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xffE4DFDF), width: 2.5),
            ),
            child: TextField(
              controller: _otpController[i],
              style: AppStyles.h5,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                border: InputBorder.none,
                counter: SizedBox.shrink(),
              ),
              maxLength: 1,
              autofocus: true,
              onChanged: (value) {
                if (value.length == 1) {
                  if (i < _otpController.length - 1) {
                    FocusScope.of(context).nextFocus();
                  } else {
                    FocusScope.of(context).unfocus();
                    // _verifyOtp(); // Call your OTP verification method
                  }
                }
              },
            ),
          ),
      ],
    );
  }
}
