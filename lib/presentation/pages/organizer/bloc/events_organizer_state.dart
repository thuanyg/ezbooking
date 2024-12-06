import 'package:ezbooking/data/models/event.dart';

abstract class EventsOrganizerState {}

class EventsOrganizerInitial extends EventsOrganizerState {}

class EventsOrganizerLoading extends EventsOrganizerState {}

class EventsOrganizerLoaded extends EventsOrganizerState {
  final List<Event> events;

  EventsOrganizerLoaded(this.events);
}

class EventsOrganizerError extends EventsOrganizerState {
  final String message;

  EventsOrganizerError(this.message);
}
