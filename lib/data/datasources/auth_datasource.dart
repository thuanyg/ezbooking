import 'package:ezbooking/core/services/firebase_auth_service.dart';
import 'package:ezbooking/core/services/firebase_firestore_service.dart';
import 'package:ezbooking/data/models/user_creation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthDatasource {
  final FirebaseAuthService firebaseAuthService;
  final FirebaseFirestoreService firestoreService;

  AuthDatasource({
    required this.firestoreService,
    required this.firebaseAuthService,
  });

  Future<User?> signIn(String email, String password) async {
    try {
      User? user =
          await firebaseAuthService.signInWithEmailAndPassword(email, password);
      return user;
    } on FirebaseAuthException catch (e) {
      rethrow;
    } on Exception catch (e) {
      rethrow;
    }
  }

  Future<void> signUp(UserCreation userCreation) async {
    try {
      User? user = await firebaseAuthService.registerWithEmailAndPassword(
          userCreation.email!, userCreation.password!);
      if (user != null) {
        await firestoreService.addDocumentWithUid(
            "users", user.uid, userCreation.toJson());
      }
    } on FirebaseAuthException catch (e) {
      final user = await firebaseAuthService.getCurrentUser();
      user?.delete();
      rethrow;
    }
  }
}
