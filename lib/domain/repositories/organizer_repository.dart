import 'package:ezbooking/data/models/organizer.dart';

abstract class OrganizerRepository {
  Future<Organizer> fetchOrganizer(String organizerID);
}