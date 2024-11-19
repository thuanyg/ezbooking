abstract class CreateOrderState {}

class CreateOrderInitial extends CreateOrderState {}

class CreateOrderLoading extends CreateOrderState {}

class CreateOrderSuccess extends CreateOrderState {
  final String orderId;

  CreateOrderSuccess(this.orderId);
}

class CreateOrderFailure extends CreateOrderState {
  final String errorMessage; // Error message when creating the order fails.

  CreateOrderFailure(this.errorMessage);
}
