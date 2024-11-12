import 'package:ezbooking/data/datasources/users/user_datasource.dart';
import 'package:ezbooking/data/models/comment.dart';
import 'package:ezbooking/data/models/user_model.dart';
import 'package:ezbooking/domain/repositories/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final UserDatasource _datasource;

  UserRepositoryImpl(this._datasource);

  @override
  Future<UserModel> fetchUserInformation(String id) async {
    return await _datasource.fetchUserInformation(id);
  }

  @override
  Future<void> updateInformation(String id, UserModel userUpdate) async {
    return await _datasource.updateInformation(id, userUpdate);
  }

  @override
  Future<void> comment(Comment comment) async {
    return await _datasource.comment(comment);
  }
}
