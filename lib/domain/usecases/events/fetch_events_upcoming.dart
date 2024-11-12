import 'package:ezbooking/data/models/event.dart';
import 'package:ezbooking/domain/repositories/event_repository.dart';
import 'package:geolocator/geolocator.dart';

class FetchEventsUpcomingUseCase {
  final EventRepository _repository;

  FetchEventsUpcomingUseCase(this._repository);

  Future<List<Event>> call({required int limit}) async {
    return _repository.fetchUpcomingEvents(limit: limit);
  }

  Future<List<Event>> getApproximately(
      {required int limit, required Position curPosition}) async {
    return await _repository.fetchUpcomingEventsSortedByProximity(
        limit: limit, currentPosition: curPosition);
  }
}
