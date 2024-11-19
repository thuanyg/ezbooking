abstract class FetchFavoriteEvent {}
class FetchFavorite extends FetchFavoriteEvent {
  final String userID;

  FetchFavorite(this.userID);
}