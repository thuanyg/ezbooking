import 'package:ezbooking/data/models/ticket.dart';
import 'package:ezbooking/domain/repositories/ticket_repository.dart';

class CreateTicketUseCase {
  final TicketRepository repository;

  CreateTicketUseCase(this.repository);

  Future<void> call(Ticket ticket) async {
    return await repository.createTicket(ticket);
  }
}
