import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_alert_dialog.dart';
import '../../../families/data/local/registration_draft_storage.dart';

class HomeRegistrationDraftsSection extends StatefulWidget {
  const HomeRegistrationDraftsSection({super.key});

  @override
  State<HomeRegistrationDraftsSection> createState() =>
      _HomeRegistrationDraftsSectionState();
}

class _HomeRegistrationDraftsSectionState
    extends State<HomeRegistrationDraftsSection> {
  List<Map<String, dynamic>> _drafts = const [];
  bool _loading = true;
  String? _error;
  GoRouter? _router;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final router = GoRouter.of(context);
    if (!identical(router, _router)) {
      _router?.routerDelegate.removeListener(_routeChanged);
      _router = router;
      _router!.routerDelegate.addListener(_routeChanged);
    }
  }

  void _routeChanged() {
    if (!mounted) return;
    final current = _router?.routeInformationProvider.value.uri.path;
    if (current == AppRoutes.home) _load();
  }

  Future<String?> _owner() async {
    final storage = sl<TokenStorage>();
    if (!await storage.hasToken()) return null;
    final email = (await storage.getEmail())?.trim().toLowerCase();
    return email == null || email.isEmpty ? null : email;
  }

  Future<void> _load() async {
    try {
      final owner = await _owner();
      final items = owner == null
          ? <Map<String, dynamic>>[]
          : await RegistrationDraftStorage.load(owner);
      if (!mounted) return;
      items.sort(
        (a, b) => (b['updatedAt']?.toString() ?? '').compareTo(
          a['updatedAt']?.toString() ?? '',
        ),
      );
      setState(() {
        _drafts = items;
        _loading = false;
        _error = null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Qaralamaları yükləmək mümkün olmadı.';
      });
    }
  }

  Future<void> _delete(Map<String, dynamic> draft) async {
    final name = [
      draft['firstName']?.toString() ?? '',
      draft['lastName']?.toString() ?? '',
    ].where((value) => value.trim().isNotEmpty).join(' ');

    final confirmed = await AppAlertDialog.showConfirmation(
      context: context,
      title: 'Qaralamanı sil?',
      message: name.isNotEmpty
          ? '$name üçün yadda saxlanılmış forma və onun məlumatları '
                'silinəcək. Bu əməliyyatı geri qaytarmaq mümkün deyil.'
          : 'Yadda saxlanılmış forma və onun məlumatları silinəcək. '
                'Bu əməliyyatı geri qaytarmaq mümkün deyil.',
      confirmLabel: 'Bəli, sil',
      cancelLabel: 'Geri qayıt',
      isDestructive: true,
    );

    if (!confirmed || !mounted) return;

    try {
      final owner = await _owner();
      if (!mounted) return;

      if (owner == null) {
        AppAlertDialog.showError(
          context: context,
          message: 'İstifadəçi məlumatları tapılmadı.',
        );
        return;
      }

      final draftId = draft['id']?.toString();

      if (draftId == null || draftId.isEmpty) return;

      await RegistrationDraftStorage.delete(owner, draftId);

      if (!mounted) return;

      await _load();
    } catch (_) {
      if (!mounted) return;

      AppAlertDialog.showError(
        context: context,
        title: 'Silinmə xətası',
        message: 'Qaralamanı silmək mümkün olmadı. Yenidən cəhd edin.',
      );
    }
  }

  static const _steps = <String>[
    'Şəxsi məlumatlar',
    'Ünvan məlumatları',
    'Ailə üzvləri',
    'Gəlir məlumatları',
    'Xərclər',
    'Sənədlər və qeydlər',
    'Yekun baxış',
  ];

  @override
  void dispose() {
    _router?.routerDelegate.removeListener(_routeChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const SizedBox.shrink();
    if (_error != null) {
      return TextButton.icon(
        onPressed: _load,
        icon: const Icon(Icons.refresh),
        label: Text(_error!),
      );
    }
    if (_drafts.isEmpty) return const SizedBox.shrink();
    final tablet = MediaQuery.sizeOf(context).shortestSide >= 600;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Tamamlanmayan formalar (${_drafts.length})',
                style: context.textTheme.titleMedium?.copyWith(
                  fontSize: tablet ? 22 : null,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._drafts.map((draft) {
          final name = [
            draft['firstName']?.toString() ?? '',
            draft['lastName']?.toString() ?? '',
          ].where((s) => s.trim().isNotEmpty).join(' ');
          final step = ((draft['step'] as num?)?.toInt() ?? 1).clamp(1, 7);
          final updated = DateTime.tryParse(
            draft['updatedAt']?.toString() ?? '',
          );
          final date = updated == null
              ? ''
              : DateFormat('dd.MM.yyyy HH:mm').format(updated);
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE8E0D7)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name.isEmpty ? 'Adsız qaralama' : name,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontSize: tablet ? 18 : null,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Qaralamanı sil',
                        onPressed: () => _delete(draft),
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          color: Color(0xFFCD4545),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Addım $step/7 — ${_steps[step - 1]}',
                    style: context.textTheme.titleSmall?.copyWith(
                      fontSize: tablet ? 16 : null,
                      color: Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      minHeight: 6,
                      value: step / 7,
                      backgroundColor: const Color(0xFFEFECE6),
                      color: const Color(0xFFF4B033),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          date.isEmpty ? '' : 'Saxlanılıb: $date',
                          style: context.textTheme.bodySmall?.copyWith(
                            fontSize: tablet ? 14 : null,
                            color: Color(0xFF888888),
                          ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () async {
                          final id = draft['id']?.toString();
                          if (id == null || id.isEmpty) return;
                          await context.push(
                            Uri(
                              path: AppRoutes.familyRegistration,
                              queryParameters: {'draftId': id},
                            ).toString(),
                          );
                          if (mounted) await _load();
                        },
                        icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                        label: const Text('Davam et'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
