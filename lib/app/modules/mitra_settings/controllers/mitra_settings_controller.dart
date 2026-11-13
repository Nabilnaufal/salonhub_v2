import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/routes/app_pages.dart';

class MitraSettingsController extends GetxController {
  final orderNotifications = true.obs;
  final soundNotifications = true.obs;
  final promoNotifications = false.obs;

  void toggleOrderNotifications() {
    orderNotifications.toggle();
  }

  void toggleSoundNotifications() {
    soundNotifications.toggle();
  }

  void togglePromoNotifications() {
    promoNotifications.toggle();
  }

  void openShopProfile() {
    Get.toNamed(Routes.MITRA_SHOP_PROFILE);
  }

  void openOpeningHours() {
    Get.bottomSheet(
      _sheet(
        title: 'Jam operasional',
        child: Column(
          children: const [
            _HourRow(day: 'Senin - Kamis', hours: '09.00 - 20.00'),
            _HourRow(day: 'Jumat - Sabtu', hours: '09.00 - 21.00'),
            _HourRow(day: 'Minggu', hours: '10.00 - 18.00'),
          ],
        ),
      ),
    );
  }

  void openPaymentMethods() {
    Get.bottomSheet(
      _sheet(
        title: 'Metode pembayaran',
        child: Column(
          children: const [
            _PaymentRow(name: 'QRIS', note: 'Aktif'),
            _PaymentRow(name: 'Transfer BCA', note: 'Aktif'),
            _PaymentRow(name: 'Transfer Mandiri', note: 'Aktif'),
            _PaymentRow(name: 'Transfer BRI', note: 'Nonaktif'),
            _PaymentRow(name: 'Transfer BNI', note: 'Nonaktif'),
          ],
        ),
      ),
    );
  }

  void openChangePassword() {
    Get.dialog(
      AlertDialog(
        title: const Text('Ubah password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password lama'),
            ),
            SizedBox(height: 10),
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password baru'),
            ),
            SizedBox(height: 10),
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Ulangi password baru'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Batal')),
          FilledButton(onPressed: Get.back, child: const Text('Simpan')),
        ],
      ),
    );
  }

  void openHelp() {
    Get.bottomSheet(
      _sheet(
        title: 'Pusat bantuan mitra',
        child: Column(
          children: const [
            _FaqRow(
              question: 'Bagaimana cara menerima pesanan?',
              answer:
                  'Buka menu Pesanan, pilih pesanan berstatus Baru, lalu '
                  'tekan Terima Pesanan.',
            ),
            _FaqRow(
              question: 'Bagaimana mengubah jam operasional?',
              answer:
                  'Masuk ke Pengaturan > Jam operasional untuk mengatur '
                  'jadwal buka tiap hari.',
            ),
            _FaqRow(
              question: 'Kapan pendapatan dicairkan?',
              answer:
                  'Pendapatan bersih dicairkan setiap 7 hari kerja setelah '
                  'transaksi selesai.',
            ),
          ],
        ),
      ),
    );
  }

  void openAbout() {
    Get.dialog(
      AlertDialog(
        title: const Text('Tentang SalonHub Mitra'),
        content: const Text(
          'SalonHub Mitra v1.0.0\n\n'
          'Aplikasi pengelolaan barbershop untuk mitra SalonHub. '
          'Tampilan ini masih berupa prototipe tanpa backend.',
        ),
        actions: [TextButton(onPressed: Get.back, child: const Text('Tutup'))],
      ),
    );
  }

  void openPrivacy() {
    Get.dialog(
      AlertDialog(
        title: const Text('Kebijakan privasi'),
        content: const Text(
          'Data pada prototipe ini hanya disimpan di memori aplikasi dan '
          'tidak dikirim ke server mana pun.',
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Mengerti')),
        ],
      ),
    );
  }

  Future<void> logout() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Keluar dari akun mitra?'),
        content: const Text('Kamu dapat masuk kembali kapan saja.'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Batal')),
          FilledButton(
            onPressed: () => Get.back(result: true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFE11D48),
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      Get.offAllNamed(Routes.MITRA_LOGIN);
    }
  }

  Widget _sheet({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD1D5DB),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _HourRow extends StatelessWidget {
  const _HourRow({required this.day, required this.hours});

  final String day;
  final String hours;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(child: Text(day, style: const TextStyle(fontSize: 13))),
          Text(
            hours,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({required this.name, required this.note});

  final String name;
  final String note;

  @override
  Widget build(BuildContext context) {
    final isActive = note == 'Aktif';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(child: Text(name, style: const TextStyle(fontSize: 13))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFFF0FDFA)
                  : const Color(0xFFF4F4F5),
              borderRadius: BorderRadius.circular(99),
            ),
            child: Text(
              note,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: isActive
                    ? const Color(0xFF0F766E)
                    : const Color(0xFF6B7280),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqRow extends StatelessWidget {
  const _FaqRow({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 3),
          Text(answer, style: const TextStyle(fontSize: 12, height: 1.4)),
        ],
      ),
    );
  }
}
