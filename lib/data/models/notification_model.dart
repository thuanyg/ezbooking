import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final bool isRead;
  final String actionUrl;
  final Timestamp createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
    required this.actionUrl,
    required this.createdAt,
  });


  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      id: doc.id,
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      isRead: data['isRead'] ?? false,
      actionUrl: data['actionUrl'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'message': message,
      'isRead': isRead,
      'actionUrl': actionUrl,
      'createdAt': createdAt,
    };
  }
}
