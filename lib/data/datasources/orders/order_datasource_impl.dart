import 'package:cloud_firestore/cloud_firestore.dart' as cf;
import 'order_datasource.dart';
import 'package:ezbooking/data/models/order.dart';

class OrderDatasourceImpl extends OrderDatasource {
  final cf.FirebaseFirestore firestore = cf.FirebaseFirestore.instance;

  @override
  Future<void> createOrder(Order order) async {
    try {
      await firestore
          .collection('orders')
          .doc(order.id)
          .set(order.toFirestore());
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }
}
