import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezbooking/data/datasources/organizer/organizer_datasource.dart';
import 'package:ezbooking/data/models/organizer.dart';

class OrganizerDatasourceImpl extends OrganizerDatasource {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<Organizer> fetchOrganizer(String organizerID) async {
    try {
      final organizerDoc = await FirebaseFirestore.instance
          .collection("organizers")
          .doc(organizerID)
          .get();

      if (!organizerDoc.exists) {
        throw Exception("Organizer with ID $organizerID does not exist.");
      }

      final organizer =
          Organizer.fromJson(organizerDoc.data() as Map<String, dynamic>);
      return organizer;
    } catch (e) {
      print("Error fetching organizer: $e");
      rethrow;
    }
  }
}
