import 'package:ezbooking/data/models/event.dart';
import 'package:ezbooking/domain/repositories/event_repository.dart';

class FavoriteEventUseCase {
  final EventRepository _repository;

  FavoriteEventUseCase(this._repository);

  Future<List<Event>> get({required String userID}) async {
    return await _repository.fetchFavoriteEvents(userID: userID);
  }

  Future<bool> check({required String eventID, required String userID}) async {
    return await _repository.checkFavoriteEvent(eventID: eventID, userID: userID);
  }

  Future<void> save({required String eventID, required String userID}) async {
    return await _repository.saveFavoriteEvent(eventID: eventID, userID: userID);
  }

  Future<void> unSave({required String eventID, required String userID}) async {
    return await _repository.unSaveFavoriteEvent(eventID: eventID, userID: userID);
  }
}