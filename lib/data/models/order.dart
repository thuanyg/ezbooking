import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String id; // ID đơn hàng
  final String userID; // ID người mua
  final String eventID; // ID sự kiện liên quan
  final int ticketQuantity; // Số lượng vé
  final double ticketPrice; // Tổng giá vé
  final String? paymentID; // ID giao dịch thanh toán
  final String? paymentMethod; // ID giao dịch thanh toán
  final String orderType; // Loại đơn hàng (Online, AtEvent)
  final Timestamp createdAt; // Thời gian tạo đơn hàng
  final Timestamp? updatedAt; // Thời gian cập nhật đơn hàng
  final String
      status; // Trạng thái đơn hàng (Pending, Paid, Cancelled, Completed)
  final double? discount; // Số tiền giảm giá hoặc khuyến mãi

  Order({
    required this.id,
    required this.userID,
    required this.eventID,
    required this.ticketQuantity,
    required this.ticketPrice,
    this.paymentID,
    this.paymentMethod,
    required this.orderType,
    required this.createdAt,
    this.updatedAt,
    required this.status,
    this.discount,
  });

  // Chuyển từ Firestore Document Snapshot sang Order object
  factory Order.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Order(
      id: documentId,
      userID: data['userID'] ?? '',
      eventID: data['eventID'] ?? '',
      ticketQuantity: data['ticketQuantity'] ?? 0,
      ticketPrice: (data['ticketPrice'] ?? 0).toDouble(),
      paymentID: data['paymentID'],
      paymentMethod: data['paymentMethod'],
      orderType: data['orderType'] ?? 'Online',
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
      status: data['status'] ?? 'Pending',
      discount: data['discount'] != null
          ? (data['discount'] as num).toDouble()
          : null,
    );
  }

  // Chuyển từ Order object sang Map để lưu vào Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userID': userID,
      'eventID': eventID,
      'ticketQuantity': ticketQuantity,
      'ticketPrice': ticketPrice,
      'paymentID': paymentID,
      'orderType': orderType,
      'createdAt': createdAt,
      'paymentMethod': paymentMethod,
      'updatedAt': updatedAt,
      'status': status,
      'discount': discount,
    };
  }
}
