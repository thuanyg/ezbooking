import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezbooking/data/models/notification_model.dart';
import 'package:ezbooking/presentation/pages/notification/notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  NotificationCubit() : super(NotificationInitial());

  // Fetch notifications for a user
  Future<void> fetchNotifications(String userId) async {
    try {
      emit(NotificationLoading());

      final querySnapshot = await _firestore
          .collection('notifications')
          .doc(userId)
          .collection('userNotifications')
          .orderBy("createdAt", descending: true)
          .get();

      final notifications = querySnapshot.docs.map((doc) {
        return NotificationModel.fromFirestore(doc);
      }).toList();

      emit(NotificationLoaded(notifications));
    } catch (e) {
      emit(NotificationError('Failed to load notifications'));
    }
  }

  // Add a new notification
  Future<void> addNotification(
      String userId, NotificationModel notification) async {
    try {
      final notificationData = notification.toFirestore();

      await _firestore
          .collection('notifications')
          .doc(userId)
          .collection('userNotifications')
          .add(notificationData);
    } catch (e) {
      emit(NotificationError('Failed to add notification'));
    }
  }

  // Update the 'isRead' field for a notification
  Future<void> updateNotificationStatus(
      String userId, String notificationId) async {
    try {
      await _firestore
          .collection('notifications')
          .doc(userId)
          .collection('userNotifications')
          .doc(notificationId)
          .update({'isRead': true});

      // emit(NotificationUpdated());
    } catch (e) {
      emit(NotificationError('Failed to update notification'));
    }
  }

  // Delete a notification
  Future<void> deleteNotification(String userId, String notificationId) async {
    try {
      await _firestore
          .collection('notifications')
          .doc(userId)
          .collection('userNotifications')
          .doc(notificationId)
          .delete();

      emit(NotificationDeleted());
    } catch (e) {
      emit(NotificationError('Failed to delete notification'));
    }
  }
}
