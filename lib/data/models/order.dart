import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String id;
  final String userID;
  final String eventID;
  final int ticketQuantity;
  final double ticketPrice;
  final Timestamp createdAt;
  final String status;

  // Constructor
  Order({
    required this.id,
    required this.userID,
    required this.eventID,
    required this.ticketQuantity,
    required this.ticketPrice,
    required this.createdAt,
    required this.status,
  });

  // Create from JSON/Firestore
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      userID: json['userID'] as String,
      eventID: json['eventID'] as String,
      ticketQuantity: json['ticketQuantity'] as int,
      ticketPrice: (json['ticketPrice'] as num).toDouble(),
      createdAt: json['createdAt'] as Timestamp,
      status: json['status'] as String,
    );
  }

  // Convert to JSON/Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userID': userID,
      'eventID': eventID,
      'ticketQuantity': ticketQuantity,
      'ticketPrice': ticketPrice,
      'createdAt': createdAt,
      'status': status,
    };
  }

  // Calculate total price
  double get totalPrice => ticketQuantity * ticketPrice;

  // Get DateTime from Timestamp
  DateTime get createdAtDateTime => createdAt.toDate();

  // Copy with method for immutability
  Order copyWith({
    String? id,
    String? userID,
    String? eventID,
    int? ticketQuantity,
    double? ticketPrice,
    Timestamp? createdAt,
    String? status,
  }) {
    return Order(
      id: id ?? this.id,
      userID: userID ?? this.userID,
      eventID: eventID ?? this.eventID,
      ticketQuantity: ticketQuantity ?? this.ticketQuantity,
      ticketPrice: ticketPrice ?? this.ticketPrice,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'TicketBooking(id: $id, userID: $userID, eventID: $eventID, '
        'ticketQuantity: $ticketQuantity, ticketPrice: $ticketPrice, '
        'createdAt: ${createdAt.toDate()}, status: $status)';
  }
}