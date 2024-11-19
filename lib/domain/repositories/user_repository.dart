import 'package:ezbooking/data/models/comment.dart';
import 'package:ezbooking/data/models/user_model.dart';

abstract class UserRepository {
  Future<UserModel> fetchUserInformation(String id);

  Future<void> updateInformation(String id, UserModel userUpdate);

  Future<void> comment(Comment comment);
}
