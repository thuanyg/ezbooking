import 'package:cloud_functions/cloud_functions.dart';

class FirebaseCloudFunctions {
  static final instance = FirebaseCloudFunctions();

  Future<void> deleteUser(String userId) async {
    try {
      final functions = FirebaseFunctions.instance;

      final result = await functions.httpsCallable('deleteUser').call({'userId': userId});

      print('Success: ${result.data['message']}');
    } catch (e) {
      print('Error: $e');
    }
  }
}