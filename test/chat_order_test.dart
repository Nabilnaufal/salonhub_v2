import 'package:flutter_test/flutter_test.dart';

/// Meniru isi `_listen()` di ruang chat: baris mentah dari Supabase diurutkan.
List<String> orderedBodies(List<Map<String, dynamic>> rows) {
  final sorted = [...rows]
    ..sort(
      (a, b) => (a['created_at'] as String? ?? '').compareTo(
        b['created_at'] as String? ?? '',
      ),
    );
  return sorted.map((row) => row['body'] as String).toList();
}

void main() {
  test('pesan diurutkan naik berdasarkan created_at', () {
    final rows = [
      {'body': 'ya halo bos', 'created_at': '2026-11-19 05:23:23+00'},
      {'body': 'halo', 'created_at': '2026-11-19 05:18:59+00'},
      {'body': 'apa kabar', 'created_at': '2026-11-19 05:23:45+00'},
    ];

    expect(orderedBodies(rows), ['halo', 'ya halo bos', 'apa kabar']);
  });
}
