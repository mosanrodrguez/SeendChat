import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:ui';
import 'api_service.dart';

class FirebaseService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  static Function(String?, String?, String?)? onNotificationTap;

  static Future<void> init() async {
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    final fcmToken = await messaging.getToken();
    if (fcmToken != null) {
      await ApiService.post('fcm-token', {'fcmToken': fcmToken});
    }

    messaging.onTokenRefresh.listen((token) {
      ApiService.post('fcm-token', {'fcmToken': token});
    });

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);
    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        final chatId = response.payload;
        if (response.actionId == 'reply') {
          onNotificationTap?.call(chatId, 'reply', response.input);
        } else if (response.actionId == 'mark_read') {
          onNotificationTap?.call(chatId, 'mark_read', null);
        } else {
          onNotificationTap?.call(chatId, 'open', null);
        }
      },
    );

    FirebaseMessaging.onMessage.listen(_showLocalNotification);
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      onNotificationTap?.call(message.data['chatId'], 'open', null);
    });
  }

  static void _showLocalNotification(RemoteMessage message) {
    final notification = message.notification;
    final data = message.data;

    if (notification != null) {
      _notifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'seend_messages',
            'Mensajes',
            channelDescription: 'Notificaciones de mensajes',
            importance: Importance.high,
            priority: Priority.high,
            color: Color(0xFF3A76F0),
          ),
        ),
        payload: data['chatId'],
      );
    }
  }
}
