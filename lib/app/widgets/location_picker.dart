import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:salonhub_v2/app/constant/theme.dart';

/// Pilih koordinat dengan menggeser peta; pin selalu berada di tengah.
Future<LatLng?> showLocationPicker(BuildContext context, {LatLng? initial}) {
  return Navigator.of(context).push<LatLng>(
    MaterialPageRoute(builder: (_) => _LocationPickerPage(initial: initial)),
  );
}

class _LocationPickerPage extends StatefulWidget {
  const _LocationPickerPage({this.initial});

  final LatLng? initial;

  @override
  State<_LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<_LocationPickerPage> {
  // Default: Yogyakarta, sama dengan data contoh toko.
  static const _fallback = LatLng(-7.797068, 110.370529);

  late final _center = ValueNotifier<LatLng>(widget.initial ?? _fallback);

  @override
  void dispose() {
    _center.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.coolGray900,
        title: const Text('Pilih lokasi toko'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: _center.value,
              initialZoom: 16,
              onPositionChanged: (camera, _) => _center.value = camera.center,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.salonhub.salonhub_v2',
              ),
            ],
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: Icon(
                Icons.location_on,
                size: 46,
                color: AppColors.primary900,
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ValueListenableBuilder<LatLng>(
                  valueListenable: _center,
                  builder: (context, center, _) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${center.latitude.toStringAsFixed(6)}, '
                      '${center.longitude.toStringAsFixed(6)}',
                      style: AppTextStyles.caption2.copyWith(
                        color: AppColors.coolGray700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(_center.value),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary900,
                      foregroundColor: AppColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Pakai lokasi ini',
                      style: AppTextStyles.subHeadline2.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
