import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore _firestore;

  FirebaseFirestoreService(this._firestore);

  // Thêm document vào collection
  Future<void> addDocument(
      String collectionPath, Map<String, dynamic> data) async {
    await _firestore.collection(collectionPath).add(data);
  }

  // Thêm document vào collection
  Future<void> addDocumentWithUid(
      String collectionPath, String uid, Map<String, dynamic> data) async {
    await _firestore.collection(collectionPath).doc(uid).set(data);
  }

  Future<List<QueryDocumentSnapshot>> getDocuments(
      String collectionPath) async {
    QuerySnapshot querySnapshot =
        await _firestore.collection(collectionPath).get();
    return querySnapshot.docs;
  }

  Future<List<QueryDocumentSnapshot>> getDocumentsWithLimit(
      String collectionPath, int limit) async {
    QuerySnapshot querySnapshot =
        await _firestore.collection(collectionPath).limit(limit).get();
    return querySnapshot.docs;
  }

  // Phương thức này nhận vào các tham số để lọc theo khoảng ngày
  Stream<List<QueryDocumentSnapshot>> getDocumentsSnapshotWithConditions(
      String collectionPath,
      String dateField,
      String startDate,
      String endDate) {
    return _firestore
        .collection(collectionPath)
        .where(dateField, isGreaterThanOrEqualTo: startDate) // Lọc từ startDate
        .where(dateField, isLessThanOrEqualTo: endDate) // Lọc đến endDate
        .snapshots() // Lắng nghe sự thay đổi
        .map((QuerySnapshot snapshot) {
      // Trả về danh sách các tài liệu
      return snapshot.docs;
    });
  }

  Stream<List<QueryDocumentSnapshot>> getDocumentsSnapshot(
      String collectionPath) {
    return _firestore.collection(collectionPath).snapshots().map((snapshot) {
      return snapshot.docs;
    });
  }

  // Lấy document theo documentId
  Future<DocumentSnapshot> getDocument(
      String collectionPath, String documentId) async {
    return await _firestore.collection(collectionPath).doc(documentId).get();
  }

  // Cập nhật document theo documentId
  Future<void> updateDocument(String collectionPath, String documentId,
      Map<String, dynamic> data) async {
    await _firestore.collection(collectionPath).doc(documentId).update(data);
  }

  // Cập nhật document theo email
  Future<void> updateDocumentByEmail(
      String collectionPath, String email, Map<String, dynamic> data) async {
    try {
      // Tìm các document trong collectionPath có email khớp
      List<QueryDocumentSnapshot> documents =
          await getDocumentsWhere(collectionPath, "email", email);

      if (documents.isNotEmpty) {
        String documentId = documents.first.id;
        await updateDocument(collectionPath, documentId, data);
        print("Document with email $email updated successfully.");
      } else {
        print("No document found with email $email.");
      }
    } catch (e) {
      print("Error updating document by email: $e");
      rethrow;
    }
  }

  // Xóa document theo documentId
  Future<void> deleteDocument(String collectionPath, String documentId) async {
    await _firestore.collection(collectionPath).doc(documentId).delete();
  }

  // Hàm kiểm tra xem email có tồn tại trong collection hay không
  Future<bool> checkIfEmailExists(String collectionPath, String email) async {
    try {
      // Truy vấn để tìm email trong collection
      QuerySnapshot result = await _firestore
          .collection(collectionPath)
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      return result.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<DocumentSnapshot?> getUserByEmail(
      String collectionPath, String email) async {
    try {
      // Query Firestore to find the document with matching email
      QuerySnapshot result = await _firestore
          .collection(collectionPath)
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      // Check if any document was found
      if (result.docs.isNotEmpty) {
        return result.docs.first;
      } else {
        return null; // No user found
      }
    } catch (e) {
      print("Error fetching user by email: $e");
      return null;
    }
  }

  // Method to get documents where a condition is met
  Future<List<QueryDocumentSnapshot>> getDocumentsWhere(
      String collectionPath, String field, dynamic value) async {
    try {
      // Query Firestore to get documents where the specified field equals the given value
      QuerySnapshot querySnapshot = await _firestore
          .collection(collectionPath)
          .where(field, isEqualTo: value)
          .get();

      // Return the list of documents
      return querySnapshot.docs;
    } catch (e) {
      print("Error fetching documents where $field == $value: $e");
      return [];
    }
  }
}
