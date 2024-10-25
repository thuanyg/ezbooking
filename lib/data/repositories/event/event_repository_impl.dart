import 'package:ezbooking/data/datasources/events/event_datasource.dart';
import 'package:ezbooking/data/models/event.dart';
import 'package:ezbooking/domain/repositories/event_repository.dart';

class EventRepositoryImpl extends EventRepository {
  final EventDatasource _datasource;

  EventRepositoryImpl(this._datasource);

  @override
  Future<List<Event>> fetchEvents({required int limit}) async {
    return await _datasource.fetchEvents(limit: limit);
  }

  @override
  Future<List<Event>> fetchUpcomingEvents({required int limit}) async {
    return await _datasource.fetchUpcomingEvents(limit: limit);
  }

  @override
  Future<Event> fetchEvent({required String eventID}) async {
    return await _datasource.fetchEvent(eventID: eventID);
  }

}
