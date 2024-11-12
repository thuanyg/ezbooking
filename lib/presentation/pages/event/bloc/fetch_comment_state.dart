import 'package:ezbooking/data/models/comment.dart';

abstract class FetchCommentState {}

class FetchCommentsInitial extends FetchCommentState {}

class FetchCommentsLoading extends FetchCommentState {}

class FetchCommentsSuccess extends FetchCommentState {
  List<Comment> comments;

  FetchCommentsSuccess(this.comments);
}

class FetchCommentsFailed extends FetchCommentState {}
