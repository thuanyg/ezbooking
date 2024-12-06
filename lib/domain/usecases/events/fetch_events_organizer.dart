import 'package:ezbooking/data/models/event.dart';
import 'package:ezbooking/domain/repositories/event_repository.dart';

class FetchEventsOrganizerUseCase {
  final EventRepository repository;

  FetchEventsOrganizerUseCase(this.repository);

  Future<List<Event>> call(String organizerID) async {
    return await repository.fetchEventsOfOrganizer(organizerID);
  }
}