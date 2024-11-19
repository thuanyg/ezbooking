import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezbooking/data/models/organizer.dart';

class Event {
  String? id; // Event ID, can be null for new events
  String name;
  String location;
  String eventType;
  String description;
  DateTime date; // Keep this as DateTime
  double ticketPrice;
  int availableTickets;
  String? thumbnail, poster;
  List<String> imageUrls;
  String? videoUrl;
  String? additionalInfo;
  Organizer? organizer;
  GeoPoint? geoPoint;

  Event({
    this.id,
    required this.name,
    required this.location,
    required this.eventType,
    required this.description,
    required this.date,
    required this.ticketPrice,
    this.thumbnail,
    this.poster,
    required this.availableTickets,
    required this.imageUrls,
    this.videoUrl,
    this.additionalInfo,
    this.organizer,
    this.geoPoint,
  });

  // Factory constructor for creating Event from a map (e.g., from Firestore)
  factory Event.fromJson(Map<String, dynamic> map, {String? id}) {
    return Event(
      id: map['id'],
      name: map['name'] ?? '',
      location: map['location'] ?? '',
      eventType: map['eventType'] ?? '',
      thumbnail: map['thumbnail'] ?? '',
      poster: map['poster'] ?? '',
      description: map['description'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      // Convert Firestore Timestamp to DateTime
      ticketPrice: map['ticketPrice']?.toDouble() ?? 0.0,
      availableTickets: map['availableTickets'] ?? 0,
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      videoUrl: map['videoUrl'],
      additionalInfo: map['additionalInfo'],
      organizer: Organizer.fromJson(map['organizer']),
      geoPoint: map['geopoint'] as GeoPoint?,
    );
  }

  // Convert Event to a map (e.g., to save to Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'eventType': eventType,
      'description': description,
      'date': Timestamp.fromDate(date.toUtc().add(const Duration(hours: 7))),
      // Convert DateTime to Firestore Timestamp
      'ticketPrice': ticketPrice,
      'availableTickets': availableTickets,
      'imageUrls': imageUrls,
      'videoUrl': videoUrl,
      'thumbnail': thumbnail,
      'poster': poster,
      'additionalInfo': additionalInfo,
      'organizer': organizer?.toJson(),
      'geopoint': geoPoint,
    };
  }
}
