import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

abstract class LatestEventEvent {}

class FetchLatestEvent extends LatestEventEvent {
  final int limit;
  final Position? position;
  final bool isFetchApproximately;

  FetchLatestEvent(
      {required this.isFetchApproximately, required this.limit, this.position});
}
