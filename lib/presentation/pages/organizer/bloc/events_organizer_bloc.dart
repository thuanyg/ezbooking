import 'package:bloc/bloc.dart';
import 'package:ezbooking/domain/usecases/events/fetch_events_organizer.dart';
import 'package:ezbooking/presentation/pages/organizer/bloc/events_organizer_event.dart';
import 'package:ezbooking/presentation/pages/organizer/bloc/events_organizer_state.dart';

class EventsOrganizerBloc
    extends Bloc<EventsOrganizerEvent, EventsOrganizerState> {
  final FetchEventsOrganizerUseCase fetchEventsOrganizerUseCase;

  EventsOrganizerBloc(this.fetchEventsOrganizerUseCase)
      : super(EventsOrganizerInitial()) {
    on<FetchEventsOrganizer>(_onFetchEventsOrganizer);
  }

  Future<void> _onFetchEventsOrganizer(
      FetchEventsOrganizer event, Emitter<EventsOrganizerState> emit) async {
    emit(EventsOrganizerLoading());

    try {
      final events = await fetchEventsOrganizerUseCase(event.organizerID);
      emit(EventsOrganizerLoaded(events));
    } catch (e) {
      emit(EventsOrganizerError(e.toString()));
    }
  }
}
