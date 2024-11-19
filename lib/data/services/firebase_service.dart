import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Firebase Authentication
  // Sign up a new user
  Future<User?> signUp(String email, String password, String fullName) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      await _firestore.collection('users').doc(user?.uid).set({
        'fullName': fullName,
        'email': email,
      });

      return user;
    } catch (e) {
      print("Error signing up: $e");
      return null;
    }
  }

  // Sign in a user
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print("Error signing in: $e");
      return null;
    }
  }

  // Sign out a user
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  // Get the current user
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  /// Firebase Firestore
  // Create a new document in Firestore
  Future<void> createDocument(
      String collectionPath, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collectionPath).add(data);
    } catch (e) {
      print("Error creating document: $e");
    }
  }

  // Read all documents from a collection
  Future<List<Map<String, dynamic>>> readDocuments(
      String collectionPath) async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection(collectionPath).get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Error reading documents: $e");
      return [];
    }
  }

  // Read a specific document by ID
  Future<Map<String, dynamic>?> readDocumentById(
      String collectionPath, String documentId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection(collectionPath).doc(documentId).get();
      return docSnapshot.data() as Map<String, dynamic>?;
    } catch (e) {
      print("Error reading document: $e");
      return null;
    }
  }

  // Update a document by ID
  Future<void> updateDocument(String collectionPath, String documentId,
      Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collectionPath).doc(documentId).update(data);
    } catch (e) {
      print("Error updating document: $e");
    }
  }

  // Delete a document by ID
  Future<void> deleteDocument(String collectionPath, String documentId) async {
    try {
      await _firestore.collection(collectionPath).doc(documentId).delete();
    } catch (e) {
      print("Error deleting document: $e");
    }
  }
}
