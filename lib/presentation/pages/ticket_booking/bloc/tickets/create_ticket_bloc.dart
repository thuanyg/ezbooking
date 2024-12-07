import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezbooking/data/models/ticket.dart';
import 'package:ezbooking/domain/usecases/ticket/create_ticket.dart';

enum TicketCreationStatus { idle, creatingTickets, success, error }

class CreateTicketBloc extends Cubit<TicketCreationStatus> {
  String errorMessage = "";

  CreateTicketBloc() : super(TicketCreationStatus.idle);

  emitState(TicketCreationStatus status) async {
    await Future.delayed(const Duration(milliseconds: 800));
    emit(status);
  }

  Future<void> createTickets(List<Ticket> tickets) async {
    try {
      // Cập nhật trạng thái: Đang tạo vé
      emit(TicketCreationStatus.creatingTickets);
      final firestore = FirebaseFirestore.instance;

      try {
        // Sử dụng runTransaction để tạo tất cả vé trong danh sách
        await firestore.runTransaction((transaction) async {
          for (var ticket in tickets) {
            final ticketRef = firestore.collection('tickets').doc(ticket.id);

            // Thực hiện tạo vé trong Firestore
            transaction.set(ticketRef, ticket.toFirestore());
          }
        });
      } on Exception catch (e) {
        throw Exception(e);
      }

      // Chờ một thời gian để đảm bảo các vé đã được tạo
      await Future.delayed(const Duration(milliseconds: 800));

      // Cập nhật trạng thái: Thành công
      emit(TicketCreationStatus.success);
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Unknown error: $e');
      emit(TicketCreationStatus.error);
    }
  }

}
