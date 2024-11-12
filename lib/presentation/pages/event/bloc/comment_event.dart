import 'package:ezbooking/data/models/comment.dart';

abstract class CommentEvent {}

class CommentAction extends CommentEvent {
  Comment comment;

  CommentAction({required this.comment});
}
