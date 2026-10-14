import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../core/di/injection.dart';
import '../core/router/app_router.dart';
import '../core/router/app_routes.dart';
import '../core/services/notification_service.dart';
import '../core/storage/token_storage.dart';
import '../core/theme/app_theme.dart';

class DayaqApp extends StatefulWidget {
  const DayaqApp({super.key});

  @override
  State<DayaqApp> createState() => _DayaqAppState();
}

class _DayaqAppState extends State<DayaqApp> {
  late final GoRouter _router = createAppRouter();

  final NotificationService _notificationService = sl<NotificationService>();

  final TokenStorage _tokenStorage = sl<TokenStorage>();

  bool _handlingNotificationTap = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _initializeNotificationNavigation();
    });
  }

  Future<void> _initializeNotificationNavigation() async {
    try {
      await _notificationService.initializeNotificationTapHandling(
        onNotificationTap: () {
          _handleNotificationTap();
        },
      );

      debugPrint('[FCM] Notification navigation initialized');
    } catch (error, stackTrace) {
      debugPrint('[FCM] Navigation initialization failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> _handleNotificationTap() async {
    if (_handlingNotificationTap) return;

    _handlingNotificationTap = true;

    try {
      final hasToken = await _tokenStorage.hasToken();

      if (!mounted) return;

      final destination = hasToken ? AppRoutes.notifications : AppRoutes.login;

      _router.go(destination);

      debugPrint('[FCM] Notification opened');
    } catch (error, stackTrace) {
      debugPrint('[FCM] Notification navigation failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      _handlingNotificationTap = false;
    }
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Dayaq',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          routerConfig: _router,
        );
      },
    );
  }
}
