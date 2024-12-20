import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezbooking/core/services/firebase_firestore_service.dart';
import 'package:ezbooking/core/utils/utils.dart';
import 'package:ezbooking/data/datasources/events/event_datasource.dart';
import 'package:ezbooking/data/models/comment.dart';
import 'package:ezbooking/data/models/event.dart';
import 'package:ezbooking/data/models/going.dart';
import 'package:ezbooking/data/models/organizer.dart';
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
    try {
      Query query =
          _eventsCollection.where("isDelete", isEqualTo: false).limit(limit);

      final QuerySnapshot querySnapshot = await query.get();

      // Fetch organizer data for each event
      final List<Event> events = await Future.wait(
        querySnapshot.docs.map((doc) async {
          final data = doc.data() as Map<String, dynamic>;
          final organizerId = data["organizer"] as String;

          // Fetch organizer details
          final organizerDoc = await FirebaseFirestore.instance
              .collection("organizers")
              .doc(organizerId)
              .get();

          final organizerData = organizerDoc.data()!;
          final organizer = Organizer.fromJson(organizerData);

          // Return Event with Organizer details
          return Event.fromJson(data, organizer: organizer);
        }),
      );

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

      // Fetch organizer data for each event
      final List<Event> events = await Future.wait(
        querySnapshot.docs.map((doc) async {
          final data = doc.data() as Map<String, dynamic>;
          final organizerId = data["organizer"] as String;

          // Fetch organizer details
          final organizerDoc = await FirebaseFirestore.instance
              .collection("organizers")
              .doc(organizerId)
              .get();

          final organizerData = organizerDoc.data()!;
          final organizer = Organizer.fromJson(organizerData);

          // Return Event with Organizer details
          return Event.fromJson(data, organizer: organizer);
        }),
      );
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
          .where("isDelete", isEqualTo: false)
          .where("date", isGreaterThan: now)
          .orderBy("date", descending: true)
          .limit(limit);

      final QuerySnapshot querySnapshot = await query.get();

      // Fetch organizer data for each event
      final List<Event> events = await Future.wait(
        querySnapshot.docs.map((doc) async {
          final data = doc.data() as Map<String, dynamic>;
          final organizerId = data["organizer"] as String;

          // Fetch organizer details
          final organizerDoc = await FirebaseFirestore.instance
              .collection("organizers")
              .doc(organizerId)
              .get();

          final organizerData = organizerDoc.data() as Map<String, dynamic>;
          final organizer = Organizer.fromJson(organizerData);

          // Return Event with Organizer details
          return Event.fromJson(data, organizer: organizer);
        }),
      );

      return events;
    } catch (e) {
      throw Exception('Failed to fetch upcoming events: $e');
    }
  }

  @override
  Future<Event> fetchEvent({required String eventID}) async {
    final doc = await _firestoreService.getDocument("events", eventID);
    final data = doc.data() as Map<String, dynamic>;
    // Get Organizer
    final organizerId = data["organizer"] as String?;
    final organizerDoc = await FirebaseFirestore.instance
        .collection("organizers")
        .doc(organizerId)
        .get();

    final organizerData = organizerDoc.data() as Map<String, dynamic>;

    return Event.fromJson(data, organizer: Organizer.fromJson(organizerData));
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
    try {
      final now = Timestamp.now();

      Query query = _eventsCollection
          .where("isDelete", isEqualTo: false)
          .where("date", isGreaterThan: now)
          .orderBy("date", descending: true)
          .limit(limit);

      final QuerySnapshot querySnapshot = await query.get();

      // Fetch organizer data for each event
      final List<Event> events = await Future.wait(
        querySnapshot.docs.map((doc) async {
          final data = doc.data() as Map<String, dynamic>;
          final organizerId = data["organizer"] as String;

          // Fetch organizer details
          final organizerDoc = await FirebaseFirestore.instance
              .collection("organizers")
              .doc(organizerId)
              .get();

          final organizerData = organizerDoc.data()!;
          final organizer = Organizer.fromJson(organizerData);

          // Return Event with Organizer details
          return Event.fromJson(data, organizer: organizer);
        }),
      );

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

      comments.sort(
        (a, b) => b.createdAt.compareTo(a.createdAt),
      );

      return comments;
    } on Exception catch (e) {
      throw Exception('Failed to fetch comment events: $e');
    }
  }

  @override
  Future<List<Event>> fetchPopularEvents({int? limit}) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Bước 1: Lấy tổng số lượng ticket cho mỗi sự kiện từ collection "orders"
    final ordersSnapshot = await firestore.collection('orders').get();

    final Map<String, int> eventOrderCounts = {};

    for (var doc in ordersSnapshot.docs) {
      final data = doc.data();
      final eventID = data['eventID'] as String;
      final ticketQuantity = data['ticketQuantity'] as int;

      // Cộng dồn số lượng ticket cho từng sự kiện
      eventOrderCounts[eventID] =
          (eventOrderCounts[eventID] ?? 0) + ticketQuantity;
    }

    // Bước 2: Sắp xếp danh sách sự kiện theo tổng số lượng order
    final sortedEventIDs = eventOrderCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)); // Sắp xếp giảm dần

    // Lấy danh sách giới hạn theo "limit"
    List<String> topEventIDs = [];
    if (limit != null) {
      topEventIDs = sortedEventIDs.take(limit).map((e) => e.key).toList();
    } else {
      topEventIDs = sortedEventIDs.map((e) => e.key).toList();
    }
    // Bước 3: Lấy chi tiết sự kiện từ collection "events"
    List<Event> popularEvents = [];

    for (String eventID in topEventIDs) {
      final eventDoc = await firestore.collection('events').doc(eventID).get();
      if (eventDoc.exists) {
        final eventData = eventDoc.data()!;
        if(eventData["isDelete"] == false) {
          popularEvents.add(Event.fromJson(eventData));
        }
      }
    }

    return popularEvents;
  }

  @override
  Future<List<Event>> fetchPopularEventsSortedByProximity(
      {required int limit, required Position currentPosition}) async {
    // TODO: implement fetchPopularEventsSortedByProximity
    throw UnimplementedError();
  }

  @override
  Future<Going> fetchGoingEvent(String eventID) async {
    try {
      // Get count of users who placed an order for this event
      final countSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('eventID', isEqualTo: eventID)
          .count()
          .get();

      final count = countSnapshot.count ?? 0; // Get the number of participants

      // Fetch only the 3 most recent orders for the given eventID
      final orderQuerySnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('eventID', isEqualTo: eventID)
          .orderBy('createdAt', descending: true) // Order by creation time
          .limit(3) // Limit to the 3 most recent
          .get();

      // Initialize a list to store avatar URLs
      List<String> avatarUrls = [];

      // Loop through the orders to get user avatars
      for (var doc in orderQuerySnapshot.docs) {
        final orderData = doc.data();
        final userID =
            orderData['userID']; // Assuming userID is stored in the order

        // Fetch user data to get the avatar URL
        final userDocSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userID)
            .get();

        if (userDocSnapshot.exists) {
          final userData = userDocSnapshot.data();
          final avatarUrl = userData?['avatarUrl'];
          if (avatarUrl != null && !avatarUrls.contains(avatarUrl)) {
            avatarUrls.add(avatarUrl);
          }
        }
      }

      // Return the Going object with the number of participants and the avatar URLs
      return Going(count, avatarUrls);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<int> getTicketAvailable(String eventID) {
    return FirebaseFirestore.instance
        .collection("events")
        .doc(eventID)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data();
        if (data != null && data['availableTickets'] is int) {
          return data['availableTickets'] as int;
        }
      }
      return 0; // Default to 0 if data is missing or invalid
    });
  }

  @override
  Future<List<Event>> fetchEventsOfOrganizer(String organizerID) async {
    try {
      final docs = await FirebaseFirestore.instance
          .collection('events')
          .where('organizer', isEqualTo: organizerID)
          .where("isDelete", isEqualTo: false)
          .get();

      final events =
          docs.docs.map((doc) => Event.fromJson(doc.data())).toList();
      return events;
    } catch (e) {
      print("Error fetching events: $e");
      throw Exception("Failed to fetch events for organizer $organizerID");
    }
  }

  @override
  Future<List<Event>> fetchEventsByCategory(category) async {
    // TODO: implement fetchEventsByCategory
    throw UnimplementedError();
  }
}
