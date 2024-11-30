import 'package:ezbooking/data/models/event.dart';
import 'package:ezbooking/data/models/ticket.dart';


class TicketEntity {
  final Ticket ticket;
  final Event event;

  TicketEntity(this.ticket, this.event);
}