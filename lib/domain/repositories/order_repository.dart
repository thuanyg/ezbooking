import 'package:ezbooking/data/models/order.dart';

abstract class OrderRepository {
  Future<void> createOrder(Order order);
}