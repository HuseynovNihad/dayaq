import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_shell.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/families/domain/entities/family_entity.dart';
import '../../features/families/presentation/pages/families_list_page.dart';
import '../../features/families/presentation/pages/family_details_page.dart';
import '../../features/families/presentation/pages/family_registration_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/map/presentation/pages/map_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/about_page.dart';
import '../../features/profile/presentation/pages/term_conditions_page.dart';
import '../../features/profile/presentation/pages/rules_page.dart';

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
        path: AppRoutes.familyRegistration,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const FamilyRegistrationPage(),
      ),
      GoRoute(
        path: AppRoutes.familyDetails,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final family = state.extra;

          if (family is! FamilyEntity) {
            return Scaffold(
              appBar: AppBar(title: const Text('Ailə Məlumatları')),
              body: const Center(
                child: Text('Ailə məlumatlarını açmaq mümkün olmadı.'),
              ),
            );
          }

          return FamilyDetailsPage(family: family);
        },
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
      GoRoute(
        path: AppRoutes.about,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const AboutPage(),
      ),
      GoRoute(
        path: AppRoutes.termConditions,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const TermConditionsPage(),
      ),
      GoRoute(
        path: AppRoutes.rules,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const RulesPage(),
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
                path: AppRoutes.families,
                builder: (context, state) => const FamiliesListPage(),
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
