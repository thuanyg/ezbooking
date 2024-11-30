import 'package:cloud_firestore/cloud_firestore.dart' as cf;
import 'package:ezbooking/core/utils/utils.dart';
import 'package:ezbooking/data/models/ticket.dart';
import 'order_datasource.dart';
import 'package:ezbooking/data/models/order.dart';

class OrderDatasourceImpl extends OrderDatasource {
  final cf.FirebaseFirestore firestore = cf.FirebaseFirestore.instance;

  @override
  Future<List<Ticket>> createOrderAndTickets(Order order) async {
    List<Ticket> tickets = [];
    try {
      await firestore.runTransaction((transaction) async {
        // Reference to event document
        final eventRef = firestore.collection('events').doc(order.eventID);

        final eventSnapshot = await transaction.get(eventRef);

        if (!eventSnapshot.exists) {
          throw OrderCreationException("Event does not exist.",
              details: "Event ID: ${order.eventID}");
        }

        // Lấy số lượng vé hiện có
        final currentAvailableTickets =
            eventSnapshot.data()?['availableTickets'] ?? 0;
        final remainingTickets = currentAvailableTickets - order.ticketQuantity;

        if (remainingTickets < 0) {
          throw OrderCreationException("Not enough tickets available!",
              details:
                  "Requested: ${order.ticketQuantity}, Available: $currentAvailableTickets");
        }

        // Cập nhật số vé còn lại
        transaction.update(eventRef, {
          'availableTickets': remainingTickets,
        });

        // Tạo Order trước
        final orderRef = firestore.collection('orders').doc(order.id);
        transaction.set(orderRef, order.toFirestore());

        // Tạo vé tương ứng sau khi Order được tạo
        for (int i = 0; i < order.ticketQuantity; i++) {
          final ticketID = AppUtils.generateRandomString(8);
          final ticketRef = firestore.collection('tickets').doc(ticketID);

          // Generate and encrypt QR Code data
          final qrCodeData = 'ticketId=$ticketID';
          final encryptedData =
              AppUtils.encryptData(qrCodeData, AppUtils.secretKey);

          final ticket = Ticket(
            id: ticketID,
            orderID: order.id,
            eventID: order.eventID,
            userID: order.userID,
            ticketPrice: order.ticketPrice,
            ticketType: "Standard",
            status: "Available",
            qrCodeData: encryptedData,
            createdAt: DateTime.now().toUtc().add(const Duration(hours: 7)),
          );

          tickets.add(ticket);

          transaction.set(ticketRef, ticket.toFirestore());
        }
      });
      return tickets;
    } catch (e) {
      rethrow;
    }
  }
}

class OrderCreationException implements Exception {
  final String message;
  final String? details;

  OrderCreationException(this.message, {this.details});

  @override
  String toString() {
    return 'OrderCreationException: $message${details != null ? ' - $details' : ''}';
  }
}
