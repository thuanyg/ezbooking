import 'package:bloc/bloc.dart';
import 'package:ezbooking/domain/usecases/events/fetch_events_upcoming.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/upcoming_event_event.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/upcoming_event_state.dart';

class UpcomingEventBloc extends Bloc<UpcomingEventEvent, UpcomingEventState> {
  final FetchEventsUpcomingUseCase _fetchEventsUpcomingUseCase;

  UpcomingEventBloc(this._fetchEventsUpcomingUseCase) : super(UpcomingEventInitial()) {
    on<FetchUpcomingEvent>((event, emit) async {
      try {
        emit(UpcomingEventLoading());
        final events = await _fetchEventsUpcomingUseCase(limit: event.limit);
        emit(UpcomingEventLoaded(events));
      } on Exception catch (e) {
        emit(UpcomingEventError(e.toString()));
      }
    });
  }
}
