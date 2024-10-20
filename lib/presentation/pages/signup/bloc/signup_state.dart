import 'package:ezbooking/data/models/user_creation.dart';

class SignupState {}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {
  final UserCreation user;

  SignupSuccess(this.user);
}

class SignupFailure extends SignupState {
  final String error;
  SignupFailure(this.error);
}
