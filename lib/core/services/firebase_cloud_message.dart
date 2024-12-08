import 'dart:io';

import 'package:ezbooking/core/services/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseCloudMessage {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  /// Initialize Firebase Messaging
  Future<void> initialize() async {
    // Request Permission
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User denied or did not grant permission');
    }

    await getToken();

    // Handle receive foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleMessage(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification clicked: ${message.notification?.title}');
    });
  }

  /// Get token FCM
  Future<void> getToken() async {
    String? token;
    if (Platform.isAndroid) {
      token = await FirebaseMessaging.instance.getToken();
      if (token == null) {
        throw Exception("Không thể lấy FCM token.");
      }
    }

    if (Platform.isIOS) {
      // token = await FirebaseMessaging.instance.getAPNSToken();
      // if (token == null) {
      //   throw Exception("Không thể lấy FCM token.");
      // }
    }
    print('FCM Token: $token');
  }

  Future<void> _handleMessage(RemoteMessage message) async {
    final String? title = message.notification?.title;
    final String? body = message.notification?.body;

    if (title != null && body != null) {
      await NotificationService.showInstantNotification(title, body);
    }
  }
}
