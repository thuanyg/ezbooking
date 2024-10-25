import 'package:ezbooking/data/models/event.dart';

abstract class LatestEventState {}

class LatestEventInitial extends LatestEventState {}

class LatestEventLoading extends LatestEventState {}

class LatestEventLoaded extends LatestEventState {
  final List<Event> events;

  LatestEventLoaded(this.events);
}

class LatestEventError extends LatestEventState {
  final String message;

  LatestEventError(this.message);
}
