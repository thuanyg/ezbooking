import 'package:ezbooking/ui/pages/home_page.dart';
import 'package:ezbooking/ui/pages/login_page.dart';
import 'package:ezbooking/ui/pages/onboarding_page.dart';
import 'package:ezbooking/ui/pages/splash_page.dart';
import 'package:flutter/material.dart';

class Routes {
  static Map<String, WidgetBuilder> routes = {
    SplashPage.routName: (context) => const SplashPage(),
    HomePage.routeName: (context) => HomePage(),
    OnboardingPage.routeName: (context) => OnboardingPage(),
    LoginPage.routeName: (context) => const LoginPage(),
  };

}