import 'package:ezbooking/ui/pages/home_page.dart';
import 'package:ezbooking/utils/app_colors.dart';
import 'package:ezbooking/utils/app_styles.dart';
import 'package:ezbooking/utils/constants.dart';
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
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, HomePage.routeName);
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset("${assetAnimationLink}splash_anm.json", height: 100),
            Text("Welcome to EzBooking", style: AppStyles.h4.copyWith(color: AppColors.primaryColor))
          ],
        ),
      ),
    );
  }
}