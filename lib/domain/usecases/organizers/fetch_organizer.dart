import 'package:ezbooking/data/models/organizer.dart';
import 'package:ezbooking/domain/repositories/organizer_repository.dart';

class FetchOrganizerUseCase {
  final OrganizerRepository _organizerRepository;

  FetchOrganizerUseCase(this._organizerRepository);

  Future<Organizer> call(String id) async {
    return await _organizerRepository.fetchOrganizer(id);
  }
}
