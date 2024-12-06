import 'package:ezbooking/data/models/going.dart';
import 'package:ezbooking/domain/repositories/event_repository.dart';

class FetchGoingEventUseCase {
  final EventRepository _repository;

  FetchGoingEventUseCase(this._repository);

  Future<Going> call(String eventID) async {
    return await _repository.fetchGoingEvent(eventID);
  }
}