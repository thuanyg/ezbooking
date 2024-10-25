import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezbooking/core/services/firebase_firestore_service.dart';
import 'package:ezbooking/data/datasources/events/event_datasource.dart';
import 'package:ezbooking/data/models/event.dart';

class EventDatasourceImpl extends EventDatasource {
  final FirebaseFirestoreService _firestoreService;
  final CollectionReference _eventsCollection =
      FirebaseFirestore.instance.collection("events");

  EventDatasourceImpl(this._firestoreService);

  @override
  Future<List<Event>> fetchEvents({required int limit}) async {
    try {
      Query query =
          _eventsCollection.orderBy("date", descending: true).limit(limit);

      final QuerySnapshot querySnapshot = await query.get();

      final List<Event> events = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Event.fromJson(data);
      }).toList();

      return events;
    } catch (e) {
      throw Exception('Failed to fetch events: $e');
    }
  }

  @override
  Future<List<Event>> fetchUpcomingEvents({required int limit}) async {
    try {
      final now = Timestamp.now();

      Query query = _eventsCollection
          .where("date", isGreaterThan: now)
          .orderBy("date", descending: true)
          .limit(limit);

      final QuerySnapshot querySnapshot = await query.get();

      final List<Event> events = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Event.fromJson(data);
      }).toList();

      return events;
    } catch (e) {
      throw Exception('Failed to fetch upcoming events: $e');
    }
  }

  @override
  Future<Event> fetchEvent({required String eventID}) async {
    final doc = await _firestoreService.getDocument("events", eventID);
    return Event.fromJson(doc.data() as Map<String, dynamic>);
  }
}
