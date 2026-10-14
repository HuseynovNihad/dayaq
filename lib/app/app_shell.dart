import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../core/di/injection.dart';
import '../core/extensions/context_extensions.dart';
import '../core/services/notification_service.dart';
import '../core/storage/token_storage.dart';
import '../core/theme/app_colors.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final NotificationService _notificationService = sl<NotificationService>();
  final TokenStorage _tokenStorage = sl<TokenStorage>();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    try {
      final hasToken = await _tokenStorage.hasToken();

      if (!mounted || !hasToken) return;

      // Initialize local notifications for foreground messages.
      await _notificationService.initializeLocalNotifications();

      if (!mounted) return;

      // Request notification permission.
      final settings = await _notificationService.requestPermission();

      if (!mounted) return;

      debugPrint('[FCM] Permission status: ${settings.authorizationStatus}');

      // Listen for FCM token changes.
      _notificationService.listenToTokenRefresh((token) {
        debugPrint('[FCM] Token refreshed');

        // TODO: Synchronize refreshed token with backend.
      });

      // Listen for foreground FCM messages.
      _notificationService.listenToForegroundMessages((message) {
        if (!mounted) return;

        debugPrint('[FCM] Foreground message received: ${message.messageId}');

        // Android foreground notification is displayed
        // by NotificationService.
      });

      debugPrint('[FCM] Notification listeners initialized');
    } catch (error, stackTrace) {
      debugPrint('[FCM] Initialization failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          height: 72.h,
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFFFFEDD0),
          surfaceTintColor: Colors.white,
          elevation: 0,
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            final isSelected = states.contains(WidgetState.selected);

            return textTheme.bodySmall?.copyWith(
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? const Color(0xFF906000)
                  : const Color(0xFF62594C),
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            final isSelected = states.contains(WidgetState.selected);

            return IconThemeData(
              size: 24.r,
              color: isSelected ? AppColors.primary : const Color(0xFF62594C),
            );
          }),
        ),
        child: NavigationBar(
          selectedIndex: widget.navigationShell.currentIndex,
          onDestinationSelected: (index) {
            widget.navigationShell.goBranch(
              index,
              initialLocation: index == widget.navigationShell.currentIndex,
            );
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Ana səhifə',
            ),
            NavigationDestination(
              icon: Icon(Icons.groups_outlined),
              selectedIcon: Icon(Icons.groups_rounded),
              label: 'Ailələr',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
