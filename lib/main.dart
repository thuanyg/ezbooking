import 'package:ezbooking/routes.dart';
import 'package:ezbooking/ui/pages/splash_page.dart';
import 'package:ezbooking/ui/widgets/inputfield.dart';
import 'package:flutter/material.dart';
import 'package:ezbooking/ui/widgets/button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EzBooking Application',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: Routes.routes,
      home: const SplashPage(),
    );
  }
}


