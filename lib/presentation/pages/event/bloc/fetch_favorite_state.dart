import 'package:ezbooking/data/models/event.dart';

abstract class FetchFavoriteState {}
class FetchFavoriteInitial extends FetchFavoriteState {}
class FetchFavoriteLoading extends FetchFavoriteState {}
class FetchFavoriteSuccess extends FetchFavoriteState {
  List<Event> events;

  FetchFavoriteSuccess(this.events);
}
class FetchFavoriteError extends FetchFavoriteState {
  String message;

  FetchFavoriteError(this.message);
}
