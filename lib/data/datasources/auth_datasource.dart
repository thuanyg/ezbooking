import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezbooking/core/services/firebase_auth_service.dart';
import 'package:ezbooking/core/services/firebase_firestore_service.dart';
import 'package:ezbooking/core/utils/utils.dart';
import 'package:ezbooking/data/models/user_creation.dart';
import 'package:ezbooking/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
          avatarUrl: user.photoURL ?? "",
          phoneNumber: user.phoneNumber ?? "",
          createdAt: Timestamp.now(),
          birthday: "2000-01-01",
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

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if(googleUser == null) throw Exception();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      if (googleAuth == null) return null;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCred =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCred.user;

      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .where("id", isEqualTo: user.uid)
            .where("email", isEqualTo: user.email)
            .get();

        if (userDoc.docs.isEmpty) {
          final userModel = UserModel(
            id: user.uid,
            email: user.email ?? "",
            fullName: user.displayName ?? "",
            password: "",
            avatarUrl: user.photoURL ?? "",
            phoneNumber: user.phoneNumber ?? "",
            createdAt: Timestamp.now(),
            birthday: "2000-01-01",
            isDelete: false,
          );

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set(userModel.toJson());
        }
      }

      return user;
    } on Exception catch (e) {
      print('exception->$e');
      rethrow;
    }
  }
}
