import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Buka Google Maps pada koordinat tujuan (mode navigasi).
Future<void> openMapLocation(
  double latitude,
  double longitude, [
  String? label,
]) async {
  final destination = Uri.encodeComponent('$latitude,$longitude');
  final uri = Uri.parse(
    'https://www.google.com/maps/dir/?api=1&destination=$destination',
  );
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw StateError('Tidak bisa membuka peta');
  }
}

/// Bagikan teks lewat sheet bawaan OS.
Future<void> shareText(String text, {String? subject}) async {
  await SharePlus.instance.share(ShareParams(text: text, subject: subject));
}

/// Telepon nomor toko/customer (karakter selain angka dan + dibuang).
Future<void> callNumber(String phone) async {
  final digits = phone.replaceAll(RegExp(r'[^0-9+]'), '');
  if (digits.isEmpty) throw StateError('Nomor telepon kosong');
  final uri = Uri(scheme: 'tel', path: digits);
  if (!await launchUrl(uri)) {
    throw StateError('Tidak bisa menelepon');
  }
}
