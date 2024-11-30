import 'package:bloc/bloc.dart';
import 'package:ezbooking/data/datasources/orders/order_datasource_impl.dart';
import 'package:ezbooking/data/models/order.dart';
import 'package:ezbooking/data/models/ticket.dart';
import 'package:ezbooking/domain/usecases/orders/create_order_ticket.dart';
import 'package:ezbooking/presentation/pages/ticket_booking/bloc/orders/create_order_event.dart';
import 'package:ezbooking/presentation/pages/ticket_booking/bloc/orders/create_order_state.dart';

enum OrderCreationStatus {
  idle,
  creatingOrder,
  creatingTickets,
  success,
  error
}

class CreateOrderBloc extends Cubit<OrderCreationStatus> {
  final CreateOrderAndTicketUseCase useCase;
  String errorMessage = "";
  List<Ticket> ticketsBought = [];
  CreateOrderBloc(this.useCase) : super(OrderCreationStatus.idle);

  Future<void> createOrderAndTickets(Order order) async {
    try {
      // Cập nhật trạng thái: Đang tạo đơn hàng
      emit(OrderCreationStatus.creatingOrder);

      // Gọi UseCase để tạo đơn hàng và vé
      ticketsBought = await useCase.call(order);

      // Cập nhật trạng thái: Đang tạo vé
      emit(OrderCreationStatus.creatingTickets);

      await Future.delayed(const Duration(milliseconds: 800));

      // Cập nhật trạng thái: Thành công
      emit(OrderCreationStatus.success);
    }  catch (e) {
      if (e is OrderCreationException) {
        errorMessage = e.message;
        emit(OrderCreationStatus.error);
      } else {
        print('Unknown error: $e');
      }
    }
  }
}
