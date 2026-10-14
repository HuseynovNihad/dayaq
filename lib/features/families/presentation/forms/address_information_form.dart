import '../registration_responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_dropdown_field.dart';

class AddressInformationForm extends StatefulWidget {
  const AddressInformationForm({
    super.key,
    required this.formKey,
    required this.regionId,
    required this.onRegionChanged,
    required this.addressController,
    required this.position,
    required this.onPositionChanged,
  });

  final GlobalKey<FormState> formKey;
  final int? regionId;
  final ValueChanged<int?> onRegionChanged;
  final TextEditingController addressController;
  final Position? position;
  final ValueChanged<Position?> onPositionChanged;

  @override
  State<AddressInformationForm> createState() => _AddressInformationFormState();
}

class _AddressInformationFormState extends State<AddressInformationForm> {
  static const String _appPackageName = 'az.dayaq.mobile';

  static const String _mapTilerApiKey = String.fromEnvironment(
    'MAPTILER_API_KEY',
  );

  bool _isLoading = false;
  String? _locationError;

  @override
  void initState() {
    super.initState();

    if (widget.position == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _getCurrentLocation();
        }
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _locationError = null;
    });

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        throw const _LocationException(
          'Telefonun məkan xidmətləri deaktivdir. '
          'GPS-i aktiv edib yenidən yoxlayın.',
        );
      }

      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        throw const _LocationException(
          'Məkan icazəsi verilmədi. '
          'Koordinatları almaq üçün icazə verin.',
        );
      }

      if (permission == LocationPermission.deniedForever) {
        throw const _LocationException(
          'Məkan icazəsi bloklanıb. '
          'Tətbiq ayarlarından icazəni aktiv edin.',
        );
      }

      final currentPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );

      if (!mounted) return;

      widget.onPositionChanged(currentPosition);
    } on _LocationException catch (error) {
      if (!mounted) return;

      setState(() {
        _locationError = error.message;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _locationError =
            'Cari GPS koordinatlarını almaq mümkün olmadı. '
            'Məkan icazəsini yoxlayıb yenidən cəhd edin.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _openLocationSettings() async {
    final permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
    } else {
      await Geolocator.openLocationSettings();
    }
  }

  Widget _buildEmptyLocationCard() {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: context.registrationIsTablet ? 300 : 220.regH(context),
      ),
      padding: EdgeInsets.all(20.regR(context)),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F1EA),
        borderRadius: BorderRadius.circular(18.regR(context)),
        border: Border.all(color: const Color(0xFFF4F1ED)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isLoading)
            SizedBox(
              width: 32.regR(context),
              height: 32.regR(context),
              child: const CircularProgressIndicator(color: AppColors.primary),
            )
          else
            Icon(
              Icons.location_off_outlined,
              size: 38.regR(context),
              color: AppColors.textSecondary,
            ),

          SizedBox(height: 12.regH(context)),

          Text(
            _isLoading
                ? 'Cari GPS koordinatları alınır...'
                : _locationError ?? 'Cari GPS koordinatları hələ alınmayıb.',
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          if (!_isLoading) ...[
            SizedBox(height: 16.regH(context)),

            FilledButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.my_location_rounded),
              label: const Text('GPS-i yoxla'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.black,
              ),
            ),

            if (_locationError != null) ...[
              SizedBox(height: 8.regH(context)),
              TextButton(
                onPressed: _openLocationSettings,
                child: const Text('Məkan ayarlarını aç'),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildLocationCard() {
    final position = widget.position;

    if (position == null) {
      return _buildEmptyLocationCard();
    }

    return _buildMap(position);
  }

  Widget _buildMap(Position position) {
    final currentPoint = LatLng(position.latitude, position.longitude);

    final hasMapTilerKey = _mapTilerApiKey.trim().isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(18.regR(context)),
      child: SizedBox(
        height: context.registrationIsTablet ? 340 : 270.regH(context),
        child: Stack(
          children: [
            Positioned.fill(
              child: hasMapTilerKey
                  ? IgnorePointer(
                      child: FlutterMap(
                        key: ValueKey(
                          '${position.latitude}_${position.longitude}',
                        ),
                        options: MapOptions(
                          initialCenter: currentPoint,
                          initialZoom: 16,
                          interactionOptions: const InteractionOptions(
                            flags: InteractiveFlag.none,
                          ),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://api.maptiler.com/maps/'
                                'streets-v4/256/'
                                '{z}/{x}/{y}.png'
                                '?key=$_mapTilerApiKey',
                            userAgentPackageName: _appPackageName,
                            maxNativeZoom: 19,
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: currentPoint,
                                width: 54.regR(context),
                                height: 54.regR(context),
                                child: Icon(
                                  Icons.location_pin,
                                  size: 48.regR(context),
                                  color: AppColors.primary,
                                  shadows: const [
                                    Shadow(
                                      color: Colors.black26,
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : Container(
                      color: const Color(0xFFF3F1EA),
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(20.regR(context)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.map_outlined,
                            size: 38.regR(context),
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(height: 10.regH(context)),
                          Text(
                            'Xəritə API açarı təyin edilməyib.',
                            textAlign: TextAlign.center,
                            style: context.textTheme.bodyMedium,
                          ),
                          SizedBox(height: 6.regH(context)),
                          Text(
                            'Tətbiqi MAPTILER_API_KEY ilə başladın.',
                            textAlign: TextAlign.center,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),

            // Xəritə məlumat mənbəyi
            if (hasMapTilerKey)
              Positioned(
                top: 8.regH(context),
                right: 8.regW(context),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.regW(context),
                    vertical: 5.regH(context),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.93),
                    borderRadius: BorderRadius.circular(8.regR(context)),
                  ),
                  child: Text(
                    '© MapTiler © OpenStreetMap contributors',
                    style: TextStyle(
                      fontSize: 9.regSp(context),
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),

            // GPS koordinatları
            Positioned(
              left: 12.regW(context),
              right: 12.regW(context),
              bottom: 12.regH(context),
              child: Container(
                padding: EdgeInsets.all(12.regR(context)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14.regR(context)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 12.regR(context),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cari GPS mövqeyi',
                            style: context.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),

                          SizedBox(height: 4.regH(context)),

                          Text(
                            '${position.latitude.toStringAsFixed(6)}, '
                            '${position.longitude.toStringAsFixed(6)}',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),

                          SizedBox(height: 3.regH(context)),

                          Text(
                            'Dəqiqlik: təxminən '
                            '${position.accuracy.toStringAsFixed(0)} m',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 8.regW(context)),

                    IconButton.filledTonal(
                      tooltip: 'Koordinatları yenilə',
                      onPressed: _isLoading ? null : _getCurrentLocation,
                      icon: _isLoading
                          ? SizedBox(
                              width: 18.regR(context),
                              height: 18.regR(context),
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.refresh_rounded),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ünvan məlumatları kartı
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.regR(context)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.regR(context)),
              border: Border.all(color: const Color(0xFFF4F1ED)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48.regR(context),
                  height: 48.regR(context),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0D1),
                    borderRadius: BorderRadius.circular(14.regR(context)),
                  ),
                  child: Icon(
                    Icons.map_outlined,
                    color: AppColors.primary,
                    size: 27.regR(context),
                  ),
                ),

                SizedBox(width: 12.regW(context)),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ünvan məlumatları',
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      SizedBox(height: 5.regH(context)),

                      Text(
                        'Ailənin yaşayış ünvanını daxil edin. '
                        'GPS koordinatları avtomatik alınacaq.',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 22.regH(context)),

          // Backend: region_id (1 = Bakı, 2 = Sumqayıt)
          AppDropdownField<int>(
            label: 'Rayon / Şəhər',
            requiredField: true,
            hintText: 'Rayon / şəhər seçin',
            value: widget.regionId,
            onChanged: widget.onRegionChanged,
            items: const [
              DropdownMenuItem<int>(value: 1, child: Text('Bakı')),
              DropdownMenuItem<int>(value: 2, child: Text('Sumqayıt')),
            ],
            validator: (value) => value == null ? 'Rayon / şəhər seçin.' : null,
          ),

          SizedBox(height: 20.regH(context)),

          // Dəqiq yaşayış ünvanı
          AppTextField(
            label: 'Dəqiq yaşayış ünvanı',
            requiredField: true,
            hintText: 'Küçə, bina, ev və mənzil nömrəsi',
            controller: widget.addressController,
            textCapitalization: TextCapitalization.sentences,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            validator: AppValidators.requiredField,
          ),

          SizedBox(height: 22.regH(context)),

          // GPS başlığı
          Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: const [
                      TextSpan(text: 'Cari GPS mövqeyi'),
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                  style: context.textTheme.titleSmall?.copyWith(
                    fontSize: 15.regSp(context),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),

              Icon(
                Icons.my_location_rounded,
                size: 15.regR(context),
                color: const Color(0xFF173CBD),
              ),

              SizedBox(width: 5.regW(context)),

              Text(
                'Avtomatik GPS',
                style: TextStyle(
                  fontSize: 12.regSp(context),
                  color: const Color(0xFF173CBD),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 12.regH(context)),

          _buildLocationCard(),

          SizedBox(height: 12.regH(context)),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 17.regR(context),
                color: const Color(0xFF173CBD),
              ),

              SizedBox(width: 7.regW(context)),

              Expanded(
                child: Text(
                  'GPS koordinatları telefonun cari yerindən '
                  'götürülür. Xəritədə mövqeyi dəyişmək mümkün deyil.',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),

          if (widget.position != null && widget.position!.accuracy > 100) ...[
            SizedBox(height: 10.regH(context)),

            Text(
              'GPS dəqiqliyi aşağıdır. Daha açıq ərazidə '
              'koordinatları yeniləmək tövsiyə olunur.',
              style: TextStyle(
                fontSize: 12.regSp(context),
                color: const Color(0xFFB36B00),
              ),
            ),
          ],

          SizedBox(height: 16.regH(context)),
        ],
      ),
    );
  }
}

class _LocationException implements Exception {
  const _LocationException(this.message);

  final String message;
}
