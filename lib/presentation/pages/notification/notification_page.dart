// notification_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezbooking/core/config/app_colors.dart';
import 'package:ezbooking/data/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'notification_cubit.dart';
import 'notification_state.dart';

class NotificationPage extends StatefulWidget {
  final String userId;

  const NotificationPage({Key? key, required this.userId}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    // Tự động tải thông báo khi màn hình khởi tạo
    context.read<NotificationCubit>().fetchNotifications(widget.userId);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        title: const Text('Notifications'),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.clear_all),
          //   onPressed: () {
          //     // TODO: Implement clear all notifications
          //   },
          // ),
        ],
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is NotificationError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: TextStyle(color: Colors.red),
                  ),
                  ElevatedButton(
                    onPressed: () => context
                        .read<NotificationCubit>()
                        .fetchNotifications(widget.userId),
                    child: const Text('Try again!!!'),
                  )
                ],
              ),
            );
          }

          if (state is NotificationLoaded) {
            final notifications = state.notifications;

            if (notifications.isEmpty) {
              return _buildEmptyNotificationView();
            }

            return Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 10),
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return _buildNotificationItem(context, notification);
                },
              ),
            );
          }

          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyNotificationView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          SizedBox(height: 20),
          Text(
            'Không có thông báo mới',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
      BuildContext context, NotificationModel notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Dismissible(
        key: Key(notification.id),
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (_) {
          context
              .read<NotificationCubit>()
              .deleteNotification(widget.userId, notification.id);
        },
        child: ListTile(
          title: Text(
            notification.title,
            style: TextStyle(
              fontWeight:
                  notification.isRead ? FontWeight.normal : FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                timeago.format(notification.createdAt.toDate()),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          trailing: !notification.isRead
              ? Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                )
              : null,
          onTap: () {
            // Đánh dấu đã đọc khi nhấn vào thông báo
            context
                .read<NotificationCubit>()
                .updateNotificationStatus(widget.userId, notification.id);

            // TODO: Xử lý chuyển hướng nếu có actionUrl
            if (notification.actionUrl.isNotEmpty) {
              // Ví dụ: Navigator.pushNamed(context, notification.actionUrl);
            }
          },
        ),
      ),
    );
  }
}
