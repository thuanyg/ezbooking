import 'package:ezbooking/core/utils/storage.dart';
import 'package:ezbooking/presentation/pages/home/home_page.dart';
import 'package:ezbooking/presentation/pages/login/login_page.dart';
import 'package:ezbooking/presentation/pages/onboarding/onboarding_page.dart';
import 'package:ezbooking/core/config/app_colors.dart';
import 'package:ezbooking/core/config/app_styles.dart';
import 'package:ezbooking/core/config/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends StatefulWidget {
  static String routName = "/SplashPage";

  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    handleNavigate(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset("${assetAnimationLink}splash_anm.json",
                height: 100),
            Text("Welcome to EzBooking",
                style: AppStyles.h4.copyWith(color: AppColors.primaryColor))
          ],
        ),
      ),
    );
  }

  void handleNavigate(BuildContext context) async {
    String? firstRun = await StorageUtils.getValue(key: "isFirstRun");

    if (firstRun == null || firstRun != "No") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamed(OnboardingPage.routeName);
      });
      return;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          Navigator.of(context).pushNamed(HomePage.routeName);
        } else {
          Navigator.of(context).pushNamed(LoginPage.routeName);
        }
      });
    }
  }
}
