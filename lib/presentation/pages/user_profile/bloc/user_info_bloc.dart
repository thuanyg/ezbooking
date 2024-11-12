import 'package:bloc/bloc.dart';
import 'package:ezbooking/data/models/user_model.dart';
import 'package:ezbooking/domain/usecases/user/fetch_user_info.dart';
import 'package:ezbooking/presentation/pages/user_profile/bloc/user_info_event.dart';
import 'package:ezbooking/presentation/pages/user_profile/bloc/user_info_state.dart';

class UserInfoBloc extends Bloc<UserInfoEvent, UserInfoState> {
  final FetchUserInfoUseCase _fetchUserInfoUseCase;
  UserModel? user;
  UserInfoBloc(this._fetchUserInfoUseCase) : super(UserInfoInitial()) {
    on<FetchUserInfo>(
      (event, emit) async {
        try {
          emit(UserInfoLoading());
          final user = await _fetchUserInfoUseCase(event.uid);
          this.user = user;
          emit(UserInfoLoaded(user));
        } on Exception catch (e) {
          emit(UserInfoError(e.toString()));
        }
      },
    );

  }

  void emitUser(UserModel user){
    emit(UserInfoLoaded(user));
  }
}
