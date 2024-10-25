import 'package:ezbooking/data/models/event.dart';

abstract class UpcomingEventState {}

class UpcomingEventInitial extends UpcomingEventState {}

class UpcomingEventLoading extends UpcomingEventState {}


class UpcomingEventLoaded extends UpcomingEventState {
  List<Event> events;

  UpcomingEventLoaded(this.events);
}

class UpcomingEventError extends UpcomingEventState {
  String message;

  UpcomingEventError(this.message);
}
