import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/family_entity.dart';
import '../details_bloc/family_details_bloc.dart';
import '../details_bloc/family_details_event.dart';
import '../details_bloc/family_details_state.dart';
import '../widgets/details/family_details_header.dart';
import '../widgets/details/family_details_tabs.dart';
import '../widgets/details/family_overview_tab.dart';
import '../widgets/details/family_members_tab.dart';
import '../widgets/details/family_finance_tab.dart';
import '../widgets/details/family_documents_tab.dart';

class FamilyDetailsPage extends StatelessWidget {
  const FamilyDetailsPage({super.key, required this.family});

  final FamilyEntity family;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FamilyDetailsBloc>(
      create: (_) =>
          sl<FamilyDetailsBloc>()..add(FamilyDetailsStarted(family.id)),
      child: _FamilyDetailsView(family: family),
    );
  }
}

class _FamilyDetailsView extends StatefulWidget {
  const _FamilyDetailsView({required this.family});

  final FamilyEntity family;

  @override
  State<_FamilyDetailsView> createState() => _FamilyDetailsViewState();
}

class _FamilyDetailsViewState extends State<_FamilyDetailsView> {
  int _selectedTab = 0;

  Future<void> _refresh() async {
    final bloc = context.read<FamilyDetailsBloc>();

    if (bloc.state is! FamilyDetailsLoaded &&
        bloc.state is! FamilyDetailsError) {
      return;
    }

    final completion = bloc.stream.firstWhere(
      (state) =>
          state is FamilyDetailsError ||
          (state is FamilyDetailsLoaded && !state.isRefreshing),
    );

    bloc.add(const FamilyDetailsRefreshed());
    await completion;
  }

  void _onTabChanged(int index) {
    if (index == _selectedTab) return;

    setState(() {
      _selectedTab = index;
    });
  }

  void _retry() {
    context.read<FamilyDetailsBloc>().add(
      FamilyDetailsStarted(widget.family.id),
    );
  }

  Widget _buildSelectedTab(FamilyDetailsLoaded state) {
    final details = state.details;

    switch (_selectedTab) {
      case 0:
        return FamilyOverviewTab(family: widget.family, details: details);
      case 1:
        return FamilyMembersTab(details: details);
      case 2:
        return FamilyFinanceTab(details: details);
      case 3:
        return FamilyDocumentsTab(details: details);
      default:
        return FamilyOverviewTab(family: widget.family, details: details);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        toolbarHeight: 64.h,
        automaticallyImplyLeading: false,
        leading: IconButton(
          tooltip: 'Geri qayıt',
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
            size: 23.r,
          ),
        ),
        title: Text(
          'Ailə Məlumatları',
          style: context.textTheme.titleLarge?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Əlavə seçimlər',
            onSelected: (value) {
              if (value == 'refresh') {
                context.read<FamilyDetailsBloc>().add(
                  const FamilyDetailsRefreshed(),
                );
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem<String>(
                value: 'refresh',
                child: Row(
                  children: [
                    Icon(Icons.refresh_rounded, size: 20),
                    SizedBox(width: 10),
                    Text('Məlumatları yenilə'),
                  ],
                ),
              ),
            ],
            icon: Icon(Icons.more_vert_rounded, color: AppColors.textPrimary),
          ),
          SizedBox(width: 8.w),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.h),
          child: Container(height: 1.h, color: const Color(0xFFECECEC)),
        ),
      ),
      body: BlocBuilder<FamilyDetailsBloc, FamilyDetailsState>(
        builder: (context, state) {
          final details = state is FamilyDetailsLoaded ? state.details : null;

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: _refresh,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 30.h),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      FamilyDetailsHeader(
                        family: widget.family,
                        showActions: _selectedTab == 0,
                        details: details,
                      ),
                      SizedBox(height: 16.h),
                      FamilyDetailsTabs(
                        selectedIndex: _selectedTab,
                        memberCount: details?.members.length,
                        documentCount: details?.documents.length,
                        onChanged: _onTabChanged,
                      ),
                      SizedBox(height: 18.h),
                      if (state is FamilyDetailsLoading ||
                          state is FamilyDetailsInitial) ...[
                        SizedBox(height: 100.h),
                        const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      ] else if (state is FamilyDetailsError) ...[
                        _DetailsError(message: state.message, onRetry: _retry),
                      ] else if (state is FamilyDetailsLoaded) ...[
                        if (state.isRefreshing)
                          Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: LinearProgressIndicator(
                              minHeight: 2.h,
                              color: AppColors.primary,
                            ),
                          ),
                        _buildSelectedTab(state),
                      ],
                    ]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DetailsError extends StatelessWidget {
  const _DetailsError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 70.h),
      child: Column(
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 48.r,
            color: const Color(0xFFD35A51),
          ),
          SizedBox(height: 14.h),
          Text(
            'Ailə məlumatları yüklənmədi',
            textAlign: TextAlign.center,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF777777),
            ),
          ),
          SizedBox(height: 14.h),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Yenidən cəhd et'),
          ),
        ],
      ),
    );
  }
}
