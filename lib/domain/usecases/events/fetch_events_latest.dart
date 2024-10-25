import 'package:ezbooking/data/models/event.dart';
import 'package:ezbooking/domain/repositories/event_repository.dart';

class FetchEventsLatestUseCase {
  final EventRepository _repository;

  FetchEventsLatestUseCase(this._repository);

  Future<List<Event>> call({required int limit}) async {
    return _repository.fetchEvents(limit: limit);
  }
}
