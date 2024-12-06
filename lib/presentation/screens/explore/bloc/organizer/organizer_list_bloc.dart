import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezbooking/data/models/organizer.dart';

abstract class OrganizerListState {}

class OrganizerListInitial extends OrganizerListState {}

class OrganizerListLoading extends OrganizerListState {}

class OrganizerListSuccess extends OrganizerListState {
  final List<Organizer> organizers; // Assuming 'Organizer' is your model

  OrganizerListSuccess(this.organizers);
}

class OrganizerListFailure extends OrganizerListState {
  final String error;

  OrganizerListFailure(this.error);
}

class OrganizerListBloc extends Cubit<OrganizerListState> {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  OrganizerListBloc()
      : super(OrganizerListInitial());

  // Method to fetch organizers from Firestore
  Future<void> fetchOrganizers() async {
    emit(OrganizerListLoading());
    try {
      // Fetch data from Firestore
      QuerySnapshot snapshot =
          await firebaseFirestore.collection('organizers').get();
      List<Organizer> organizers = snapshot.docs
          .map((doc) => Organizer.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      emit(OrganizerListSuccess(
          organizers)); // Emit success state with organizers list
    } catch (e) {
      emit(OrganizerListFailure(
          e.toString())); // Emit failure state if there's an error
    }
  }
}
