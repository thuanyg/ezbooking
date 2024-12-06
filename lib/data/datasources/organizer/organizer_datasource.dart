import 'package:ezbooking/data/models/organizer.dart';

abstract class OrganizerDatasource {
  Future<Organizer> fetchOrganizer(String organizerID);
}