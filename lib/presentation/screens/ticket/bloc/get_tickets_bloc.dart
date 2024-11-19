import 'package:bloc/bloc.dart';
import 'package:ezbooking/domain/usecases/ticket/get_tickets.dart';
import 'package:ezbooking/presentation/screens/ticket/bloc/get_tickets_event.dart';
import 'package:ezbooking/presentation/screens/ticket/bloc/get_tickets_state.dart';

class GetTicketsBloc extends Bloc<GetTicketsEvent, GetTicketsState> {
  final GetTicketsUseCase getTicketsUseCase;

  GetTicketsBloc(this.getTicketsUseCase) : super(GetTicketsInitial()) {
    on<GetTicketsOfUser>(
      (event, emit) async {
        emit(GetTicketsLoading());
        try {
          final tickets = await getTicketsUseCase(event.userID);
          emit(GetTicketsSuccess(tickets));
        } catch (e) {
          emit(GetTicketsError(e.toString()));
        }
      },
    );
  }
}
