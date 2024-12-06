import 'package:ezbooking/data/models/comment.dart';
import 'package:ezbooking/data/models/user_model.dart';

abstract class UserDatasource {
  Future<UserModel> fetchUserInformation(String id);

  Future<void> updateInformation(String id, UserModel userUpdate);

  Future<void> comment(Comment comment);

  Future<void> deleteComment(String id);

  Future<void> updateComment(Comment comment);
}
