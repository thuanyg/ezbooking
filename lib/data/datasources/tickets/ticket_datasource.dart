import 'package:ezbooking/data/models/ticket.dart';

abstract class TicketDatasource {
  Future<void> createTicket(Ticket ticket);
  Future<List<Ticket>> fetchTicketOfUser(String userID);
}