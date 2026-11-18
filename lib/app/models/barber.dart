import 'dart:math' as math;

/// Titik pusat perkiraan untuk menghitung jarak (Yogyakarta).
const _originLat = -7.7508;
const _originLng = 110.3794;

double distanceInKm(double? lat, double? lng) {
  if (lat == null || lng == null) return 0;

  const earthRadius = 6371.0;
  final dLat = _degreesToRadians(lat - _originLat);
  final dLng = _degreesToRadians(lng - _originLng);
  final a =
      math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(_degreesToRadians(_originLat)) *
          math.cos(_degreesToRadians(lat)) *
          math.sin(dLng / 2) *
          math.sin(dLng / 2);
  return earthRadius * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
}

double _degreesToRadians(double degrees) => degrees * math.pi / 180;

class Barber {
  const Barber({
    this.id = '',
    required this.name,
    required this.description,
    required this.distance,
    required this.rating,
    required this.image,
    this.latitude,
    this.longitude,
  });

  final String id;
  final String name;
  final String description;
  final String distance;
  final String rating;
  final String image;
  final double? latitude;
  final double? longitude;

  /// Alamat plus jarak bila koordinat tersedia.
  String get locationLabel =>
      distance.isEmpty ? description : '$description ($distance)';

  double get distanceKm => distanceInKm(latitude, longitude);

  factory Barber.fromShop(Map<String, dynamic> shop) {
    final latitude = (shop['latitude'] as num?)?.toDouble();
    final longitude = (shop['longitude'] as num?)?.toDouble();
    final km = distanceInKm(latitude, longitude);

    return Barber(
      id: shop['id'] as String,
      name: shop['name'] as String,
      description: shop['address'] as String? ?? '',
      distance: km > 0 ? '${km.toStringAsFixed(1)} km' : '',
      rating: ((shop['rating'] as num?)?.toDouble() ?? 0).toStringAsFixed(1),
      image: shop['image_url'] as String? ?? '',
      latitude: latitude,
      longitude: longitude,
    );
  }
}
