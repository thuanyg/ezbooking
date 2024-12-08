import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezbooking/core/utils/dialogs.dart';
import 'package:ezbooking/data/models/user_creation.dart';
import 'package:ezbooking/presentation/pages/home/home_page.dart';
import 'package:ezbooking/presentation/pages/login/bloc/login_bloc.dart';
import 'package:ezbooking/presentation/pages/login/bloc/login_event.dart';
import 'package:ezbooking/presentation/pages/login/bloc/login_state.dart';
import 'package:ezbooking/presentation/pages/login/login_page.dart';
import 'package:ezbooking/presentation/pages/signup/bloc/signup_bloc.dart';
import 'package:ezbooking/presentation/pages/signup/bloc/signup_event.dart';
import 'package:ezbooking/presentation/pages/signup/bloc/signup_state.dart';
import 'package:ezbooking/core/config/app_colors.dart';
import 'package:ezbooking/core/config/app_styles.dart';
import 'package:ezbooking/core/config/app_validate.dart';
import 'package:ezbooking/presentation/widgets/auth_with_3rd.dart';
import 'package:ezbooking/presentation/widgets/button.dart';
import 'package:ezbooking/presentation/widgets/inputfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  static String routeName = "/SignInPage";

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();
  final _signUpFormKey = GlobalKey<FormState>();

  late LoginBloc loginBloc;

  @override
  Widget build(BuildContext context) {
    loginBloc = BlocProvider.of<LoginBloc>(context);
    return BlocListener(
      bloc: loginBloc,
      listener: (context, state) {
        if (state is LoginFailure) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Something went wrong. Please try again!")));
          });
        }

        if (state is LoginSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            String? token =
            await FirebaseMessaging.instance.getToken();

            await FirebaseFirestore.instance
                .collection("users")
                .doc(state.user?.uid)
                .update({"fcmToken": token});

            DialogUtils.hide(context);
            Navigator.pushNamedAndRemoveUntil(
                context,
                HomePage.routeName,
                    (Route<dynamic> route) => false).then(
                  (value) => loginBloc.add(Reset()),
            );
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
        ),
        body: BlocListener<SignupBloc, SignupState>(
          listener: (context, state) {
            if (state is SignupLoading) {
              DialogUtils.showLoadingDialog(context);
            }
            if (state is SignupSuccess) {
              DialogUtils.hide(context);
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
            }
            if (state is SignupFailure) {
              DialogUtils.hide(context);
              FirebaseAuth.instance.signOut();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.error),
                backgroundColor: AppColors.primaryColor,
              ));
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Center(
                child: Form(
                  key: _signUpFormKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
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
                        validator: (value) => Validator.validateConfirmPassword(
                            value, _passwordController),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
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
                      buildAuthWithGoogle(() {
                        DialogUtils.showLoadingDialog(context);
                        loginBloc.add(LoginGoogleSubmitted());
                      }),
                      const SizedBox(height: 16.0),
                      buildAuthWithFacebook(() => {}),
                      const SizedBox(height: 36.0),
                      Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: AppStyles.title2.copyWith(
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushReplacementNamed(LoginPage.routeName);
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
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void handleSignUp(BuildContext context) {
    String fullName = _fullNameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    if (_signUpFormKey.currentState?.validate() ?? false) {
      UserCreation user =
          UserCreation(fullName: fullName, email: email, password: password);
      BlocProvider.of<SignupBloc>(context).add(SignupSubmitted(user));
    }
  }
}
