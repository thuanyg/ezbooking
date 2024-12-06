import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ezbooking/domain/usecases/auth/auth_usecase.dart';
import 'package:ezbooking/presentation/pages/signup/bloc/signup_event.dart';
import 'package:ezbooking/presentation/pages/signup/bloc/signup_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthUseCase _authUseCase;

  SignupBloc(this._authUseCase) : super(SignupInitial()) {
    on<SignupSubmitted>(_handlerSignUp);
  }

  FutureOr<void> _handlerSignUp(SignupSubmitted event, emit) async {
    emit(SignupLoading());
    try {
      await _authUseCase.signUp(event.user);
      emit(
        SignupSuccess(event.user),
      );
    } on FirebaseAuthException catch (e) {
      String error = "Error when signing up account!";
      if (e.code == 'email-already-in-use') {
        error = 'This email is already in use. Please try logging in.';
      } else if (e.code == 'weak-password') {
        error = 'Your password is too weak. Please choose a stronger password.';
      } else if (e.code == 'invalid-email') {
        error = 'The email address is not valid. Please check and try again.';
      } else if (e.code == 'operation-not-allowed') {
        error = 'Email/password accounts are not enabled. Please contact support.';
      } else {
        throw Exception('An unknown error occurred: ${e.message}');
      }
      emit(SignupFailure(error));
    }
  }
}
