import 'package:ezbooking/widgets/button.dart';
import 'package:ezbooking/widgets/inputfield.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {

  static String routeName = "/HomePage";

  HomePage({super.key});

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MainElevatedButton(
                textButton: "Buy Now",
                iconName: "ic_button_next.png",
                onTap: () {},
              ),
              const SizedBox(height: 16.0),
              MainOutlineButton(
                textButton: "Explore Event",
                iconName: "ic_button_next.png",
                onTap: () {},
              ),
              const SizedBox(height: 16.0),
              RIConElevatedButton(
                textButton: "Chat",
                iconName: "ic_chat_outlined.png",
                onTap: () {},
              ),
              const SizedBox(height: 16.0),
              RIConOutlineButton(
                textButton: "Edit Profile",
                iconName: "ic_edit_outlined.png",
                onTap: () {},
              ),
              const SizedBox(height: 16.0),
              Form(
                key: _formKey,
                child: CustomInputField(
                  label: "abc@domain",
                  prefixIconName: "ic_chat_outlined.png",
                  validator: (value) {
                    if(value == null || value.trim() == ""){
                      return "Please enter your email";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              RIConOutlineButton(
                textButton: "Login",
                onTap: () {
                  _formKey.currentState?.validate();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}