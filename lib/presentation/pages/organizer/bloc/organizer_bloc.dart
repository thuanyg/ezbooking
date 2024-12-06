import 'package:bloc/bloc.dart';
import 'package:ezbooking/domain/usecases/organizers/fetch_organizer.dart';
import 'package:ezbooking/presentation/pages/organizer/bloc/organizer_event.dart';
import 'package:ezbooking/presentation/pages/organizer/bloc/organizer_state.dart';

class OrganizerBloc extends Bloc<OrganizerEvent, OrganizerState> {
  final FetchOrganizerUseCase fetchOrganizerUseCase;

  OrganizerBloc(this.fetchOrganizerUseCase) : super(OrganizerInitial()) {
    on<FetchOrganizer>(_onFetchOrganizer);
  }

  Future<void> _onFetchOrganizer(
      FetchOrganizer event, Emitter<OrganizerState> emit) async {
    emit(OrganizerLoading());
    try {
      final organizer = await fetchOrganizerUseCase(event.id);
      emit(OrganizerLoaded(organizer));
    } catch (e) {
      emit(OrganizerError(e.toString()));
    }
  }
}
