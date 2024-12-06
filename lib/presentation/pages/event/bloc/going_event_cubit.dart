import 'package:ezbooking/data/models/going.dart';
import 'package:ezbooking/domain/usecases/events/fetch_going_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoingEventCubit extends Cubit<GoingEventState> {
  final FetchGoingEventUseCase useCase;

  GoingEventCubit(this.useCase) : super(GoingEventInitial());

  Future<void> fetchGoingEvent(String eventID) async {
    try {
      emit(GoingEventLoading()); // Emit loading state

      final going = await useCase(eventID); // Fetch the data from UseCase

      emit(GoingEventSuccess(going)); // Emit success state with the data
    } catch (e) {
      emit(GoingEventError(e.toString())); // Emit error state if something goes wrong
    }
  }
}


abstract class GoingEventState {}

class GoingEventInitial extends GoingEventState {}

class GoingEventLoading extends GoingEventState {}

class GoingEventSuccess extends GoingEventState {
  final Going going;

  GoingEventSuccess(this.going);
}

class GoingEventError extends GoingEventState {
  final String error;

  GoingEventError(this.error);
}
