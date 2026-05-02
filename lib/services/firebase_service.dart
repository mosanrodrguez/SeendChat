import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'api_service.dart';

class FirebaseService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  static Function(String? chatId, String? action, String? reply)? onNotificationTap;

  static Future<void> init() async {
    // Solicitar permisos
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    // Obtener token FCM
    final fcmToken = await messaging.getToken();
    if (fcmToken != null) {
      await ApiService.post('fcm-token', {'fcmToken': fcmToken});
    }

    // Escuchar token refresh
    messaging.onTokenRefresh.listen((token) {
      ApiService.post('fcm-token', {'fcmToken': token});
    });

    // Configurar notificaciones locales
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

    // Primer plano
    FirebaseMessaging.onMessage.listen(_showLocalNotification);

    // Segundo plano (app abierta pero no en foco)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final chatId = message.data['chatId'];
      onNotificationTap?.call(chatId, 'open', null);
    });

    // App cerrada (background)
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
  }

  static Future<void> _backgroundHandler(RemoteMessage message) async {
    // Procesar en background
  }

  static void _showLocalNotification(RemoteMessage message) {
    final notification = message.notification;
    final data = message.data;

    if (notification != null) {
      _notifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'seend_messages',
            'Mensajes',
            channelDescription: 'Notificaciones de mensajes',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            color: '#3A76F0',
            actions: [
              const AndroidNotificationAction('mark_read', 'Marcar como leído', icon: 'ic_check'),
              const AndroidNotificationAction('reply', 'Responder', icon: 'ic_reply', type: AndroidNotificationActionType.reply),
            ],
          ),
        ),
        payload: data['chatId'],
      );
    }
  }
}
