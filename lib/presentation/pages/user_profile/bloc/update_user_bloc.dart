import 'package:bloc/bloc.dart';
import 'package:ezbooking/domain/usecases/user/update_user_info.dart';
import 'package:ezbooking/presentation/pages/user_profile/bloc/update_user_event.dart';
import 'package:ezbooking/presentation/pages/user_profile/bloc/update_user_state.dart';

class UpdateUserBloc extends Bloc<UpdateUserEvent, UpdateUserState> {
  final UpdateUserInfoUseCase _updateUserInfoUseCase;

  UpdateUserBloc(this._updateUserInfoUseCase) : super(UpdateUserInitial()) {
    on<UpdateUserInformation>(
      (event, emit) async {
        try {
          emit(UpdateUserLoading());
          await _updateUserInfoUseCase.call(event.id, event.userUpdate);
          emit(UpdateUserSuccess(event.userUpdate));
        } on Exception catch (e) {
          emit(UpdateUserError(e.toString()));
        }
      },
    );
  }
}
