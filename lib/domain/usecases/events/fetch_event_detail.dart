import 'package:ezbooking/data/models/event.dart';
import 'package:ezbooking/domain/repositories/event_repository.dart';

class FetchEventDetailUseCase {
  final EventRepository _repository;

  FetchEventDetailUseCase(this._repository);

  Future<Event> call({required String eventID}) async {
    return await _repository.fetchEvent(eventID: eventID);
  }
}
