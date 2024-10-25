abstract class EventDetailEvent {}

class FetchEventDetail extends EventDetailEvent {
  String eventId;

  FetchEventDetail(this.eventId);
}

