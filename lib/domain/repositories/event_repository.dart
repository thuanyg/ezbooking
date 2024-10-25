import 'package:ezbooking/data/models/event.dart';

abstract class EventRepository {
  Future<Event> fetchEvent({required String eventID});

  Future<List<Event>> fetchEvents({required int limit});

  Future<List<Event>> fetchUpcomingEvents({required int limit});
}
