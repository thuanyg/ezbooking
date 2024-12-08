import 'package:ezbooking/data/models/user_creation.dart';
import 'package:ezbooking/data/models/user_creation_response.dart';
import 'package:ezbooking/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthUseCase {
  final AuthRepository authRepository;

  AuthUseCase(this.authRepository);

  Future<void> signUp(UserCreation newUser) async {
    return await authRepository.signUp(newUser);
  }

  Future<User?> signIn(String email, String password) async {
    return await authRepository.signIn(email, password);
  }

  Future<User?> signInWithGoogle() async {
    return await authRepository.signInWithGoogle();
  }
}