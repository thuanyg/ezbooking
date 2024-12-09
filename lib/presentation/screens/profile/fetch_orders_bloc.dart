import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cf;
import 'package:ezbooking/data/models/order.dart';

abstract class FetchOrdersState {}

class InitialOrdersState implements FetchOrdersState {}

class LoadingOrdersState implements FetchOrdersState {}

class LoadedOrdersState implements FetchOrdersState {
  final List<Order> orders;

  const LoadedOrdersState(this.orders);
}

class ErrorOrdersState implements FetchOrdersState {
  final String errorMessage;

  const ErrorOrdersState(this.errorMessage);
}

class FetchOrdersCubit extends Cubit<FetchOrdersState> {
  final cf.FirebaseFirestore firebaseFirestore = cf.FirebaseFirestore.instance;

  FetchOrdersCubit() : super(InitialOrdersState());

  Future<void> fetchOrders(String userID) async {
    try {
      emit(LoadingOrdersState());

      final querySnapshot = await firebaseFirestore
          .collection('orders')
          .where('userID', isEqualTo: userID)
          .orderBy('createdAt', descending: true)
          .get();

      final orders = querySnapshot.docs
          .map((doc) => Order.fromFirestore(doc.data(), doc.id))
          .toList();

      emit(LoadedOrdersState(orders));
    } catch (error) {
      emit(ErrorOrdersState(error.toString()));
    }
  }
}