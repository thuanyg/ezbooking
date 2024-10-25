import 'package:cloud_firestore/cloud_firestore.dart';

abstract class LatestEventEvent {}

class FetchLatestEvent extends LatestEventEvent {
  final int limit;

  FetchLatestEvent({required this.limit});
}
