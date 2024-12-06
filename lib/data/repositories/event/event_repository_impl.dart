import 'package:ezbooking/data/datasources/events/event_datasource.dart';
import 'package:ezbooking/data/models/comment.dart';
import 'package:ezbooking/data/models/event.dart';
import 'package:ezbooking/data/models/going.dart';
import 'package:ezbooking/domain/repositories/event_repository.dart';
import 'package:geolocator/geolocator.dart';

class EventRepositoryImpl extends EventRepository {
  final EventDatasource _datasource;

  EventRepositoryImpl(this._datasource);

  @override
  Future<List<Event>> fetchEvents({required int limit}) async {
    return await _datasource.fetchEvents(limit: limit);
  }

  @override
  Future<List<Event>> fetchEventsSortedByProximity(
      {required int limit, required Position currentPosition}) async {
    return await _datasource.fetchEventsSortedByProximity(
        limit: limit, currentPosition: currentPosition);
  }

  @override
  Future<List<Event>> fetchUpcomingEvents({required int limit}) async {
    return await _datasource.fetchUpcomingEvents(limit: limit);
  }

  @override
  Future<Event> fetchEvent({required String eventID}) async {
    return await _datasource.fetchEvent(eventID: eventID);
  }

  @override
  Future<void> saveFavoriteEvent(
      {required String eventID, required String userID}) async {
    return await _datasource.saveFavoriteEvent(
        eventID: eventID, userID: userID);
  }

  @override
  Future<void> unSaveFavoriteEvent(
      {required String eventID, required String userID}) async {
    return await _datasource.unSaveFavoriteEvent(
        eventID: eventID, userID: userID);
  }

  @override
  Future<bool> checkFavoriteEvent(
      {required String eventID, required String userID}) async {
    return await _datasource.checkFavoriteEvent(
        eventID: eventID, userID: userID);
  }

  @override
  Future<List<Event>> fetchFavoriteEvents({required String userID}) async {
    return await _datasource.fetchFavoriteEvents(userID: userID);
  }

  @override
  Future<List<Event>> fetchUpcomingEventsSortedByProximity(
      {required int limit, required Position currentPosition}) async {
    return await _datasource.fetchUpcomingEventsSortedByProximity(
        limit: limit, currentPosition: currentPosition);
  }

  @override
  Future<List<Comment>> fetchComments(String eventID) async {
    return await _datasource.fetchComments(eventID);
  }

  @override
  Future<List<Event>> fetchPopularEvents({int? limit}) async {
    return await _datasource.fetchPopularEvents(limit: limit);
  }

  @override
  Future<List<Event>> fetchPopularEventsSortedByProximity(
      {required int limit, required Position currentPosition}) async {
    // TODO: implement fetchPopularEventsSortedByProximity
    throw UnimplementedError();
  }

  @override
  Future<Going> fetchGoingEvent(String eventID) async {
    return await _datasource.fetchGoingEvent(eventID);
  }

  @override
  Stream<int> getTicketAvailable(String eventID) {
    return _datasource.getTicketAvailable(eventID);
  }

  @override
  Future<List<Event>> fetchEventsOfOrganizer(String organizerID) async {
    return await _datasource.fetchEventsOfOrganizer(organizerID);
  }
}
