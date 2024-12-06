import 'package:ezbooking/core/services/firebase_auth_service.dart';
import 'package:ezbooking/core/services/firebase_firestore_service.dart';
import 'package:ezbooking/core/utils/utils.dart';
import 'package:ezbooking/data/models/user_creation.dart';
import 'package:ezbooking/data/models/user_model.dart';
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
      // Step 1: Register user in Firebase Authentication
      User? user = await firebaseAuthService.registerWithEmailAndPassword(
        userCreation.email!,
        userCreation.password!,
      );

      if (user != null) {
        // Step 2: Prepare user model for Firestore
        final passwordHash =
            AppUtils.encryptData(userCreation.password!, AppUtils.secretKey);
        final userModel = UserModel(
          id: user.uid,
          email: userCreation.email,
          fullName: userCreation.fullName,
          password: passwordHash,
          isDelete: false,
        );

        // Step 3: Save user data to Firestore
        await firestoreService.addDocumentWithUid(
          "users",
          user.uid,
          userModel.toJson(),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Rollback Firebase Authentication if Firestore operation fails
      final user = await firebaseAuthService.getCurrentUser();
      await user?.delete(); // Ensure no orphaned Auth user exists
      rethrow;
    } catch (e) {
      // Handle Firestore or other errors
      final user = await firebaseAuthService.getCurrentUser();
      if (user != null) {
        await user.delete(); // Rollback Firebase Authentication
      }
      rethrow;
    }
  }
}
