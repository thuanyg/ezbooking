import 'package:ezbooking/data/models/event.dart';

abstract class PopularEventState {}

class PopularEventInitial extends PopularEventState {}

class PopularEventLoading extends PopularEventState {}

class PopularEventLoaded extends PopularEventState {
  final List<Event> events;

  PopularEventLoaded(this.events);
}

class PopularEventError extends PopularEventState {
  final String message;

  PopularEventError(this.message);
}
