abstract class GetTicketsEvent {}
class GetTicketsOfUser extends GetTicketsEvent {
  String userID;

  GetTicketsOfUser(this.userID);
}

class GetTicketEntitiesOfUser extends GetTicketsEvent {
  String userID;

  GetTicketEntitiesOfUser(this.userID);
}