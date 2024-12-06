import 'package:bloc/bloc.dart';
import 'package:ezbooking/domain/usecases/events/fetch_available_ticket.dart';

class FetchAvailableTicketCubit extends Cubit<int> {
  final FetchAvailableTicketUseCase useCase;

  FetchAvailableTicketCubit(this.useCase) : super(0); // Initial state is 0

  void fetchAvailableTickets(String eventID) {
    // Call the use case and listen for updates
    useCase.call(eventID).listen(
          (availableTickets) {
        emit(availableTickets);
      },
      onError: (error) {
        print("Error fetching tickets: $error");
      },
    );
  }
}