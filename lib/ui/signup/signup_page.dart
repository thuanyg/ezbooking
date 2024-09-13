import 'package:ezbooking/ui/login/login_page.dart';
import 'package:ezbooking/ui/verification/verification_page.dart';
import 'package:ezbooking/utils/app_colors.dart';
import 'package:ezbooking/utils/app_styles.dart';
import 'package:ezbooking/utils/app_validate.dart';
import 'package:ezbooking/utils/constants.dart';
import 'package:ezbooking/utils/image_helper.dart';
import 'package:ezbooking/widgets/auth_with_3rd.dart';
import 'package:ezbooking/widgets/button.dart';
import 'package:ezbooking/widgets/inputfield.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});
  static String routeName = "/SignInPage";

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();
  final _signUpFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
        child: Center(
          child: Form(
            key: _signUpFormKey,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Register",
                    style: AppStyles.h4.copyWith(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 18.0),
                CustomInputField(
                  controller: _fullNameController,
                  label: "Full name",
                  prefixIconName: "ic_profile.png",
                  validator: Validator.validateFullName,
                ),
                const SizedBox(height: 23.0),
                CustomInputField(
                  controller: _emailController,
                  label: "abc@email.com",
                  prefixIconName: "ic_email_outlined.png",
                  validator: Validator.validateEmail,
                ),
                const SizedBox(height: 18.0),
                CustomInputField(
                  controller: _passwordController,
                  obscureText: true,
                  label: "Your password",
                  prefixIconName: "ic_lock_outlined.png",
                  validator: Validator.validatePassword,
                ),
                const SizedBox(height: 18.0),
                CustomInputField(
                  controller: _rePasswordController,
                  obscureText: true,
                  label: "Confirm password",
                  prefixIconName: "ic_lock_outlined.png",
                  validator: (value) => Validator.validateConfirmPassword(value, _passwordController),
                ),
                const SizedBox(height: 36.0),
                MainElevatedButton(
                  textButton: "SIGN UP",
                  iconName: "ic_button_next.png",
                  onTap: () {
                    handleSignUp(context);
                  },
                ),
                const SizedBox(height: 24.0),
                const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'OR',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                buildAuthWithGoogle(() => {}),
                const SizedBox(height: 16.0),
                buildAuthWithFacebook(() => {}),
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don’t have an account? ",
                          style: AppStyles.title2.copyWith(
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(LoginPage.routeName);
                          },
                          child: Text(
                            "Sign in",
                            style: AppStyles.title2.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryColor,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void handleSignUp(BuildContext context) {
    String fullName = _emailController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    if (_signUpFormKey.currentState?.validate()  ?? false) {
      // BlocProvider.of<LoginBloc>(context).add(LoginEvent(email, password));
    }
    Navigator.of(context).pushNamed(VerificationPage.routeName);
  }
}
