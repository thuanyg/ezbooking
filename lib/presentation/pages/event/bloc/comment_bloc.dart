import 'package:ezbooking/domain/usecases/user/comment_event.dart';
import 'package:ezbooking/presentation/pages/event/bloc/comment_event.dart';
import 'package:ezbooking/presentation/pages/event/bloc/comment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentEventUseCase commentEventUseCase;
  double rating = 5.0;
  CommentBloc(this.commentEventUseCase) : super(CommentInitial()) {
    on<CommentAction>(
      (event, emit) async {
        try {
          emit(CommentLoading());
          await commentEventUseCase.call(
            event.comment,
          );
          emit(CommentSuccess(event.comment));
        } on Exception catch (e) {
          emit(CommentFailed());
        }
      },
    );
  }

  reset(){
    emit(CommentInitial());
  }
}
