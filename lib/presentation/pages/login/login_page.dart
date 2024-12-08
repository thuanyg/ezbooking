import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezbooking/core/services/firebase_cloud_message.dart';
import 'package:ezbooking/core/utils/dialogs.dart';
import 'package:ezbooking/presentation/pages/home/home_page.dart';
import 'package:ezbooking/presentation/pages/login/bloc/login_bloc.dart';
import 'package:ezbooking/presentation/pages/login/bloc/login_event.dart';
import 'package:ezbooking/presentation/pages/login/bloc/login_state.dart';
import 'package:ezbooking/presentation/pages/resetpassword/reset_password.dart';
import 'package:ezbooking/presentation/pages/signup/signup_page.dart';
import 'package:ezbooking/core/config/app_validate.dart';
import 'package:ezbooking/presentation/widgets/auth_with_3rd.dart';
import 'package:ezbooking/presentation/widgets/button.dart';
import 'package:ezbooking/presentation/widgets/inputfield.dart';
import 'package:ezbooking/core/config/app_colors.dart';
import 'package:ezbooking/core/config/app_styles.dart';
import 'package:ezbooking/core/config/constants.dart';
import 'package:ezbooking/core/utils/image_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  final _loginFormKey = GlobalKey<FormState>();

  late LoginBloc loginBloc;

  @override
  void initState() {
    super.initState();
    loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Center(
            child: Form(
              key: _loginFormKey,
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  ImageHelper.loadAssetImage(
                    '${assetImageLink}img_logo.png',
                    height: 30,
                  ),
                  const SizedBox(height: 100.0),
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
                  const SizedBox(height: 8.0),
                  buildLoginOtherFunction(),
                  const SizedBox(height: 28.0),
                  BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      print("LOGIN STATE: $state");

                      if (state is LoginFailure) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          DialogUtils.hide(context);
                        });
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              state.error,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        );
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

                      return const SizedBox.shrink();
                    },
                  ),
                  MainElevatedButton(
                    textButton: "LOGIN",
                    iconName: "ic_button_next.png",
                    onTap: () {
                      handleLogin(context);
                    },
                  ),
                  const SizedBox(height: 24.0),
                  buildDivider(),
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
                          "Don’t have an account? ",
                          style: AppStyles.title2.copyWith(
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(SignupPage.routeName);
                          },
                          child: Text(
                            "Signup",
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row buildDivider() {
    return const Row(
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
    );
  }

  Row buildLoginOtherFunction() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Transform.scale(
              scale: .45,
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
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, ResetPassword.routeName);
              },
              child: Text(
                "Forgot password?",
                style: AppStyles.title2.copyWith(
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  handleLogin(BuildContext context) {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    if (_loginFormKey.currentState?.validate() ?? false) {
      DialogUtils.showLoadingDialog(context);
      loginBloc.add(LoginSubmitted(email, password));
    }
  }
}
