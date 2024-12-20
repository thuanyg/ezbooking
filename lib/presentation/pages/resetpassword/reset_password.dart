import 'package:ezbooking/core/config/app_styles.dart';
import 'package:ezbooking/core/utils/dialogs.dart';
import 'package:ezbooking/presentation/widgets/button.dart';
import 'package:ezbooking/presentation/widgets/inputfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatelessWidget {
  ResetPassword({super.key});

  static String routeName = "/ResetPassword";
  final _emailController = TextEditingController();

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
                controller: _emailController,
                prefixIconName: "ic_email_outlined.png",
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: MainElevatedButton(
                    iconName: "ic_button_next.png",
                    textButton: "CONTINUE",
                    onTap: () async {
                      String email = _emailController.text.trim();
                      final FirebaseAuth _auth = FirebaseAuth.instance;
                      if (email.isEmpty) {
                        _showMessage(
                            context, 'Please enter your email address.');
                        return;
                      }

                      try {
                        DialogUtils.showLoadingDialog(context);
                        await _auth.sendPasswordResetEmail(email: email);
                        _showMessage(context,
                            'Password reset email sent! Please check your inbox.');
                      } catch (e) {
                        _showMessage(context, 'Email is not valid. Please enter again!');
                      } finally {
                        DialogUtils.hide(context);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
