import 'package:geolocator/geolocator.dart';

abstract class UpcomingEventEvent {}

class FetchUpcomingEvent extends UpcomingEventEvent {
  final int limit;
  final bool isFetchApproximately;
  final Position? position;

  FetchUpcomingEvent({
    required this.limit,
    required this.isFetchApproximately,
    this.position,
  });
}
