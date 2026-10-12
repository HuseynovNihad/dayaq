import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../families/domain/entities/family_entity.dart';

class FamilyMapView extends StatelessWidget {
  const FamilyMapView({
    super.key,
    required this.families,
    this.fitAllMarkers = false,
  });

  final List<FamilyEntity> families;
  final bool fitAllMarkers;

  static const String _appPackageName = 'az.dayaq.mobile';

  static const String _mapTilerApiKey = String.fromEnvironment(
    'MAPTILER_API_KEY',
  );

  static const LatLng _baku = LatLng(40.4093, 49.8671);

  static bool hasValidCoordinates(FamilyEntity family) {
    final lat = family.lat;
    final lng = family.lng;

    return lat != null &&
        lng != null &&
        lat.isFinite &&
        lng.isFinite &&
        lat >= -90 &&
        lat <= 90 &&
        lng >= -180 &&
        lng <= 180 &&
        !(lat == 0 && lng == 0);
  }

  @override
  Widget build(BuildContext context) {
    final validFamilies = families.where(hasValidCoordinates).toList();

    final coordinates = validFamilies
        .map((family) => LatLng(family.lat!, family.lng!))
        .toList();

    final initialCenter = coordinates.isNotEmpty ? coordinates.first : _baku;

    final hasMapTilerKey = _mapTilerApiKey.trim().isNotEmpty;

    if (!hasMapTilerKey) {
      return Container(
        width: double.infinity,
        color: const Color(0xFFF3F1EA),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map_outlined, size: 38, color: Colors.grey),
            SizedBox(height: 10),
            Text(
              'Xəritə API açarı təyin edilməyib.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 6),
            Text(
              'MAPTILER_API_KEY konfiqurasiyasını yoxlayın.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return FlutterMap(
      options: MapOptions(
        initialCenter: initialCenter,
        initialZoom: 12,
        initialCameraFit: fitAllMarkers && coordinates.length > 1
            ? CameraFit.coordinates(
                coordinates: coordinates,
                padding: const EdgeInsets.all(48),
                maxZoom: 14,
              )
            : null,
      ),
      children: [
        // MapTiler xəritə görüntüləri
        TileLayer(
          urlTemplate:
              'https://api.maptiler.com/maps/streets-v4/256/'
              '{z}/{x}/{y}.png?key=$_mapTilerApiKey',
          userAgentPackageName: _appPackageName,
          maxNativeZoom: 19,
        ),

        // Qeydiyyatdan keçmiş ailələr
        MarkerLayer(
          markers: validFamilies.map((family) {
            return Marker(
              point: LatLng(family.lat!, family.lng!),
              width: 44,
              height: 44,
              child: const Icon(
                Icons.location_on_rounded,
                color: Color(0xFFF4B033),
                size: 36,
              ),
            );
          }).toList(),
        ),

        // Xəritə mənbələrinin göstərilməsi
        const RichAttributionWidget(
          attributions: [
            TextSourceAttribution('MapTiler'),
            TextSourceAttribution('OpenStreetMap contributors'),
          ],
        ),
      ],
    );
  }
}
