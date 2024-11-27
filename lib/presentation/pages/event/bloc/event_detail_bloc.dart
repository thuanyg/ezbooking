import 'package:bloc/bloc.dart';
import 'package:ezbooking/domain/usecases/events/fetch_event_detail.dart';
import 'package:ezbooking/presentation/pages/event/bloc/event_detail_event.dart';
import 'package:ezbooking/presentation/pages/event/bloc/event_detail_state.dart';

class EventDetailBloc extends Bloc<EventDetailEvent, EventDetailState> {
  final FetchEventDetailUseCase _fetchEventDetailUseCase;

  EventDetailBloc(this._fetchEventDetailUseCase) : super(EventDetailInitial()) {
    on<FetchEventDetail>(
      (event, emit) async {
        try {
          emit(EventDetailLoading());
          final eventDetail =
              await _fetchEventDetailUseCase(eventID: event.eventId);
          emit(EventDetailLoaded(eventDetail));
        } on Exception catch (e) {
          emit(EventDetailError(e.toString()));
        }
      },
    );
  }

  void reset() {
    emit(EventDetailInitial());
  }
}
