import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService(this._messaging);

  final FirebaseMessaging _messaging;

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  StreamSubscription<String>? _tokenSubscription;
  StreamSubscription<RemoteMessage>? _messageSubscription;
  StreamSubscription<RemoteMessage>? _openedSubscription;

  void Function()? _onNotificationTap;

  bool _localNotificationsInitialized = false;

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'dayaq_notifications',
    'Dayaq bildirişləri',
    description: 'Dayaq tətbiqi üçün push bildirişləri',
    importance: Importance.high,
  );

  Future<void> initializeLocalNotifications() async {
    if (defaultTargetPlatform != TargetPlatform.android) return;
    if (_localNotificationsInitialized) return;

    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    await _localNotifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (response) {
        _onNotificationTap?.call();
      },
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    _localNotificationsInitialized = true;
  }

  Future<NotificationSettings> requestPermission() {
    return _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
  }

  Future<String?> getToken() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        final apnsToken = await _messaging.getAPNSToken();

        if (apnsToken == null) {
          debugPrint('[FCM] APNs token is not available');
          return null;
        }
      }

      return await _messaging.getToken();
    } catch (error) {
      debugPrint('[FCM] Token retrieval failed: $error');
      return null;
    }
  }

  void listenToTokenRefresh(void Function(String token) onTokenRefresh) {
    _tokenSubscription?.cancel();

    _tokenSubscription = _messaging.onTokenRefresh.listen(
      onTokenRefresh,
      onError: (Object error) {
        debugPrint('[FCM] Token refresh error: $error');
      },
    );
  }

  void listenToForegroundMessages(
    void Function(RemoteMessage message) onMessage,
  ) {
    _messageSubscription?.cancel();

    _messageSubscription = FirebaseMessaging.onMessage.listen(
      (message) async {
        onMessage(message);

        if (defaultTargetPlatform == TargetPlatform.android) {
          await _showForegroundNotification(message);
        }
      },
      onError: (Object error) {
        debugPrint('[FCM] Foreground message error: $error');
      },
    );
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'dayaq_notifications',
        'Dayaq bildirişləri',
        channelDescription: 'Dayaq tətbiqi üçün push bildirişləri',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
    );

    await _localNotifications.show(
      id:
          message.messageId?.hashCode ??
          DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: notification.title,
      body: notification.body,
      notificationDetails: details,
    );
  }

  Future<void> initializeNotificationTapHandling({
    required void Function() onNotificationTap,
  }) async {
    _onNotificationTap = onNotificationTap;

    await _openedSubscription?.cancel();

    _openedSubscription = FirebaseMessaging.onMessageOpenedApp.listen((
      message,
    ) {
      _onNotificationTap?.call();
    });

    final initialMessage = await _messaging.getInitialMessage();

    if (initialMessage != null) {
      _onNotificationTap?.call();
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      await initializeLocalNotifications();

      final launchDetails = await _localNotifications
          .getNotificationAppLaunchDetails();

      if (launchDetails?.didNotificationLaunchApp ?? false) {
        _onNotificationTap?.call();
      }
    }
  }

  Future<void> dispose() async {
    await _tokenSubscription?.cancel();
    await _messageSubscription?.cancel();
    await _openedSubscription?.cancel();

    _tokenSubscription = null;
    _messageSubscription = null;
    _openedSubscription = null;
    _onNotificationTap = null;
  }
}
