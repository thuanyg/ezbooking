import 'package:ezbooking/data/models/order.dart';

abstract class CreateOrderEvent {}
class CreateOrder extends CreateOrderEvent {
  final Order order;

  CreateOrder(this.order);
}
