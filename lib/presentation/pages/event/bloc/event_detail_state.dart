import 'package:ezbooking/data/models/event.dart';

abstract class EventDetailState {}

class EventDetailInitial extends EventDetailState {}

class EventDetailLoading extends EventDetailState {}

class EventDetailLoaded extends EventDetailState {
  final Event event; // Assuming Event is your event model

  EventDetailLoaded(this.event);
}

class EventDetailError extends EventDetailState {
  final String message;

  EventDetailError(this.message);
}
