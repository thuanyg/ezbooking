import 'package:ezbooking/data/models/user_model.dart';

abstract class UpdateUserState {}

class UpdateUserInitial extends UpdateUserState {}
class UpdateUserLoading extends UpdateUserState {}
class UpdateUserSuccess extends UpdateUserState {
  final UserModel userModel;

  UpdateUserSuccess(this.userModel);
}
class UpdateUserError extends UpdateUserState {
  String message;

  UpdateUserError(this.message);
}
