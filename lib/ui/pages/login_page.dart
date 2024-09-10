import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {

  static String routeName = "/LoginPage";

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Login Page"),
      ),
    );
  }
}
