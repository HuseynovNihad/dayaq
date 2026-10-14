import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../list_bloc/families_list_bloc.dart';
import '../list_bloc/families_list_event.dart';
import '../list_bloc/families_list_state.dart';
import '../widgets/family_card.dart';

class FamiliesListPage extends StatelessWidget {
  const FamiliesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FamiliesListBloc>(
      create: (_) => sl<FamiliesListBloc>()..add(const FamiliesListStarted()),
      child: const _FamiliesListView(),
    );
  }
}

class _FamiliesListView extends StatefulWidget {
  const _FamiliesListView();

  @override
  State<_FamiliesListView> createState() => _FamiliesListViewState();
}

class _FamiliesListViewState extends State<_FamiliesListView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    context.read<FamiliesListBloc>().add(FamiliesListSearchChanged(query));
    setState(() {});
  }

  void _onRegionSelected(String? region) {
    FocusScope.of(context).unfocus();
    context.read<FamiliesListBloc>().add(FamiliesListRegionChanged(region));
  }

  void _onSortSelected(FamiliesSort sort) {
    context.read<FamiliesListBloc>().add(FamiliesListSortChanged(sort));
  }

  Future<void> _onRefresh() async {
    final bloc = context.read<FamiliesListBloc>();
    final completion = bloc.stream.firstWhere(
      (state) =>
          state is FamiliesListError ||
          (state is FamiliesListLoaded && !state.isRefreshing),
    );
    bloc.add(const FamiliesListRefreshed());
    await completion;
  }

  String _sortLabel(FamiliesSort sort) {
    return switch (sort) {
      FamiliesSort.newest => 'Ən yeni',
      FamiliesSort.oldest => 'Ən köhnə',
      FamiliesSort.nameAZ => 'Ad A–Z',
      FamiliesSort.nameZA => 'Ad Z–A',
    };
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F7),
      appBar: AppBar(
        toolbarHeight: 74.h,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 20.w,
        title: Row(
          children: [
            Container(
              width: 44.r,
              height: 44.r,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xFFFFEED6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.volunteer_activism_outlined,
                size: 24.r,
                color: const Color(0xFF956409),
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              'Ailələr',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Bildirişlər',
            onPressed: () => context.push(AppRoutes.notifications),
            icon: Icon(
              Icons.notifications_none_rounded,
              size: 26.r,
              color: const Color(0xFF574D3E),
            ),
          ),

          SizedBox(width: 12.w),
        ],
      ),
      body: BlocBuilder<FamiliesListBloc, FamiliesListState>(
        builder: (context, state) {
          return Stack(
            children: [
              RefreshIndicator(
                color: AppColors.primary,
                onRefresh: _onRefresh,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(18.w, 24.h, 18.w, 95.h),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          _buildTitleAndSort(context, textTheme, state),
                          SizedBox(height: 22.h),
                          _buildSearchField(context),
                          SizedBox(height: 20.h),
                          if (state is FamiliesListLoaded) ...[
                            _buildRegionFilters(context, state),
                            SizedBox(height: 20.h),
                            if (state.isRefreshing)
                              Padding(
                                padding: EdgeInsets.only(bottom: 10.h),
                                child: LinearProgressIndicator(
                                  minHeight: 2.h,
                                  color: AppColors.primary,
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                            if (state.filteredFamilies.isEmpty)
                              _buildEmptyState(context, state.hasActiveFilters)
                            else
                              ...state.filteredFamilies.map(
                                (family) => Padding(
                                  padding: EdgeInsets.only(bottom: 14.h),
                                  child: FamilyCard(
                                    family: family,
                                    onTap: () {
                                      context.push(
                                        AppRoutes.familyDetailsPath(family.id),
                                        extra: family,
                                      );
                                    },
                                  ),
                                ),
                              ),
                          ] else if (state is FamiliesListError) ...[
                            _buildErrorState(context, state.message),
                          ] else ...[
                            SizedBox(height: 100.h),
                            const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 12.h,
                right: 18.w,
                child: _buildAddFamilyButton(context),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTitleAndSort(
    BuildContext context,
    TextTheme textTheme,
    FamiliesListState state,
  ) {
    final count = state is FamiliesListLoaded ? state.totalFamilies : null;
    final sort = state is FamiliesListLoaded ? state.sort : FamiliesSort.newest;

    return Row(
      children: [
        Expanded(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 5.w,
            children: [
              Text(
                'Ailələr',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              if (count != null)
                Text(
                  '($count ailə)',
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF665747),
                  ),
                ),
            ],
          ),
        ),
        PopupMenuButton<FamiliesSort>(
          tooltip: 'Sıralama',
          initialValue: sort,
          onSelected: _onSortSelected,
          enabled: state is FamiliesListLoaded,
          color: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          itemBuilder: (context) => FamiliesSort.values.map((item) {
            return PopupMenuItem<FamiliesSort>(
              value: item,
              child: Row(
                children: [
                  if (item == sort) ...[
                    const Icon(
                      Icons.check_rounded,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    _sortLabel(item),
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: item == sort
                          ? FontWeight.w700
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          child: Container(
            height: 46.h,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F4F2),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.swap_vert_rounded,
                  size: 20.r,
                  color: AppColors.textPrimary,
                ),
                SizedBox(width: 5.w),
                Text(
                  'Tarix üzrə',
                  style: textTheme.labelLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField(BuildContext context) {
    final textTheme = context.textTheme;

    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F3F1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        textInputAction: TextInputAction.search,
        style: textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: 'Ad, soyad və ya qeydiyyat nömrəsi',
          hintStyle: textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF918476),
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 24.r,
            color: const Color(0xFF918476),
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  tooltip: 'Axtarışı təmizlə',
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged('');
                  },
                  icon: Icon(
                    Icons.close_rounded,
                    size: 20.r,
                    color: const Color(0xFF918476),
                  ),
                )
              : Icon(
                  Icons.manage_search_rounded,
                  size: 22.r,
                  color: const Color(0xFF918476),
                ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 17.h),
        ),
      ),
    );
  }

  Widget _buildRegionFilters(BuildContext context, FamiliesListLoaded state) {
    return SizedBox(
      height: 46.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip(
            context: context,
            label: 'Hamısı (${state.totalFamilies})',
            selected: state.selectedRegion == null,
            onTap: () => _onRegionSelected(null),
          ),
          ...state.regions.map(
            (region) => _buildFilterChip(
              context: context,
              label: region,
              selected: state.selectedRegion == region,
              onTap: () => _onRegionSelected(region),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required BuildContext context,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final textTheme = context.textTheme;

    return Padding(
      padding: EdgeInsets.only(right: 7.w),
      child: Material(
        color: selected ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28.r),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 17.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28.r),
              border: selected
                  ? null
                  : Border.all(color: const Color(0xFFF2F0EC)),
            ),
            child: Text(
              label,
              style: textTheme.labelLarge?.copyWith(
                color: selected
                    ? const Color(0xFF251C10)
                    : const Color(0xFF5C5144),
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool hasFilters) {
    final textTheme = context.textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 84.h),
      child: Column(
        children: [
          Icon(
            hasFilters
                ? Icons.search_off_rounded
                : Icons.family_restroom_rounded,
            size: 56.r,
            color: const Color(0xFFB8AC9B),
          ),
          SizedBox(height: 16.h),
          Text(
            hasFilters
                ? 'Axtarışa uyğun ailə tapılmadı'
                : 'Hələ ailə qeydiyyatı yoxdur',
            textAlign: TextAlign.center,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            hasFilters
                ? 'Axtarış sözünü və ya region filtrini dəyişin.'
                : 'Yeni ailə əlavə edərək başlaya bilərsiniz.',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final textTheme = context.textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 80.h),
      child: Column(
        children: [
          Container(
            width: 70.r,
            height: 70.r,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFFCEDEB),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline_rounded,
              color: const Color(0xFFBD5B52),
              size: 34.r,
            ),
          ),
          SizedBox(height: 18.h),
          Text(
            'Ailələr yüklənmədi',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 18.h),
          TextButton.icon(
            onPressed: () {
              context.read<FamiliesListBloc>().add(const FamiliesListStarted());
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Yenidən cəhd et'),
          ),
        ],
      ),
    );
  }

  Widget _buildAddFamilyButton(BuildContext context) {
    final textTheme = context.textTheme;

    return Material(
      color: AppColors.primary,
      elevation: 3,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: () => context.go(AppRoutes.familyRegistration),
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          height: 50.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_add_alt_1_rounded,
                size: 19.r,
                color: const Color(0xFF251C10),
              ),
              SizedBox(width: 8.w),
              Text(
                'Yeni ailə əlavə et',
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF251C10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
