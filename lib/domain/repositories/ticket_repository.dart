import 'package:ezbooking/data/models/ticket.dart';
import 'package:ezbooking/domain/entities/ticket_entity.dart';

abstract class TicketRepository {
  Future<void> createTicket(Ticket ticket);
  Stream<Ticket> fetchTicket(String ticketID);
  Stream<List<TicketEntity>> fetchTicketEntitiesOfUser(String userID);
}
