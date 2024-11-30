import 'package:ezbooking/data/models/order.dart';
import 'package:ezbooking/data/models/ticket.dart';

abstract class OrderDatasource {
  Future<List<Ticket>> createOrderAndTickets(Order order);
}
