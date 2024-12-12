import 'package:ezbooking/data/models/comment.dart';
import 'package:ezbooking/domain/usecases/events/fetch_comments.dart';
import 'package:ezbooking/presentation/pages/event/bloc/comment_state.dart';
import 'package:ezbooking/presentation/pages/event/bloc/fetch_comment_event.dart';
import 'package:ezbooking/presentation/pages/event/bloc/fetch_comment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FetchCommentBloc extends Bloc<FetchCommentEvent, FetchCommentState> {
  final FetchCommentsUseCase fetchCommentsUseCase;
  double rating = 5.0;

  FetchCommentBloc(this.fetchCommentsUseCase) : super(FetchCommentsInitial()) {
    on<FetchComments>(
      (event, emit) async {
        try {
          emit(FetchCommentsLoading());
          final listComment = await fetchCommentsUseCase.get(event.eventID);
          emit(FetchCommentsSuccess(listComment));
        } on Exception catch (e) {
          emit(FetchCommentsFailed());
        }
      },
    );
  }

  void addComment(Comment comment) {
    final currentState = state;
    if (currentState is FetchCommentsSuccess) {
      List<Comment> comments = currentState.comments;
      comments.insert(0, comment);
      emit(FetchCommentsSuccess(comments));
    }
  }
  void removeComment(Comment comment) {
    final currentState = state;
    if (currentState is FetchCommentsSuccess) {
      List<Comment> comments = currentState.comments;
      comments.remove(comment);
      emit(FetchCommentsSuccess(comments));
    }
  }
}
