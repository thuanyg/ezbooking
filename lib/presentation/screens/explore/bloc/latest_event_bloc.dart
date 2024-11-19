import 'package:bloc/bloc.dart';
import 'package:ezbooking/domain/usecases/events/fetch_events_latest.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/latest_event_event.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/latest_event_state.dart';

class LatestEventBloc extends Bloc<LatestEventEvent, LatestEventState> {
  final FetchEventsLatestUseCase _fetchEventsLatestUseCase;

  LatestEventBloc(this._fetchEventsLatestUseCase)
      : super(LatestEventInitial()) {
    on<FetchLatestEvent>((event, emit) async {
      try {
        emit(LatestEventLoading());
        final events = await _fetchEventsLatestUseCase.getApproximately(
          limit: event.limit,
          curPosition: event.position,
        );
        emit(LatestEventLoaded(events));
      } on Exception catch (e) {
        emit(LatestEventError(e.toString()));
      }
    });
  }
}
