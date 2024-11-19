import 'package:ezbooking/data/models/user_model.dart';

abstract class UserInfoState {}

class UserInfoInitial extends UserInfoState {}

class UserInfoLoading extends UserInfoState {}

class UserInfoLoaded extends UserInfoState {
  final UserModel user;

  UserInfoLoaded(this.user);
}

class UserInfoError extends UserInfoState {
  String error;

  UserInfoError(this.error);
}
