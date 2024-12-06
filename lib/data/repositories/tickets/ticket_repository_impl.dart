import 'package:ezbooking/data/datasources/tickets/ticket_datasource.dart';
import 'package:ezbooking/data/models/ticket.dart';
import 'package:ezbooking/domain/entities/ticket_entity.dart';
import 'package:ezbooking/domain/repositories/ticket_repository.dart';

class TicketRepositoryImpl extends TicketRepository {
  final TicketDatasource datasource;

  TicketRepositoryImpl(this.datasource);

  @override
  Future<void> createTicket(Ticket ticket) async {
    return await datasource.createTicket(ticket);
  }

  @override
  Stream<List<TicketEntity>> fetchTicketEntitiesOfUser(String userID) =>
      datasource.fetchTicketEntitiesOfUser(userID);

  @override
  Stream<Ticket> fetchTicket(String ticketID) {
    return datasource.fetchTicket(ticketID);
  }
}
