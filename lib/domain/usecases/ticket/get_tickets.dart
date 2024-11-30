import 'package:ezbooking/data/models/ticket.dart';
import 'package:ezbooking/domain/entities/ticket_entity.dart';
import 'package:ezbooking/domain/repositories/ticket_repository.dart';

class GetTicketsUseCase {
  final TicketRepository repository;

  GetTicketsUseCase(this.repository);

  Future<List<Ticket>> getTicketsOfUser(String userID) async {
    return await repository.fetchTicketOfUser(userID);
  }

  Stream<List<TicketEntity>> getTicketEntitiesOfUser(String userID) {
    return repository.fetchTicketEntitiesOfUser(userID);
  }
}
