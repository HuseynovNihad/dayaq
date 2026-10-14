import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/profile_content_bloc.dart';
import '../bloc/profile_content_event.dart';
import '../bloc/profile_content_state.dart';
import 'profile_content_card.dart';

class ProfileContentView extends StatelessWidget {
  const ProfileContentView({
    super.key,
    required this.title,
    required this.type,
    required this.icon,
    required this.description,
  });

  final String title;
  final ProfileContentType type;
  final IconData icon;
  final String description;

  Future<void> _refresh(BuildContext context) async {
    final bloc = context.read<ProfileContentBloc>();

    if (bloc.state is ProfileContentLoading) return;

    final completion = bloc.stream.firstWhere((state) {
      return state is ProfileContentError ||
          (state is ProfileContentLoaded && !state.isRefreshing);
    });

    bloc.add(const ProfileContentRefreshed());
    await completion;
  }

  Future<void> _openVideo(BuildContext context, String value) async {
    final uri = Uri.tryParse(value.trim());

    if (uri == null ||
        (uri.scheme != 'https' && uri.scheme != 'http') ||
        uri.host.isEmpty) {
      _showMessage(context, 'Video keçidi düzgün deyil.');
      return;
    }

    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);

      if (!opened && context.mounted) {
        _showMessage(context, 'Videonu açmaq mümkün olmadı.');
      }
    } catch (_) {
      if (context.mounted) {
        _showMessage(context, 'Videonu açmaq mümkün olmadı.');
      }
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildContent(BuildContext context, ProfileContentLoaded state) {
    final isTablet = MediaQuery.sizeOf(context).shortestSide >= 600;
    final contents = switch (type) {
      ProfileContentType.about => state.about.map((e) => e.about).toList(),
      ProfileContentType.termConditions =>
        state.termConditions.map((e) => e.termCondition).toList(),
      ProfileContentType.rules => state.rules.map((e) => e.rule).toList(),
    };

    final texts = contents
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final videos = type == ProfileContentType.rules
        ? state.rules
              .map((e) => e.video?.trim())
              .whereType<String>()
              .where((e) => e.isNotEmpty)
              .toSet()
              .toList()
        : <String>[];

    if (texts.isEmpty && videos.isEmpty) {
      return const _ProfileContentEmpty();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final content in texts) ...[
          ProfileContentCard(content: content),
          SizedBox(height: isTablet ? 16 : 12.h),
        ],
        for (final video in videos) ...[
          Material(
            color: const Color(0xFFFFF7E6),
            borderRadius: BorderRadius.circular(isTablet ? 18 : 16.r),
            child: InkWell(
              onTap: () => _openVideo(context, video),
              borderRadius: BorderRadius.circular(isTablet ? 18 : 16.r),
              child: Padding(
                padding: EdgeInsets.all(isTablet ? 20 : 16.r),
                child: Row(
                  children: [
                    Container(
                      width: isTablet ? 54 : 45.r,
                      height: isTablet ? 54 : 45.r,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(isTablet ? 14 : 12.r),
                      ),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: isTablet ? 30 : 28.r,
                      ),
                    ),
                    SizedBox(width: isTablet ? 16 : 12.w),
                    Expanded(
                      child: Text(
                        'Təlimat videosuna bax',
                        style: context.textTheme.titleSmall?.copyWith(
                           fontSize: isTablet ? 17 : null,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.open_in_new_rounded,
                      size: isTablet ? 24 : 20.r,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: isTablet ? 16 : 12.h),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.sizeOf(context).shortestSide >= 600;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          title,
          style: context.textTheme.titleMedium?.copyWith(
             fontSize: isTablet ? 20 : null,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFECECEC)),
        ),
      ),
      body: BlocBuilder<ProfileContentBloc, ProfileContentState>(
        builder: (context, state) {
          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () => _refresh(context),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 850),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    isTablet ? 30 : 20.w,
                    isTablet ? 30 : 22.h,
                    isTablet ? 30 : 20.w,
                    isTablet ? 40 : 30.h,
                  ),
                  children: [
                Container(
                  width: isTablet ? 64 : 54.r,
                  height: isTablet ? 64 : 54.r,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF2D6),
                    borderRadius: BorderRadius.circular(isTablet ? 18 : 16.r),
                  ),
                  child: Icon(icon, size: isTablet ? 32 : 27.r, color: const Color(0xFFD99613)),
                ),
                SizedBox(height: isTablet ? 20 : 14.h),
                Text(
                  title,
                  style: context.textTheme.headlineSmall?.copyWith(
                     fontSize: isTablet ? 28 : null,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: isTablet ? 10 : 7.h),
                Text(
                  description,
                  style: context.textTheme.bodyMedium?.copyWith(
                     fontSize: isTablet ? 16 : null,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: isTablet ? 30 : 24.h),
                if (state is ProfileContentLoading ||
                    state is ProfileContentInitial)
                  Padding(
                    padding: EdgeInsets.only(top: 65.h),
                    child: const Center(child: CircularProgressIndicator()),
                  )
                else if (state is ProfileContentError)
                  _ProfileContentError(
                    message: state.message,
                    onRetry: () {
                      context.read<ProfileContentBloc>().add(
                        ProfileContentRequested(type),
                      );
                    },
                  )
                else if (state is ProfileContentLoaded) ...[
                  if (state.isRefreshing) ...[
                    const LinearProgressIndicator(),
                    SizedBox(height: isTablet ? 20 : 14.h),
                  ],
                  _buildContent(context, state),
                ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProfileContentEmpty extends StatelessWidget {
  const _ProfileContentEmpty();

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.sizeOf(context).shortestSide >= 600;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: isTablet ? 56 : 45.h),
      child: Column(
        children: [
          Icon(
            Icons.article_outlined,
            size: isTablet ? 48 : 42.r,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: isTablet ? 16 : 12.h),
          Text(
            'Hələ məlumat əlavə edilməyib.',
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileContentError extends StatelessWidget {
  const _ProfileContentError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.sizeOf(context).shortestSide >= 600;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: isTablet ? 48 : 36.h),
      child: Column(
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: isTablet ? 50 : 45.r,
            color: const Color(0xFFD94A4A),
          ),
          SizedBox(height: isTablet ? 16 : 12.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 16.h),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Yenidən cəhd et'),
          ),
        ],
      ),
    );
  }
}
