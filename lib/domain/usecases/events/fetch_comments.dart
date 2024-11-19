import 'package:ezbooking/data/models/comment.dart';
import 'package:ezbooking/domain/repositories/event_repository.dart';

class FetchCommentsUseCase {
  final EventRepository _repository;

  FetchCommentsUseCase(this._repository);

  Future<List<Comment>> get(String eventID) async {
    return await _repository.fetchComments(eventID);
  }
}
