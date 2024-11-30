import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezbooking/data/datasources/tickets/ticket_datasource.dart';
import 'package:ezbooking/data/models/event.dart';
import 'package:ezbooking/data/models/ticket.dart';
import 'package:ezbooking/domain/entities/ticket_entity.dart';

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

  @override
  Stream<List<TicketEntity>> fetchTicketEntitiesOfUser(String userID) {
    return firebaseFirestore
        .collection('tickets')
        .where('userID', isEqualTo: userID)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      // Chuyển từng `doc` thành `TicketEntity`
      final ticketEntities = await Future.wait(
        snapshot.docs.map((doc) async {
          final ticket = Ticket.fromFirestore(doc.data(), doc.id);

          // Lấy thông tin sự kiện
          final eventDoc = await firebaseFirestore
              .collection('events')
              .doc(ticket.eventID)
              .get();

          if (eventDoc.exists) {
            final event = Event.fromJson(eventDoc.data() as Map<String, dynamic>);
            return TicketEntity(ticket, event);
          } else {
            return null; // Bỏ qua nếu không tìm thấy sự kiện
          }
        }),
      );

      // Lọc bỏ các giá trị null (nếu sự kiện không tồn tại)
      return ticketEntities.whereType<TicketEntity>().toList();
    });
  }



}
