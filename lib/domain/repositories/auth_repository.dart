import 'package:ezbooking/data/models/user_creation.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<User?> signIn(String email, String password);
  Future<void> signUp(UserCreation newUser);
  Future<User?> signInWithGoogle();
}