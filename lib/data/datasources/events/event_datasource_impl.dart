import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezbooking/core/services/firebase_firestore_service.dart';
import 'package:ezbooking/core/utils/utils.dart';
import 'package:ezbooking/data/datasources/events/event_datasource.dart';
import 'package:ezbooking/data/models/comment.dart';
import 'package:ezbooking/data/models/event.dart';
import 'package:geolocator/geolocator.dart';

class EventDatasourceImpl extends EventDatasource {
  final FirebaseFirestoreService _firestoreService;
  final CollectionReference _eventsCollection =
      FirebaseFirestore.instance.collection("events");

  EventDatasourceImpl(this._firestoreService);

  @override
  Future<List<Event>> fetchEventsSortedByProximity({
    required int limit,
    required Position currentPosition,
  }) async {
    // Kiểm tra và đổi vị trí nếu latitude > 90
    double latitude = currentPosition.latitude;
    double longitude = currentPosition.longitude;
    if (latitude > 90) {
      final temp = latitude;
      latitude = longitude;
      longitude = temp;
    }

    const double earthRadiusKm = 6371.0;
    const double radiusInKm = 100; // Bán kính 100km

// Tính toán bounding box với hệ số điều chỉnh
    double latKmRatio = 1 / 111.0; // 1 độ latitude ≈ 111km
    double lngKmRatio =
        1 / (111.0 * cos(latitude * pi / 180.0)); // Điều chỉnh theo latitude

// Tính delta cho latitude và longitude
    double latDelta = radiusInKm * latKmRatio * 1.2; // Thêm 20% margin
    double lngDelta = radiusInKm * lngKmRatio * 1.2;

// Tính bounds
    double minLat = latitude - latDelta;
    double maxLat = latitude + latDelta;
    double minLng = longitude - lngDelta;
    double maxLng = longitude + lngDelta;

    try {
      // Query Firestore với bounding box đã tính toán
      Query query = _eventsCollection
          .where("geoPoint", isGreaterThanOrEqualTo: GeoPoint(minLat, minLng))
          .where("geoPoint", isLessThanOrEqualTo: GeoPoint(maxLat, maxLng))
          .limit(limit);

      final QuerySnapshot querySnapshot = await query.get();

      final List<Event> events = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Event.fromJson(data);
      }).toList();

      // Sắp xếp danh sách sự kiện theo khoảng cách từ vị trí hiện tại
      events.sort((a, b) {
        double distanceA = Geolocator.distanceBetween(
          currentPosition.latitude,
          currentPosition.longitude,
          a.geoPoint!.latitude,
          a.geoPoint!.longitude,
        );
        double distanceB = Geolocator.distanceBetween(
          currentPosition.latitude,
          currentPosition.longitude,
          b.geoPoint!.latitude,
          b.geoPoint!.longitude,
        );
        return distanceA.compareTo(distanceB);
      });

      return events;
    } catch (e) {
      throw Exception('Failed to fetch events: $e');
    }
  }

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

  @override
  Future<void> saveFavoriteEvent(
      {required String eventID, required String userID}) async {
    Map<String, dynamic> data = {
      "userID": userID,
      "eventID": eventID,
      "createdAt": Timestamp.now(),
    };
    return await _firestoreService.addDocument("favorites", data);
  }

  @override
  Future<void> unSaveFavoriteEvent(
      {required String eventID, required String userID}) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("favorites")
        .where("eventID", isEqualTo: eventID)
        .where("userID", isEqualTo: userID)
        .get();
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Future<bool> checkFavoriteEvent(
      {required String eventID, required String userID}) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("favorites")
        .where("eventID", isEqualTo: eventID)
        .where("userID", isEqualTo: userID)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  @override
  Future<List<Event>> fetchFavoriteEvents({required String userID}) async {
    List<QueryDocumentSnapshot> docs = await _firestoreService
        .getDocumentsWhere("favorites", "userID", userID);

    List<Event> favoriteEvents = [];

    for (var doc in docs) {
      String eventID = doc['eventID'];
      final eventDoc = await _firestoreService.getDocument("events", eventID);

      if (eventDoc.exists) {
        Event event = Event.fromJson(eventDoc.data() as Map<String, dynamic>);
        favoriteEvents.add(event);
      }
    }
    return favoriteEvents;
  }

  @override
  Future<List<Event>> fetchUpcomingEventsSortedByProximity(
      {required int limit, required Position currentPosition}) async {
    // Kiểm tra và đổi vị trí nếu latitude > 90
    double latitude = currentPosition.latitude;
    double longitude = currentPosition.longitude;
    if (latitude > 90) {
      final temp = latitude;
      latitude = longitude;
      longitude = temp;
    }

    const double earthRadiusKm = 6371.0;
    const double radiusInKm = 100; // Bán kính 100km

// Tính toán bounding box với hệ số điều chỉnh
    double latKmRatio = 1 / 111.0; // 1 độ latitude ≈ 111km
    double lngKmRatio =
        1 / (111.0 * cos(latitude * pi / 180.0)); // Điều chỉnh theo latitude

// Tính delta cho latitude và longitude
    double latDelta = radiusInKm * latKmRatio * 1.2; // Thêm 20% margin
    double lngDelta = radiusInKm * lngKmRatio * 1.2;

// Tính bounds
    double minLat = latitude - latDelta;
    double maxLat = latitude + latDelta;
    double minLng = longitude - lngDelta;
    double maxLng = longitude + lngDelta;

    try {
      final now = Timestamp.now();

      Query query = _eventsCollection
          .where("date", isGreaterThan: now)
          .where("geoPoint", isGreaterThanOrEqualTo: GeoPoint(minLat, minLng))
          .where("geoPoint", isLessThanOrEqualTo: GeoPoint(maxLat, maxLng))
          .orderBy("date", descending: true)
          .limit(limit);

      final QuerySnapshot querySnapshot = await query.get();

      final List<Event> events = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Event.fromJson(data);
      }).toList();

      events.sort((a, b) {
        double distanceA = Geolocator.distanceBetween(
          currentPosition.latitude,
          currentPosition.longitude,
          a.geoPoint!.latitude,
          a.geoPoint!.longitude,
        );
        double distanceB = Geolocator.distanceBetween(
          currentPosition.latitude,
          currentPosition.longitude,
          b.geoPoint!.latitude,
          b.geoPoint!.longitude,
        );
        return distanceA.compareTo(distanceB);
      });

      return events;
    } catch (e) {
      throw Exception('Failed to fetch upcoming events: $e');
    }
  }

  @override
  Future<List<Comment>> fetchComments(String eventID) async {
    try {
      final docs = await _firestoreService.getDocumentsWhere(
          "comments", "eventID", eventID);

      // Use Future.wait to handle asynchronous operations within a loop
      final List<Comment> comments = await Future.wait(docs.map((doc) async {
        final data = doc.data() as Map<String, dynamic>;
        final userID = data["userID"];
        final userDoc = await _firestoreService.getDocument("users", userID);
        final userData = userDoc.data() as Map<String, dynamic>;
        return Comment.fromJson(data, userData);
      }).toList());

      comments.sort((a, b) => b.createdAt.compareTo(a.createdAt),);

      return comments;
    } on Exception catch (e) {
      throw Exception('Failed to fetch comment events: $e');
    }
  }
}
