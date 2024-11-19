import 'package:ezbooking/data/models/order.dart';
import 'package:ezbooking/domain/repositories/order_repository.dart';

class CreateOrderUseCase {
  final OrderRepository repository;

  CreateOrderUseCase(this.repository);

  Future<void> call(Order order) async {
    return await repository.createOrder(order);
  }
}
