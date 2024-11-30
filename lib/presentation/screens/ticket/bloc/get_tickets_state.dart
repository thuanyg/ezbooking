import 'package:ezbooking/data/models/ticket.dart';
import 'package:ezbooking/domain/entities/ticket_entity.dart';

abstract class GetTicketsState {
}
class GetTicketsInitial extends GetTicketsState {}
class GetTicketsLoading extends GetTicketsState {}
class GetTicketsSuccess extends GetTicketsState {
  final List<Ticket> tickets;

  GetTicketsSuccess(this.tickets);
}
class GetTicketEntitiesSuccess extends GetTicketsState {
  final List<TicketEntity> ticketEntities;

  GetTicketEntitiesSuccess(this.ticketEntities);
}
class GetTicketsError extends GetTicketsState {
  String error;

  GetTicketsError(this.error);
}