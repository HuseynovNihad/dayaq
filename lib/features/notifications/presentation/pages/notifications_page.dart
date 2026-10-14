import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/notification_bloc.dart';
import '../widgets/notification_card.dart';
import '../widgets/notifications_empty_state.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NotificationBloc>()..add(const NotificationsStarted()),
      child: const _NotificationsView(),
    );
  }
}

class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  Future<void> _refresh(BuildContext context) async {
    final bloc = context.read<NotificationBloc>();

    if (bloc.state is NotificationLoading) return;
    if (bloc.state is NotificationLoaded &&
        (bloc.state as NotificationLoaded).isRefreshing) {
      return;
    }

    final completion = bloc.stream.firstWhere(
      (state) =>
          state is NotificationError ||
          (state is NotificationLoaded && !state.isRefreshing),
    );

    bloc.add(const NotificationsRefreshed());
    await completion;
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.sizeOf(context).shortestSide >= 600;
    final horizontalPadding = isTablet ? 28.0 : 20.0;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        toolbarHeight: isTablet ? 72 : 56,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          tooltip: 'Geri qayıt',
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.home);
            }
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: isTablet ? 24 : 20,
            color: AppColors.textPrimary,
          ),
        ),
        title: Text(
          'Bildirişlər',
          style: context.textTheme.titleLarge?.copyWith(
            fontSize: isTablet ? 24 : null,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFECECEC)),
        ),
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationInitial || state is NotificationLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is NotificationError) {
            return _NotificationsError(
              message: state.message,
              onRetry: () {
                context.read<NotificationBloc>().add(
                  const NotificationsStarted(),
                );
              },
            );
          }

          if (state is NotificationLoaded) {
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () => _refresh(context),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  if (state.isRefreshing)
                    const SliverToBoxAdapter(
                      child: LinearProgressIndicator(
                        color: AppColors.primary,
                        minHeight: 2,
                      ),
                    ),
                  if (state.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: NotificationsEmptyState(),
                    )
                  else
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: isTablet ? 28 : 22,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 850),
                            child: Column(
                              children: [
                                for (final notification in state.notifications)
                                  Padding(
                                    padding: EdgeInsets.only(
                                      bottom: isTablet ? 16 : 12,
                                    ),
                                    child: NotificationCard(
                                      notification: notification,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _NotificationsError extends StatelessWidget {
  const _NotificationsError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.sizeOf(context).shortestSide >= 600;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isTablet ? 32 : 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: isTablet ? 88 : 70,
                height: isTablet ? 88 : 70,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFEEEE),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_off_outlined,
                  size: isTablet ? 42 : 32,
                  color: const Color(0xFFD94B4B),
                ),
              ),
              SizedBox(height: isTablet ? 22 : 18),
              Text(
                'Bildirişləri yükləmək mümkün olmadı',
                textAlign: TextAlign.center,
                style: context.textTheme.titleMedium?.copyWith(
                  fontSize: isTablet ? 21 : null,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontSize: isTablet ? 16 : null,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              SizedBox(height: isTablet ? 24 : 20),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: Icon(Icons.refresh_rounded, size: isTablet ? 22 : 20),
                label: const Text('Yenidən cəhd et'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  minimumSize: Size(0, isTablet ? 54 : 46),
                  textStyle: TextStyle(fontSize: isTablet ? 16 : 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
