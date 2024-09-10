import 'package:ezbooking/ui/widgets/auth_with_3rd.dart';
import 'package:ezbooking/ui/widgets/button.dart';
import 'package:ezbooking/ui/widgets/inputfield.dart';
import 'package:ezbooking/utils/app_colors.dart';
import 'package:ezbooking/utils/app_styles.dart';
import 'package:ezbooking/utils/constants.dart';
import 'package:ezbooking/utils/image_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static String routeName = "/LoginPage";

  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  bool _switchRememberMe = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEBEB),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 72),
              ImageHelper.loadAssetImage('${assetImageLink}ic_launcher.png'),
              const SizedBox(height: 8.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Sign in",
                  style: AppStyles.h4.copyWith(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 23.0),
              CustomInputField(
                controller: _emailController,
                label: "abc@email.com",
                prefixIconName: "ic_email_outlined.png",
              ),
              const SizedBox(height: 18.0),
              CustomInputField(
                controller: _passwordController,
                obscureText: true,
                label: "Your password",
                prefixIconName: "ic_lock_outlined.png",
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Transform.scale(
                        scale: .5,
                        child: Switch(
                          value: _switchRememberMe,
                          onChanged: (value) {
                            setState(() {
                              _switchRememberMe = value;
                            });
                          },
                        ),
                      ),
                      Text(
                        "Remember me",
                        style: AppStyles.title2.copyWith(
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Forgot password?",
                          style: AppStyles.title2.copyWith(
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 36.0),
              MainElevatedButton(
                textButton: "Sign in",
                iconName: "ic_button_next.png",
                onTap: () {},
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
                        onPressed: () {},
                        child: Text(
                          "Sign up",
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
    );
  }
}
