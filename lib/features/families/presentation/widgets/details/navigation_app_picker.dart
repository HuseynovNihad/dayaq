import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/constants/app_assets.dart';

/// Ailənin GPS koordinatlarına əsasən
/// Google Maps və ya Waze seçimini göstərir.
class NavigationAppPicker {
  NavigationAppPicker._();

  static Future<void> show(
    BuildContext context, {
    required double latitude,
    required double longitude,
  }) async {
    // GPS koordinatlarını yoxla.
    if (!latitude.isFinite ||
        !longitude.isFinite ||
        latitude < -90 ||
        latitude > 90 ||
        longitude < -180 ||
        longitude > 180 ||
        (latitude == 0 && longitude == 0)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('GPS koordinatları düzgün deyil.')),
        );
      }
      return;
    }

    final isTablet = MediaQuery.sizeOf(context).shortestSide >= 600;

    // Naviqasiya tətbiqini seçmək üçün BottomSheet.
    final choice = await showModalBottomSheet<_NavigationApp>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              isTablet ? 28 : 16,
              0,
              isTablet ? 28 : 16,
              24,
            ),
            child: Center(
              heightFactor: 1,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 8),
                      child: Text(
                        'Naviqasiya tətbiqini seçin',
                        style: TextStyle(
                          fontFamily: 'NunitoSans',
                          fontSize: isTablet ? 22 : 18,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF202020),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 18),
                      child: Text(
                        'Ailənin yerləşdiyi ünvana getmək '
                        'üçün tətbiq seçin.',
                        style: TextStyle(
                          fontFamily: 'NunitoSans',
                          fontSize: isTablet ? 15 : 13,
                          color: const Color(0xFF777777),
                        ),
                      ),
                    ),

                    // GOOGLE MAPS
                    _NavigationOption(
                      iconPath: AppAssets.googleMaps,
                      title: 'Google Maps',
                      subtitle: 'Google Maps ilə marşrutu aç',
                      isTablet: isTablet,
                      onTap: () => Navigator.pop(
                        sheetContext,
                        _NavigationApp.googleMaps,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // WAZE
                    _NavigationOption(
                      iconPath: AppAssets.waze,
                      title: 'Waze',
                      subtitle: 'Waze ilə marşrutu aç',
                      isTablet: isTablet,
                      onTap: () =>
                          Navigator.pop(sheetContext, _NavigationApp.waze),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    // İstifadəçi pəncərəni bağlayıbsa.
    if (choice == null) return;

    final coords = '$latitude,$longitude';

    final uri = choice == _NavigationApp.googleMaps
        ? Uri.https('www.google.com', '/maps/dir/', {
            'api': '1',
            'destination': coords,
            'travelmode': 'driving',
          })
        : Uri.https('waze.com', '/ul', {'ll': coords, 'navigate': 'yes'});

    // Seçilmiş naviqasiya tətbiqini aç.
    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);

      if (!opened && context.mounted) {
        _showError(context);
      }
    } catch (_) {
      if (context.mounted) {
        _showError(context);
      }
    }
  }

  static void _showError(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Naviqasiyanı açmaq mümkün olmadı.')),
      );
  }
}

/// Google Maps və Waze üçün seçim kartı.
class _NavigationOption extends StatelessWidget {
  const _NavigationOption({
    required this.iconPath,
    required this.title,
    required this.subtitle,
    required this.isTablet,
    required this.onTap,
  });

  final String iconPath;
  final String title;
  final String subtitle;
  final bool isTablet;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFAF9F6),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 20 : 14,
            vertical: isTablet ? 18 : 14,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE8E4DE)),
          ),
          child: Row(
            children: [
              // Rəsmi tətbiq SVG ikonu.
              SizedBox(
                width: isTablet ? 48 : 42,
                height: isTablet ? 48 : 42,
                child: SvgPicture.asset(iconPath, fit: BoxFit.contain),
              ),

              SizedBox(width: isTablet ? 18 : 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'NunitoSans',
                        fontSize: isTablet ? 18 : 16,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF202020),
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: 'NunitoSans',
                        fontSize: isTablet ? 14 : 12,
                        color: const Color(0xFF777777),
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF777777),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _NavigationApp { googleMaps, waze }
