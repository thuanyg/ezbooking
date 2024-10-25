abstract class UpcomingEventEvent {}

class FetchUpcomingEvent extends UpcomingEventEvent {
  final int limit;

  FetchUpcomingEvent({required this.limit});
}
