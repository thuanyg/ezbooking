import 'package:ezbooking/data/models/event.dart';
import 'package:ezbooking/domain/repositories/event_repository.dart';
import 'package:geolocator/geolocator.dart';

class FetchEventsLatestUseCase {
  final EventRepository _repository;

  FetchEventsLatestUseCase(this._repository);

  Future<List<Event>> call({required int limit}) async {
    return await _repository.fetchEvents(limit: limit);
  }

  Future<List<Event>> getApproximately(
      {required int limit, required Position curPosition}) async {
    return await _repository.fetchEventsSortedByProximity(
        limit: limit, currentPosition: curPosition);
  }
}
