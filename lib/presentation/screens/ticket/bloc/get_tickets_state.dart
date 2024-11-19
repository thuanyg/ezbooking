import 'package:ezbooking/data/models/ticket.dart';

abstract class GetTicketsState {
}
class GetTicketsInitial extends GetTicketsState {}
class GetTicketsLoading extends GetTicketsState {}
class GetTicketsSuccess extends GetTicketsState {
  final List<Ticket> tickets;

  GetTicketsSuccess(this.tickets);
}
class GetTicketsError extends GetTicketsState {
  String error;

  GetTicketsError(this.error);
}