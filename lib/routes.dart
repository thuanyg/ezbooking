import 'package:ezbooking/ui/pages/home_page.dart';
import 'package:ezbooking/ui/login/login_page.dart';
import 'package:ezbooking/ui/onboarding/onboarding_page.dart';
import 'package:ezbooking/ui/pages/splash_page.dart';
import 'package:ezbooking/ui/reset_password/reset_password.dart';
import 'package:ezbooking/ui/signup/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:ezbooking/ui/verification/verification_page.dart';

class Routes {
  static Map<String, WidgetBuilder> routes = {
    SplashPage.routName: (context) => const SplashPage(),
    HomePage.routeName: (context) => HomePage(),
    OnboardingPage.routeName: (context) => const OnboardingPage(),
    LoginPage.routeName: (context) => LoginPage(),
    SignupPage.routeName: (context) => SignupPage(),
    VerificationPage.routeName: (context) => VerificationPage(),
    ResetPassword.routeName: (context) => const ResetPassword(),
  };

}