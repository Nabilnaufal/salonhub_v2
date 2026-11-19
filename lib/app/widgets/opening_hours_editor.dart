import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/constant/theme.dart';
import 'package:salonhub_v2/app/data/mitra_data_service.dart';

class _HourDraft {
  _HourDraft({
    required this.day,
    required this.label,
    required this.open,
    required this.close,
    required this.isClosed,
  });

  final int day;
  final String label;
  TimeOfDay open;
  TimeOfDay close;
  bool isClosed;
}

String _timeText(TimeOfDay time) =>
    '${time.hour.toString().padLeft(2, '0')}.'
    '${time.minute.toString().padLeft(2, '0')}';

String _timeValue(TimeOfDay time) =>
    '${time.hour.toString().padLeft(2, '0')}:'
    '${time.minute.toString().padLeft(2, '0')}:00';

Widget _timeButton({required String text, required VoidCallback? onPressed}) {
  return TextButton(
    onPressed: onPressed,
    style: TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      minimumSize: const Size(0, 40),
    ),
    child: Text(text, style: const TextStyle(fontSize: 12)),
  );
}

/// Editor jam operasional 7 hari; menyimpan ke `shop_opening_hours`.
Future<void> showOpeningHoursEditor(
  BuildContext context,
  MitraDataService data,
) async {
  const labels = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  final rows = data.shop.value.openingHours;
  final drafts = List.generate(7, (index) {
    final match = rows.length > index ? rows[index] : null;
    final parts = (match?.hours ?? '09.00 - 20.00').split(' - ');
    TimeOfDay parse(String value, TimeOfDay fallback) {
      final bits = value.replaceAll(':', '.').split('.');
      if (bits.length < 2) return fallback;
      final hour = int.tryParse(bits[0]);
      final minute = int.tryParse(bits[1]);
      if (hour == null || minute == null) return fallback;
      return TimeOfDay(hour: hour, minute: minute);
    }

    return _HourDraft(
      day: index,
      label: labels[index],
      open: parse(parts.first, const TimeOfDay(hour: 9, minute: 0)),
      close: parse(
        parts.length > 1 ? parts[1] : '20.00',
        const TimeOfDay(hour: 20, minute: 0),
      ),
      isClosed: match?.isClosed ?? false,
    );
  });

  final saved = await Get.dialog<bool>(
    AlertDialog(
      title: const Text('Jam operasional'),
      content: SizedBox(
        width: double.maxFinite,
        child: StatefulBuilder(
          builder: (context, setState) => ListView.separated(
            shrinkWrap: true,
            itemCount: drafts.length,
            separatorBuilder: (_, _) => const Divider(height: 8),
            itemBuilder: (context, index) {
              final draft = drafts[index];

              Future<void> pickTime({required bool isOpen}) async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: isOpen ? draft.open : draft.close,
                );
                if (picked == null) return;
                setState(() {
                  if (isOpen) {
                    draft.open = picked;
                  } else {
                    draft.close = picked;
                  }
                });
              }

              return Row(
                children: [
                  SizedBox(
                    width: 62,
                    child: Text(
                      draft.label,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _timeButton(
                          text: draft.isClosed ? '-' : _timeText(draft.open),
                          onPressed: draft.isClosed
                              ? null
                              : () => pickTime(isOpen: true),
                        ),
                        const Text('–', style: TextStyle(fontSize: 12)),
                        _timeButton(
                          text: draft.isClosed ? '-' : _timeText(draft.close),
                          onPressed: draft.isClosed
                              ? null
                              : () => pickTime(isOpen: false),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 32,
                    child: Switch(
                      value: !draft.isClosed,
                      activeThumbColor: AppColors.white,
                      activeTrackColor: AppColors.primary900,
                      onChanged: (value) =>
                          setState(() => draft.isClosed = !value),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: Get.back, child: const Text('Batal')),
        FilledButton(
          onPressed: () => Get.back(result: true),
          child: const Text('Simpan'),
        ),
      ],
    ),
  );

  if (saved != true) return;

  try {
    await data.updateOpeningHours(
      drafts
          .map(
            (draft) => (
              day: draft.day,
              open: _timeValue(draft.open),
              close: _timeValue(draft.close),
              isClosed: draft.isClosed,
            ),
          )
          .toList(),
    );
    Get.snackbar(
      'Jam operasional',
      'Jadwal buka toko sudah disimpan.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  } catch (_) {
    Get.snackbar(
      'Gagal menyimpan',
      'Jam operasional belum tersimpan. Coba lagi.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }
}
