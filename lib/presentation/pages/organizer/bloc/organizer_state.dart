import 'package:ezbooking/data/models/organizer.dart';

abstract class OrganizerState {}

class OrganizerInitial extends OrganizerState {}

class OrganizerLoading extends OrganizerState {}

class OrganizerLoaded extends OrganizerState {
  final Organizer organizer;

  OrganizerLoaded(this.organizer);
}

class OrganizerError extends OrganizerState {
  final String message;

  OrganizerError(this.message);
}
