import 'package:bloc/bloc.dart';
import 'package:ezbooking/domain/usecases/events/fetch_events_popular.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/popular/popular_event_event.dart';
import 'package:ezbooking/presentation/screens/explore/bloc/popular/popular_event_state.dart';

class PopularEventBloc extends Bloc<PopularEventEvent, PopularEventState> {
  final FetchEventsPopularUseCase _fetchEventsPopularUseCase;

  PopularEventBloc(this._fetchEventsPopularUseCase)
      : super(PopularEventInitial()) {
    on<FetchPopularEvent>((event, emit) async {
      try {
        emit(PopularEventLoading());
        final events = await _fetchEventsPopularUseCase.call();
        emit(PopularEventLoaded(events));
      } on Exception catch (e) {
        emit(PopularEventError(e.toString()));
      }
    });
  }
}
