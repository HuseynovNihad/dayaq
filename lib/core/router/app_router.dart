import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_shell.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/campaigns/presentation/pages/campaigns_page.dart';
import '../../features/donations/presentation/pages/donations_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/map/presentation/pages/map_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/families/domain/entities/family_entity.dart';

import '../widgets/app_button.dart';
import '../widgets/app_empty_state.dart';
import 'app_routes.dart';

GoRouter createAppRouter({String? initialLocation}) {
  final rootNavigatorKey = GlobalKey<NavigatorState>();

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: initialLocation ?? AppRoutes.login,
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),

      GoRoute(
        path: AppRoutes.map,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final families = state.extra;

          return MapPage(
            families: families is List<FamilyEntity>
                ? families
                : const <FamilyEntity>[],
          );
        },
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.campaigns,
                builder: (context, state) => const CampaignsPage(),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.donations,
                builder: (context, state) => const DonationsPage(),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) {
      return Scaffold(
        body: SafeArea(
          child: AppEmptyState(
            title: 'Səhifə tapılmadı',
            message: 'Giriş səhifəsinə qayıda bilərsiniz.',
            action: AppButton(
              label: 'Giriş səhifəsinə qayıt',
              onPressed: () => context.go(AppRoutes.login),
            ),
          ),
        ),
      );
    },
  );
}
