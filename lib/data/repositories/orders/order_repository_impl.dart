import 'package:ezbooking/data/datasources/orders/order_datasource.dart';
import 'package:ezbooking/data/models/order.dart';
import 'package:ezbooking/data/models/ticket.dart';
import 'package:ezbooking/domain/repositories/order_repository.dart';

class OrderRepositoryImpl extends OrderRepository{
  final OrderDatasource datasource;

  OrderRepositoryImpl(this.datasource);

  @override
  Future<List<Ticket>> createOrderAndTickets(Order order) async {
    return await datasource.createOrderAndTickets(order);
  }
}