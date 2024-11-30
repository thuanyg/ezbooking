import 'package:ezbooking/data/models/order.dart';
import 'package:ezbooking/data/models/ticket.dart';
import 'package:ezbooking/domain/repositories/order_repository.dart';

class CreateOrderAndTicketUseCase {
  final OrderRepository repository;

  CreateOrderAndTicketUseCase(this.repository);

  Future<List<Ticket>> call(Order order) async {
    return await repository.createOrderAndTickets(order);
  }
}
