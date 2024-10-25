import 'package:ezbooking/presentation/pages/event/event_upcoming.dart';
import 'package:ezbooking/presentation/pages/home/home_page.dart';
import 'package:ezbooking/presentation/pages/login/login_page.dart';
import 'package:ezbooking/presentation/pages/onboarding/onboarding_page.dart';
import 'package:ezbooking/presentation/pages/splash/splash_page.dart';
import 'package:ezbooking/presentation/pages/resetpassword/reset_password.dart';
import 'package:ezbooking/presentation/pages/signup/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:ezbooking/presentation/pages/verification/verification_page.dart';
import 'package:ezbooking/presentation/pages/event/event_detail.dart';

class Routes {
  static Map<String, WidgetBuilder> routes = {
    SplashPage.routName: (context) => const SplashPage(),
    HomePage.routeName: (context) => HomePage(),
    OnboardingPage.routeName: (context) => const OnboardingPage(),
    LoginPage.routeName: (context) => LoginPage(),
    SignupPage.routeName: (context) => SignupPage(),
    VerificationPage.routeName: (context) => VerificationPage(),
    ResetPassword.routeName: (context) => const ResetPassword(),
    EventDetail.routeName: (context) => const EventDetail(),
    EventUpComingPage.routeName: (context) => const EventUpComingPage(),
  };

}