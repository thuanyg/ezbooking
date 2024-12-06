import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezbooking/core/services/firebase_firestore_service.dart';
import 'package:ezbooking/data/datasources/users/user_datasource.dart';
import 'package:ezbooking/data/models/comment.dart';
import 'package:ezbooking/data/models/user_model.dart';

class UserDatasourceImpl extends UserDatasource {
  final FirebaseFirestoreService _firestoreService;

  UserDatasourceImpl(this._firestoreService);

  @override
  Future<UserModel> fetchUserInformation(String id) async {
    final doc = await _firestoreService.getDocument("users", id);
    return UserModel.fromJson(doc.data() as Map<String, dynamic>);
  }

  @override
  Future<void> updateInformation(String id, UserModel userUpdate) async {
    return await _firestoreService.updateDocument(
        "users", id, userUpdate.toJson());
  }

  @override
  Future<void> comment(Comment comment) async {
    return await _firestoreService.addDocumentWithUid(
        "comments", comment.id, comment.toJson());
  }

  @override
  Future<void> deleteComment(String id) async {
    try {
      final commentRef =
          FirebaseFirestore.instance.collection('comments').doc(id);
      await commentRef.delete();
    } catch (e) {
      throw Exception("Failed to delete comment: $e");
    }
  }

  @override
  Future<void> updateComment(Comment comment) async {
    try {
      final commentRef =
          FirebaseFirestore.instance.collection('comments').doc(comment.id);
      await commentRef.update(comment.toJson());
    } catch (e) {
      throw Exception("Failed to update comment: $e");
    }
  }
}
