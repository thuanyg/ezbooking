import 'package:ezbooking/data/models/user_creation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  User? user;

  LoginSuccess(this.user);
}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}
