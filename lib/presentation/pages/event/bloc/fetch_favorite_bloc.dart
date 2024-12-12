import 'package:bloc/bloc.dart';
import 'package:ezbooking/data/models/event.dart';
import 'package:ezbooking/domain/usecases/events/favorite_event.dart';
import 'package:ezbooking/presentation/pages/event/bloc/fetch_favorite_event.dart';
import 'package:ezbooking/presentation/pages/event/bloc/fetch_favorite_state.dart';

class FetchFavoriteBloc extends Bloc<FetchFavoriteEvent, FetchFavoriteState> {
  final FavoriteEventUseCase _favoriteEventUseCase;

  List<Event> eventsOriginal = [];

  FetchFavoriteBloc(this._favoriteEventUseCase)
      : super(FetchFavoriteInitial()) {
    on<FetchFavorite>(
      (event, emit) async {
        try {
          emit(FetchFavoriteLoading());
          final events = await _favoriteEventUseCase.get(userID: event.userID);
          eventsOriginal = List.from(events);
          emit(FetchFavoriteSuccess(events));
        } on Exception catch (e) {
          emit(FetchFavoriteError(e.toString()));
        }
      },
    );

    on<SearchFavorite>(
      (event, emit) async {
        if (state is FetchFavoriteSuccess) {
          final filteredEvents = eventsOriginal.where((eventItem) {
            return eventItem.name
                    .toLowerCase()
                    .contains(event.query.toLowerCase()) ||
                eventItem.location
                    .toLowerCase()
                    .contains(event.query.toLowerCase());
          }).toList();
          emit(FetchFavoriteSuccess(filteredEvents));
        }
      },
    );
  }

  void emitEventsFetched(){
    emit(FetchFavoriteSuccess(eventsOriginal));
  }
}
