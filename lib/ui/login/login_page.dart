import 'package:ezbooking/repository/auth_repository.dart';
import 'package:ezbooking/services/auth_service.dart';
import 'package:ezbooking/ui/login/bloc/login_bloc.dart';
import 'package:ezbooking/ui/login/bloc/login_event.dart';
import 'package:ezbooking/ui/login/bloc/login_state.dart';
import 'package:ezbooking/ui/signup/signup_page.dart';
import 'package:ezbooking/utils/app_validate.dart';
import 'package:ezbooking/widgets/auth_with_3rd.dart';
import 'package:ezbooking/widgets/button.dart';
import 'package:ezbooking/widgets/inputfield.dart';
import 'package:ezbooking/utils/app_colors.dart';
import 'package:ezbooking/utils/app_styles.dart';
import 'package:ezbooking/utils/constants.dart';
import 'package:ezbooking/utils/image_helper.dart';
import 'package:flutter/cupertino.dart';
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

  late final AuthRepository authRepository;
  bool _switchRememberMe = true;

  final _loginFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    authRepository = AuthRepositoryImpl(AuthService());
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<LoginBloc>(
      create: (_) => LoginBloc(authRepository),
      child: BlocBuilder<LoginBloc, LoginState>(
          bloc: LoginBloc(authRepository),
          builder: (context, state) {
            return Scaffold(
              backgroundColor: const Color(0xFFEFEFEF),
              body: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
                child: Center(
                  child: Form(
                    key: _loginFormKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 72),
                        ImageHelper.loadAssetImage(
                            '${assetImageLink}ic_launcher.png'),
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
                          textButton: "LOGIN",
                          iconName: "ic_button_next.png",
                          onTap: () {
                            handleLogin(context);
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
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  handleLogin(BuildContext context) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    if (_loginFormKey.currentState?.validate()  ?? false) {
      BlocProvider.of<LoginBloc>(context).add(LoginEvent(email, password));
    }
  }
}
