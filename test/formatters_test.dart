import 'package:flutter_test/flutter_test.dart';
import 'package:salonhub_v2/app/models/mitra.dart';

void main() {
  test('formatRupiah memakai titik ribuan', () {
    expect(formatRupiah(0), 'Rp0');
    expect(formatRupiah(25000), 'Rp25.000');
    expect(formatRupiah(1250000), 'Rp1.250.000');
  });

  test('formatDateLabel menandai hari ini dan kemarin', () {
    final now = DateTime.now();
    expect(formatDateLabel(now), startsWith('Hari ini, '));
    expect(
      formatDateLabel(now.subtract(const Duration(days: 1))),
      startsWith('Kemarin, '),
    );
  });

  test('formatTimeLabel memakai titik sebagai pemisah', () {
    expect(formatTimeLabel(DateTime(2026, 1, 1, 9, 5)), '09.05 WIB');
  });
}
