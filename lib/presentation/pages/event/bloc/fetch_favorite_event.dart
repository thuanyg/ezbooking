abstract class FetchFavoriteEvent {}
class FetchFavorite extends FetchFavoriteEvent {
  final String userID;

  FetchFavorite(this.userID);
}
class SearchFavorite extends FetchFavoriteEvent {
  final String query;

  SearchFavorite(this.query);
}