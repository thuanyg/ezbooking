import 'package:ezbooking/data/models/user_model.dart';
import 'package:ezbooking/domain/repositories/user_repository.dart';

class FetchUserInfoUseCase {
  final UserRepository _userRepository;

  FetchUserInfoUseCase(this._userRepository);

  Future<UserModel> call(String id) async {
    return await _userRepository.fetchUserInformation(id);
  }
}
