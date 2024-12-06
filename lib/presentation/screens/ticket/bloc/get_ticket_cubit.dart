import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ezbooking/data/models/ticket.dart';
import 'package:ezbooking/domain/usecases/ticket/get_tickets.dart';

class GetTicketCubit extends Cubit<Ticket?> {
  final GetTicketsUseCase useCase;
  StreamSubscription<Ticket>? _ticketSubscription;
  bool isLoading = false;

  GetTicketCubit(this.useCase) : super(null);

  // Method to fetch the ticket by ID
  void fetchTicket(String ticketID) {
    try {
      isLoading = true;
      emit(null);

      // Subscribe to the ticket stream and emit updates as they arrive
      _ticketSubscription = useCase.getTicketByID(ticketID).listen(
        (ticket) {
          emit(ticket); // Emit the ticket when received
          isLoading = false; // Set loading to false once ticket is fetched
        },
        onError: (error) {
          emit(error);
        },
      );
    } catch (e) {
      emit(null);
    }
  }

  // Optionally, cancel the subscription when it's no longer needed
  @override
  Future<void> close() {
    _ticketSubscription
        ?.cancel(); // Make sure to cancel the subscription to avoid memory leaks
    return super.close();
  }
}
