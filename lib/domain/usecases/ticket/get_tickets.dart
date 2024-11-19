import 'package:ezbooking/data/models/ticket.dart';
import 'package:ezbooking/domain/repositories/ticket_repository.dart';

class GetTicketsUseCase {
  final TicketRepository repository;

  GetTicketsUseCase(this.repository);

  Future<List<Ticket>> call(String userID) async {
    return await repository.fetchTicketOfUser(userID);
  }
}
