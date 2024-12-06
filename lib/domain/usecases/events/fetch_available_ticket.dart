import 'package:ezbooking/domain/repositories/event_repository.dart';

class FetchAvailableTicketUseCase {
  final EventRepository repository;

  FetchAvailableTicketUseCase(this.repository);

  Stream<int> call(String eventID){
    return repository.getTicketAvailable(eventID);
  }
}