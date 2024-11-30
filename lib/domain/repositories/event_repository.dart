import 'package:ezbooking/data/models/comment.dart';
import 'package:ezbooking/data/models/event.dart';
import 'package:geolocator/geolocator.dart';

abstract class EventRepository {
  Future<Event> fetchEvent({required String eventID});

  Future<List<Event>> fetchEvents({required int limit});

  Future<List<Event>> fetchEventsSortedByProximity({
    required int limit,
    required Position currentPosition,
  });

  Future<List<Event>> fetchPopularEvents({int? limit});

  Future<List<Event>> fetchPopularEventsSortedByProximity({
    required int limit,
    required Position currentPosition,
  });

  Future<List<Event>> fetchUpcomingEvents({required int limit});

  Future<List<Event>> fetchUpcomingEventsSortedByProximity({
    required int limit,
    required Position currentPosition,
  });

  Future<List<Event>> fetchFavoriteEvents({required String userID});

  Future<bool> checkFavoriteEvent(
      {required String eventID, required String userID});

  Future<void> saveFavoriteEvent(
      {required String eventID, required String userID});

  Future<void> unSaveFavoriteEvent(
      {required String eventID, required String userID});

  Future<List<Comment>> fetchComments(String eventID);

}
