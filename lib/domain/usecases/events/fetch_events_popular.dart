import 'package:ezbooking/data/models/event.dart';
import 'package:ezbooking/domain/repositories/event_repository.dart';
import 'package:geolocator/geolocator.dart';

class FetchEventsPopularUseCase {
  final EventRepository _repository;

  FetchEventsPopularUseCase(this._repository);

  Future<List<Event>> call({int? limit}) async {
    return await _repository.fetchPopularEvents(limit: null);
  }

  Future<List<Event>> getApproximately(
      {required int limit, required Position curPosition}) async {
    return await _repository.fetchEventsSortedByProximity(
        limit: limit, currentPosition: curPosition);
  }
}
