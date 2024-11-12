abstract class FavoriteState {}

class FavoriteEventInitial extends FavoriteState {}

class FavoriteEventLoading extends FavoriteState {}

class FavoriteEventSaved extends FavoriteState {}

class FavoriteEventUnSaved extends FavoriteState {}

class FavoriteEventError extends FavoriteState {
  String message;

  FavoriteEventError(this.message);
}
