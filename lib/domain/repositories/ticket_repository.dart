import 'package:ezbooking/data/models/ticket.dart';

abstract class TicketRepository {
  Future<void> createTicket(Ticket ticket);
  Future<List<Ticket>> fetchTicketOfUser(String userID);

}
