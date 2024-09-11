import 'package:ezbooking/services/auth_service.dart';

abstract class AuthRepository {
  Future<void> loginWithEmailAndPassword({required String email, required String password}) async {}
}

class AuthRepositoryImpl extends AuthRepository {
  AuthService _authService;

  AuthRepositoryImpl(this._authService);

  @override
  Future<void> loginWithEmailAndPassword({required String email, required String password}) async {
    try{
      await _authService.loginWithEmailAndPassword(email, password);
    } catch (e){
      print(e);
    }
  }
}