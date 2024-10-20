import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ezbooking/domain/usecases/auth/auth_usecase.dart';
import 'package:ezbooking/presentation/pages/signup/bloc/signup_event.dart';
import 'package:ezbooking/presentation/pages/signup/bloc/signup_state.dart';

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
    } catch (e) {
      emit(SignupFailure(e.toString()));
    }
  }
}
