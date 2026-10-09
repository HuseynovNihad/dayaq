import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_shell.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/campaigns/presentation/pages/campaigns_page.dart';
import '../../features/donations/presentation/pages/donations_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../widgets/app_button.dart';
import '../widgets/app_empty_state.dart';
import 'app_routes.dart';

GoRouter createAppRouter({String initialLocation = AppRoutes.home}) => GoRouter(
  initialLocation: initialLocation,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (_, state) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.campaigns,
              builder: (_, state) => const CampaignsPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.donations,
              builder: (_, state) => const DonationsPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (_, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(path: AppRoutes.login, builder: (_, state) => const LoginPage()),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: SafeArea(
      child: AppEmptyState(
        title: 'Səhifə tapılmadı',
        message: 'Ana səhifəyə qayıda bilərsiniz.',
        action: AppButton(
          label: 'Ana səhifəyə qayıt',
          onPressed: () => context.go(AppRoutes.home),
        ),
      ),
    ),
  ),
);
