import 'package:bloc/bloc.dart';
import 'package:ezbooking/domain/usecases/orders/create_order.dart';
import 'package:ezbooking/presentation/pages/ticket_booking/bloc/orders/create_order_event.dart';
import 'package:ezbooking/presentation/pages/ticket_booking/bloc/orders/create_order_state.dart';

class CreateOrderBloc extends Bloc<CreateOrderEvent, CreateOrderState> {
  final CreateOrderUseCase createOrderUseCase;

  CreateOrderBloc(this.createOrderUseCase) : super(CreateOrderInitial()) {
    on<CreateOrder>((event, emit) async {
      emit(CreateOrderLoading());
      try {
        await createOrderUseCase.call(event.order);
        emit(CreateOrderSuccess(event.order.id));
      } catch (e) {
        emit(CreateOrderFailure(e.toString()));
      }
    });
  }
}
