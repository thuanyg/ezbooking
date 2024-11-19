abstract class GetTicketsEvent {}
class GetTicketsOfUser extends GetTicketsEvent {
  String userID;

  GetTicketsOfUser(this.userID);
}