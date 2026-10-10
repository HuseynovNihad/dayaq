import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            return RefreshIndicator(
              onRefresh: () async {
                final bloc = context.read<HomeBloc>();

                bloc.add(const HomeRefreshed());

                await bloc.stream.firstWhere(
                  (state) => state is HomeLoaded || state is HomeError,
                );
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.page,
                      vertical: 20.h,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        const HomeHeader(),

                        SizedBox(height: 24.h),

                        const HomeWelcomeBanner(),

                        SizedBox(height: 20.h),

                        HomeAddFamilyButton(
                          onPressed: () {
                            // TODO: Yeni ailə qeydiyyatı.
                          },
                        ),

                        SizedBox(height: 28.h),

                        if (state is HomeLoaded) ...[
                          HomeStatisticsSection(
                            totalFamilies: state.totalFamilies,
                            monthlyRegistrations: state.monthlyRegistrations,
                          ),

                          SizedBox(height: 28.h),

                          HomeRecentFamiliesSection(
                            families: state.recentFamilies,
                            onSeeAllTap: () {
                              // TODO: Ailələr səhifəsi.
                            },
                            onFamilyTap: (family) {
                              // TODO: Ailə detalları.
                              // family.id istifadə olunacaq.
                            },
                          ),

                          SizedBox(height: 28.h),

                          HomeNearbyRegistrations(
                            families: state.families,
                            onOpenMap: () {
                              context.push(
                                AppRoutes.map,
                                extra: state.families,
                              );
                            },
                          ),
                        ],

                        if (state is HomeInitial || state is HomeLoading) ...[
                          SizedBox(height: 80.h),

                          const Center(child: CircularProgressIndicator()),
                        ],

                        if (state is HomeError) ...[
                          SizedBox(height: 48.h),

                          Center(
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.error_outline_rounded,
                                  size: 42,
                                  color: Colors.redAccent,
                                ),

                                SizedBox(height: 12.h),

                                Text(
                                  state.message,
                                  textAlign: TextAlign.center,
                                ),

                                SizedBox(height: 16.h),

                                TextButton.icon(
                                  onPressed: () {
                                    context.read<HomeBloc>().add(
                                      const HomeStarted(),
                                    );
                                  },
                                  icon: const Icon(Icons.refresh_rounded),
                                  label: const Text('Yenidən cəhd et'),
                                ),
                              ],
                            ),
                          ),
                        ],

                        SizedBox(height: 32.h),
                      ]),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
