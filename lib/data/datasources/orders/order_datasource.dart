import 'package:ezbooking/data/models/order.dart';

abstract class OrderDatasource {
  Future<void> createOrder(Order order);
}