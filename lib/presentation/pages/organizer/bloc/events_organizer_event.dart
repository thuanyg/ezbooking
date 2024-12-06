abstract class EventsOrganizerEvent {}

class FetchEventsOrganizer extends EventsOrganizerEvent {
  final String organizerID;

  FetchEventsOrganizer(this.organizerID);
}
