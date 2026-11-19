import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/data/mitra_data_service.dart';
import 'package:salonhub_v2/app/routes/app_pages.dart';
import 'package:salonhub_v2/app/services/auth_service.dart';
import 'package:salonhub_v2/app/widgets/app_snackbar.dart';
import 'package:salonhub_v2/app/widgets/opening_hours_editor.dart';

class MitraSettingsController extends GetxController {
  final data = Get.find<MitraDataService>();
  final auth = Get.find<AuthService>();

  final orderNotifications = true.obs;
  final soundNotifications = true.obs;
  final promoNotifications = false.obs;

  @override
  void onInit() {
    final profile = auth.profile.value;
    if (profile != null) {
      orderNotifications.value = profile.orderNotifications;
      soundNotifications.value = profile.soundNotifications;
      promoNotifications.value = profile.promoNotifications;
    }
    data.load();
    super.onInit();
  }

  Future<void> toggleOrderNotifications() async {
    orderNotifications.toggle();
    await _savePrefs();
  }

  Future<void> toggleSoundNotifications() async {
    soundNotifications.toggle();
    await _savePrefs();
  }

  Future<void> togglePromoNotifications() async {
    promoNotifications.toggle();
    await _savePrefs();
  }

  Future<void> _savePrefs() async {
    try {
      await auth.updateNotificationPrefs(
        orderNotifications: orderNotifications.value,
        soundNotifications: soundNotifications.value,
        promoNotifications: promoNotifications.value,
      );
    } catch (_) {
      showAppSnack(
        'Gagal menyimpan',
        'Pengaturan notifikasi belum tersimpan. Coba lagi.',
        type: AppSnackType.error,
      );
    }
  }

  void openShopProfile() {
    Get.toNamed(Routes.MITRA_SHOP_PROFILE);
  }

  Future<void> openOpeningHours(BuildContext context) =>
      showOpeningHoursEditor(context, data);

  void openPaymentMethods() {
    Get.bottomSheet(
      _sheet(
        title: 'Metode pembayaran',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Customer memilih metode saat membayar pesanan. Pembayaran '
              'dikonfirmasi manual oleh mitra (belum terhubung payment '
              'gateway).',
              style: TextStyle(fontSize: 12, height: 1.4),
            ),
            SizedBox(height: 12),
            _PaymentRow(name: 'QRIS', note: 'Demo'),
            _PaymentRow(name: 'Transfer BCA', note: 'Demo'),
            _PaymentRow(name: 'Transfer Mandiri', note: 'Demo'),
            _PaymentRow(name: 'Transfer BRI', note: 'Demo'),
            _PaymentRow(name: 'Transfer BNI', note: 'Demo'),
            _PaymentRow(name: 'Tunai (walk-in)', note: 'Demo'),
          ],
        ),
      ),
    );
  }

  Future<void> openChangePassword() async {
    final currentController = TextEditingController();
    final newController = TextEditingController();

    final save = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Ubah password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password saat ini'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: newController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password baru'),
            ),
          ],
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

    final current = currentController.text;
    final password = newController.text;
    currentController.dispose();
    newController.dispose();

    if (save != true) return;
    if (password.length < 6) {
      showAppSnack(
        'Password lemah',
        'Minimal 6 karakter.',
        type: AppSnackType.error,
      );
      return;
    }

    try {
      // Verifikasi password lama dulu supaya sesi tidak dibajak.
      final email = auth.profile.value?.email;
      if (email == null) throw StateError('sesi tidak valid');
      await auth.signIn(email: email, password: current);
      await auth.changePassword(password);
      showAppSnack(
        'Password diperbarui',
        'Gunakan password baru saat login berikutnya.',
      );
    } catch (_) {
      showAppSnack(
        'Gagal mengubah password',
        'Password saat ini salah atau password baru ditolak.',

        type: AppSnackType.error,
      );
    }
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
          'Semua data tersimpan dengan aman.',
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
          'Data akun, toko, pesanan, dan foto disimpan dengan aman dan hanya '
          'dapat diakses oleh pemilik akun.',
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
      await auth.signOut();
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

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({required this.name, required this.note});

  final String name;
  final String note;

  @override
  Widget build(BuildContext context) {
    final isActive = note != 'Nonaktif';
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
