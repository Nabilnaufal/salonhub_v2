import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:salonhub_v2/app/constant/theme.dart';
import 'package:salonhub_v2/app/widgets/app_snackbar.dart';

/// Pilih koordinat dengan menggeser peta; pin selalu berada di tengah.
Future<LatLng?> showLocationPicker(BuildContext context, {LatLng? initial}) {
  return Navigator.of(context).push<LatLng>(
    MaterialPageRoute(builder: (_) => _LocationPickerPage(initial: initial)),
  );
}

typedef _Place = ({String name, LatLng point});

class _LocationPickerPage extends StatefulWidget {
  const _LocationPickerPage({this.initial});

  final LatLng? initial;

  @override
  State<_LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<_LocationPickerPage> {
  // Default: Yogyakarta, sama dengan data contoh toko.
  static const _fallback = LatLng(-7.797068, 110.370529);

  final _mapController = MapController();
  final _searchController = TextEditingController();
  late final _center = ValueNotifier<LatLng>(widget.initial ?? _fallback);

  List<_Place> _results = const [];
  bool _searching = false;

  @override
  void dispose() {
    _mapController.dispose();
    _searchController.dispose();
    _center.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    FocusScope.of(context).unfocus();
    setState(() => _searching = true);
    try {
      final response = await http.get(
        Uri.https('nominatim.openstreetmap.org', '/search', {
          'q': query,
          'format': 'jsonv2',
          'limit': '5',
          'accept-language': 'id',
        }),
        headers: const {'User-Agent': 'salonhub_v2/1.0 (mitra app)'},
      );
      final data = jsonDecode(response.body) as List;
      setState(() {
        _results = data
            .map(
              (item) => (
                name: item['display_name'] as String,
                point: LatLng(
                  double.parse(item['lat'] as String),
                  double.parse(item['lon'] as String),
                ),
              ),
            )
            .toList();
      });
      if (_results.isEmpty) {
        _showMessage('Lokasi tidak ditemukan. Coba kata kunci lain.');
      }
    } catch (_) {
      if (mounted) _showMessage('Pencarian gagal. Periksa koneksi internet.');
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  void _showMessage(String message) {
    showAppSnack('Pencarian lokasi', message, type: AppSnackType.error);
  }

  void _select(_Place place) {
    _mapController.move(place.point, 16);
    _center.value = place.point;
    setState(() => _results = const []);
    FocusScope.of(context).unfocus();
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
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center.value,
              initialZoom: 16,
              onPositionChanged: (camera, _) => _center.value = camera.center,
              onTap: (_, _) {
                if (_results.isNotEmpty) setState(() => _results = const []);
              },
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
            top: 12,
            left: 16,
            right: 16,
            child: Column(
              children: [
                Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(12),
                  child: TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _search(),
                    decoration: InputDecoration(
                      hintText: 'Cari nama tempat atau jalan',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      prefixIcon: const Icon(Icons.search, size: 20),
                      suffixIcon: _searching
                          ? const Padding(
                              padding: EdgeInsets.all(14),
                              child: SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
                if (_results.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final place in _results)
                          ListTile(
                            dense: true,
                            leading: const Icon(Icons.place_outlined, size: 20),
                            title: Text(
                              place.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.caption1,
                            ),
                            onTap: () => _select(place),
                          ),
                      ],
                    ),
                  ),
              ],
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
