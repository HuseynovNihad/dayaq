import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';

import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

import '../widgets/home_header.dart';
import '../widgets/home_welcome_banner.dart';
import '../widgets/home_add_family_button.dart';
import '../widgets/home_statistics_section.dart';
import '../widgets/home_recent_families_section.dart';
import '../widgets/home_nearby_registrations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeBloc>()..add(const HomeStarted()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final isTablet = constraints.maxWidth >= 700;
                final useTwoColumns = constraints.maxWidth >= 900;
                final horizontalPadding = isTablet ? 32.0 : AppSpacing.page;

                return RefreshIndicator(
                  onRefresh: () async {
                    final bloc = context.read<HomeBloc>();
                    bloc.add(const HomeRefreshed());
                    await bloc.stream.firstWhere(
                      (next) => next is HomeLoaded || next is HomeError,
                    );
                  },
                  child: CustomScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: isTablet ? 28 : 20,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 1280),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  HomeHeader(
                                    onNotificationTap: () =>
                                        context.push(AppRoutes.notifications),
                                  ),
                                  SizedBox(height: isTablet ? 28 : 24),
                                  const HomeWelcomeBanner(),
                                  SizedBox(height: isTablet ? 24 : 20),
                                  HomeAddFamilyButton(
                                    onPressed: () => context.go(
                                      AppRoutes.familyRegistration,
                                    ),
                                  ),
                                  SizedBox(height: isTablet ? 32 : 28),
                                  if (state is HomeLoaded) ...[
                                    HomeStatisticsSection(
                                      totalFamilies: state.totalFamilies,
                                      monthlyRegistrations:
                                          state.monthlyRegistrations,
                                    ),
                                    SizedBox(height: isTablet ? 32 : 28),
                                    if (useTwoColumns)
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: HomeRecentFamiliesSection(
                                              families: state.recentFamilies,
                                              onSeeAllTap: () {
                                                context.go(AppRoutes.families);
                                              },
                                              onFamilyTap: (family) {
                                                // TODO: Ailə detalları, family.id.
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 24),
                                          Expanded(
                                            child: HomeNearbyRegistrations(
                                              families: state.families,
                                              onOpenMap: () => context.push(
                                                AppRoutes.map,
                                                extra: state.families,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    else ...[
                                      HomeRecentFamiliesSection(
                                        families: state.recentFamilies,
                                        onSeeAllTap: () =>
                                            context.go(AppRoutes.families),

                                        onFamilyTap: (family) {
                                          // TODO: Ailə detalları, family.id.
                                        },
                                      ),
                                      SizedBox(height: isTablet ? 32 : 28),
                                      HomeNearbyRegistrations(
                                        families: state.families,
                                        onOpenMap: () => context.push(
                                          AppRoutes.map,
                                          extra: state.families,
                                        ),
                                      ),
                                    ],
                                  ],
                                  if (state is HomeInitial ||
                                      state is HomeLoading) ...[
                                    const SizedBox(height: 80),
                                    const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ],
                                  if (state is HomeError) ...[
                                    const SizedBox(height: 48),
                                    Center(
                                      child: Column(
                                        children: [
                                          const Icon(
                                            Icons.error_outline_rounded,
                                            size: 42,
                                            color: Colors.redAccent,
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            state.message,
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 16),
                                          TextButton.icon(
                                            onPressed: () => context
                                                .read<HomeBloc>()
                                                .add(const HomeStarted()),
                                            icon: const Icon(
                                              Icons.refresh_rounded,
                                            ),
                                            label: const Text(
                                              'Yenidən cəhd et',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 32),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
