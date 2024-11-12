import 'package:ezbooking/data/models/comment.dart';

abstract class FetchCommentEvent   {}

class FetchComments extends FetchCommentEvent {
  String eventID;

  FetchComments({required this.eventID});
}
