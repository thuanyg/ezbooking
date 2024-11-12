import 'package:bloc/bloc.dart';
import 'package:ezbooking/domain/usecases/events/favorite_event.dart';
import 'package:ezbooking/presentation/pages/event/bloc/fetch_favorite_event.dart';
import 'package:ezbooking/presentation/pages/event/bloc/fetch_favorite_state.dart';

class FetchFavoriteBloc extends Bloc<FetchFavoriteEvent, FetchFavoriteState> {
  final FavoriteEventUseCase _favoriteEventUseCase;

  FetchFavoriteBloc(this._favoriteEventUseCase)
      : super(FetchFavoriteInitial()) {
    on<FetchFavorite>(
      (event, emit) async {
        try {
          emit(FetchFavoriteLoading());
          final events = await _favoriteEventUseCase.get(userID: event.userID);
          emit(FetchFavoriteSuccess(events));
        } on Exception catch (e) {
          emit(FetchFavoriteError(e.toString()));
        }
      },
    );
  }
}
