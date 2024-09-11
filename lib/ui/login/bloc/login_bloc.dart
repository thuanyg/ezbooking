import 'package:bloc/bloc.dart';
import 'package:ezbooking/repository/auth_repository.dart';
import 'package:ezbooking/services/auth_service.dart';
import 'package:ezbooking/ui/login/bloc/login_event.dart';
import 'package:ezbooking/ui/login/bloc/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc(this.authRepository) : super(LoginState()) {
    on<LoginEvent>(
      (event, emit) => login(event, emit),
    );
  }

  login(LoginEvent event, Emitter<LoginState> emit) async {
    await authRepository.loginWithEmailAndPassword(
        email: event.email, password: event.password);
  }
}
