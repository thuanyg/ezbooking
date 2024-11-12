abstract class FavoriteEvent {}

class ResetFavoriteEvent extends FavoriteEvent {}

class CheckFavoriteEvent extends FavoriteEvent {
  String userID, eventID;

  CheckFavoriteEvent(this.userID, this.eventID);
}

class SaveFavoriteEvent extends FavoriteEvent {
  String userID, eventID;

  SaveFavoriteEvent(this.userID, this.eventID);
}

class UnSaveFavoriteEvent extends FavoriteEvent {
  String userID, eventID;

  UnSaveFavoriteEvent(this.userID, this.eventID);
}
