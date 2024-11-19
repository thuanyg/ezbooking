import 'package:ezbooking/data/models/comment.dart';

abstract class CommentState {}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentSuccess extends CommentState {
  Comment comment;

  CommentSuccess(this.comment);
}

class CommentFailed extends CommentState {}
