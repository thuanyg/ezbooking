import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ezbooking/domain/usecases/auth/auth_usecase.dart';
import 'package:ezbooking/presentation/pages/login/bloc/login_event.dart';
import 'package:ezbooking/presentation/pages/login/bloc/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthUseCase _authUseCase;

  LoginBloc(this._authUseCase) : super(LoginInitial()) {
    on<LoginSubmitted>(
      (event, emit) async {
        try {
          emit(LoginLoading());
          User? user = await _authUseCase.signIn(event.email, event.password);
          emit(
            LoginSuccess(user),
          );
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            emit(LoginFailure('No user found for that email.'));
          } else if (e.code == 'wrong-password') {
            emit(LoginFailure('Wrong password provided.'));
          } else if (e.code == 'invalid-email') {
            emit(LoginFailure('The email address is not valid.'));
          } else if (e.code == 'user-disabled') {
            emit(LoginFailure('This user has been disabled.'));
          } else {
            // Handle other unexpected errors
            emit(LoginFailure('Login failed. Please try again.'));
          }
        } catch (e) {
          // Catch any other exceptions
          emit(LoginFailure('An unexpected error occurred.'));
        }
      },
    );
  }
}
