import 'package:ezbooking/data/datasources/organizer/organizer_datasource.dart';
import 'package:ezbooking/data/models/organizer.dart';
import 'package:ezbooking/domain/repositories/organizer_repository.dart';

class OrganizerRepositoryImpl extends OrganizerRepository {
  final OrganizerDatasource datasource;

  OrganizerRepositoryImpl(this.datasource);

  @override
  Future<Organizer> fetchOrganizer(String organizerID) async {
    return await datasource.fetchOrganizer(organizerID);
  }
}
