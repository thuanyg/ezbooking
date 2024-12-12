import 'package:ezbooking/data/models/notification_model.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<NotificationModel> notifications;
  NotificationLoaded(this.notifications);
}

class NotificationError extends NotificationState {
  final String message;
  NotificationError(this.message);
}

class NotificationUpdated extends NotificationState {}

class NotificationDeleted extends NotificationState {}
