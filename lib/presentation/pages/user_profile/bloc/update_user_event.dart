import 'package:ezbooking/data/models/user_model.dart';

abstract class UpdateUserEvent {}

class UpdateUserInformation extends UpdateUserEvent {
  final String id;
  final UserModel userUpdate;

  UpdateUserInformation(this.id, this.userUpdate);
}
