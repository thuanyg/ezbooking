import 'package:ezbooking/data/models/user_model.dart';
import 'package:ezbooking/domain/repositories/user_repository.dart';

class UpdateUserInfoUseCase {
  final UserRepository _userRepository;

  UpdateUserInfoUseCase(this._userRepository);

  Future<void> call(String id, UserModel user) async {
    return await _userRepository.updateInformation(id, user);
  }
}
