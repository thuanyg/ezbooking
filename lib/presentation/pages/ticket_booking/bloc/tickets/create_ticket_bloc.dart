import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezbooking/data/models/event.dart';
import 'package:ezbooking/data/models/ticket.dart';
import 'package:ezbooking/domain/usecases/ticket/create_ticket.dart';

enum TicketCreationStatus { idle, creatingTickets, success, error }

class CreateTicketBloc extends Cubit<TicketCreationStatus> {
  String errorMessage = "";

  CreateTicketBloc() : super(TicketCreationStatus.idle);

  emitState(TicketCreationStatus status) async {
    await Future.delayed(const Duration(milliseconds: 800));
    emit(status);
  }

  Future<void> createTickets(List<Ticket> tickets, Event event) async {
    final firestore = FirebaseFirestore.instance;

    try {
      emit(TicketCreationStatus.creatingTickets);

      await firestore.runTransaction((transaction) async {
        final eventRef = firestore.collection('events').doc(event.id);
        final updatedAvailableTickets = event.availableTickets - tickets.length;

        if (updatedAvailableTickets < 0) {
          throw Exception("Not enough tickets available.");
        }

        transaction.update(eventRef, {
          "availableTickets": updatedAvailableTickets,
        });

        // Tạo các vé trong collection 'tickets'
        for (var ticket in tickets) {
          final ticketRef = firestore.collection('tickets').doc(ticket.id);
          transaction.set(ticketRef, ticket.toFirestore());
        }
      });

      emit(TicketCreationStatus.success);
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Error creating tickets or updating event: $e');
      emit(TicketCreationStatus.error);
    }
  }
}
