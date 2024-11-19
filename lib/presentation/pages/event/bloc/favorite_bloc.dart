import 'package:bloc/bloc.dart';
import 'package:ezbooking/domain/usecases/events/favorite_event.dart';
import 'package:ezbooking/presentation/pages/event/bloc/favorite_event.dart';
import 'package:ezbooking/presentation/pages/event/bloc/favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteEventUseCase _favoriteEventUseCase;

  FavoriteBloc(this._favoriteEventUseCase) : super(FavoriteEventInitial()) {
    on<CheckFavoriteEvent>(
      (event, emit) async {
        try {
          emit(FavoriteEventLoading());
          bool isSaved = await _favoriteEventUseCase.check(
              eventID: event.eventID, userID: event.userID);
          isSaved ? emit(FavoriteEventSaved()) : emit(FavoriteEventUnSaved());
        } on Exception catch (e) {
          emit(FavoriteEventError(e.toString()));
        }
      },
    );

    on<SaveFavoriteEvent>(
      (event, emit) async {
        try {
          emit(FavoriteEventLoading());
          await _favoriteEventUseCase.save(
              eventID: event.eventID, userID: event.userID);
          emit(FavoriteEventSaved());
        } on Exception catch (e) {
          emit(FavoriteEventError(e.toString()));
        }
      },
    );

    on<UnSaveFavoriteEvent>(
      (event, emit) async {
        try {
          emit(FavoriteEventLoading());
          await _favoriteEventUseCase.unSave(
              eventID: event.eventID, userID: event.userID);
          emit(FavoriteEventUnSaved());
        } on Exception catch (e) {
          emit(FavoriteEventError(e.toString()));
        }
      },
    );

    on<ResetFavoriteEvent>(
      (event, emit) async {
        emit(FavoriteEventInitial());
      },
    );
  }
}
