import 'package:ezbooking/data/models/user_creation.dart';

class SignupEvent {}

class SignupSubmitted extends SignupEvent {
  final UserCreation user;

  SignupSubmitted(this.user);
}