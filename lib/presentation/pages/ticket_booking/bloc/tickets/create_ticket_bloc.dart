import 'package:bloc/bloc.dart';
import 'package:ezbooking/core/utils/utils.dart';
import 'package:ezbooking/data/models/order.dart';
import 'package:ezbooking/data/models/ticket.dart';
import 'package:ezbooking/domain/usecases/orders/create_order.dart';
import 'package:ezbooking/domain/usecases/ticket/create_ticket.dart';
import 'package:ezbooking/presentation/pages/ticket_booking/bloc/orders/create_order_event.dart';
import 'package:ezbooking/presentation/pages/ticket_booking/bloc/orders/create_order_state.dart';
import 'package:ezbooking/presentation/pages/ticket_booking/bloc/tickets/create_ticket_event.dart';
import 'package:ezbooking/presentation/pages/ticket_booking/bloc/tickets/create_ticket_state.dart';

class CreateTicketBloc extends Bloc<CreateTicketEvent, CreateTicketState> {
  final CreateTicketUseCase createTicketUseCase;

  CreateTicketBloc(this.createTicketUseCase) : super(CreateTicketInitial()) {
    on<CreateTicket>((event, emit) async {
      emit(CreateTicketLoading());
      try {
        await createTicketUseCase.call(event.ticket);
        emit(CreateTicketSuccess());
      } catch (e) {
        emit(CreateTicketFailure(e.toString()));
      }
    });
  }

  void emitSuccess() {
    emit(CreateTicketSuccess());
  }

  void emitError(String error) {
    emit(CreateTicketFailure(error));
  }
}
