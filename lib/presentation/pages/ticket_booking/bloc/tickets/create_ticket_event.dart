import 'package:ezbooking/data/models/order.dart';
import 'package:ezbooking/data/models/ticket.dart';

abstract class CreateTicketEvent {}
class CreateTicket extends CreateTicketEvent {
  final Ticket ticket;

  CreateTicket(this.ticket);
}
