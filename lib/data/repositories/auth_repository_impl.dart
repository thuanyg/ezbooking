import 'package:ezbooking/data/datasources/auth_datasource.dart';
import 'package:ezbooking/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDatasource authDatasource;

  AuthRepositoryImpl(this.authDatasource);

  @override
  Future<void> signUp(newUser) async {
    return await authDatasource.signUp(newUser);
  }

  @override
  Future<User?> signIn(String email, String password) async {
    return await authDatasource.signIn(email, password);
  }
}
