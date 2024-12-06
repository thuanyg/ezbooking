abstract class OrganizerEvent {}

class FetchOrganizer extends OrganizerEvent {
  final String id;

  FetchOrganizer(this.id);
}
