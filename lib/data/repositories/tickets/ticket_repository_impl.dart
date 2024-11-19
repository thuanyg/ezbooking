import 'package:ezbooking/data/datasources/tickets/ticket_datasource.dart';
import 'package:ezbooking/data/models/ticket.dart';
import 'package:ezbooking/domain/repositories/ticket_repository.dart';

class TicketRepositoryImpl extends TicketRepository {
  final TicketDatasource datasource;

  TicketRepositoryImpl(this.datasource);

  @override
  Future<void> createTicket(Ticket ticket) async {
    return await datasource.createTicket(ticket);
  }

  @override
  Future<List<Ticket>> fetchTicketOfUser(String userID)  async{
    return await datasource.fetchTicketOfUser(userID);
  }
}
