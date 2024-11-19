import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezbooking/data/datasources/tickets/ticket_datasource.dart';
import 'package:ezbooking/data/models/ticket.dart';

class TicketDatasourceImpl extends TicketDatasource {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<void> createTicket(Ticket ticket) async {
    try {
      await firebaseFirestore
          .collection('tickets')
          .doc(ticket.id)
          .set(ticket.toFirestore());
    } catch (e) {
      throw Exception('Failed to create ticket: $e');
    }
  }

  @override
  Future<List<Ticket>> fetchTicketOfUser(String userID) async {
    try {
      // Truy vấn Firestore để lấy các vé của người dùng có userID
      final querySnapshot = await firebaseFirestore
          .collection('tickets')
          .where('userID', isEqualTo: userID)
          .orderBy('createdAt', descending: true)
          .get();

      // Chuyển đổi dữ liệu Firestore thành danh sách các vé
      final tickets = querySnapshot.docs.map((doc) {
        return Ticket.fromFirestore(doc.data(), doc.id);
      }).toList();

      return tickets;
    } catch (e) {
      throw Exception('Failed to fetch tickets for user: $e');
    }
  }
}
