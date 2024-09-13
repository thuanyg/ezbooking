import 'package:ezbooking/utils/app_styles.dart';
import 'package:ezbooking/widgets/button.dart';
import 'package:ezbooking/widgets/inputfield.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});
  static String routeName = "/ResetPassword";
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
                "Reset Password",
                style: AppStyles.h3.copyWith(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Please enter your email address to request a password reset",
                style: AppStyles.title1.copyWith(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w200,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              CustomInputField(
                label: "abc@email.com",
                prefixIconName: "ic_email_outlined.png",
              ),
              const SizedBox(height: 24),
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
}
