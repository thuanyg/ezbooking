import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezbooking/data/models/comment.dart';
import 'package:ezbooking/domain/repositories/user_repository.dart';

class CommentEventUseCase {
  final UserRepository userRepository;

  CommentEventUseCase(this.userRepository);

  Future<void> call(Comment comment) async {
    return userRepository.comment(comment);
  }


}
