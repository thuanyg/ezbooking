import 'package:ezbooking/data/models/user_creation.dart';

class LoginEvent {}

class LoginSubmitted extends LoginEvent {
  String email, password;

  LoginSubmitted(this.email, this.password);
}
class LoginGoogleSubmitted extends LoginEvent {}

class Reset extends LoginEvent {}
