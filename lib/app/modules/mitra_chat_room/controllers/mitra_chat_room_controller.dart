import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salonhub_v2/app/services/auth_service.dart';
import 'package:salonhub_v2/app/services/catalog_service.dart';
import 'package:salonhub_v2/app/services/external_actions.dart';
import 'package:salonhub_v2/app/widgets/app_snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MitraChatMessage {
  const MitraChatMessage({
    required this.text,
    required this.time,
    required this.isMine,
    this.isRead = false,
  });

  final String text;
  final String time;
  final bool isMine;
  final bool isRead;
}

class MitraChatRoomController extends GetxController {
  final catalog = Get.find<CatalogService>();
  final auth = Get.find<AuthService>();

  final messageController = TextEditingController();
  final scrollController = ScrollController();
  final messages = <MitraChatMessage>[].obs;

  late final String conversationName;
  String conversationImage = '';
  String? _conversationId;
  StreamSubscription<List<Map<String, dynamic>>>? _subscription;

  @override
  void onInit() {
    final arguments = Get.arguments;
    if (arguments is Map) {
      conversationName = arguments['name']?.toString() ?? 'Customer';
      conversationImage = arguments['image']?.toString() ?? '';
      customerPhone = arguments['phone']?.toString() ?? '';
      _conversationId = arguments['conversationId']?.toString();
    } else {
      conversationName = 'Customer';
    }
    _listen();
    super.onInit();
  }

  void _listen() {
    final id = _conversationId;
    if (id == null || id.isEmpty) return;

    final uid = Supabase.instance.client.auth.currentUser?.id;
    _subscription = catalog.messagesStream(id).listen((rows) {
      messages.assignAll(
        rows.map((row) {
          final createdAt = DateTime.tryParse(
            row['created_at'] as String? ?? '',
          );
          return MitraChatMessage(
            text: row['body'] as String? ?? '',
            time: createdAt == null
                ? ''
                : '${createdAt.toLocal().hour.toString().padLeft(2, '0')}.'
                      '${createdAt.toLocal().minute.toString().padLeft(2, '0')}',
            isMine: row['sender_id'] == uid,
            isRead: row['is_read'] == true,
          );
        }),
      );
      _scrollToLatest();
    });
  }

  /// Kirim foto: upload ke Storage, lalu kirim URL-nya sebagai pesan.
  Future<void> sendPhoto() async {
    final id = _conversationId;
    if (id == null) return;
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );
    if (picked == null) return;

    try {
      final bytes = await picked.readAsBytes();
      final url = await auth.uploadPhoto(bytes, folder: 'chats');
      await catalog.sendMessage(id, url);
    } catch (_) {
      showAppSnack(
        'Foto gagal dikirim',
        'Coba lagi beberapa saat.',
        type: AppSnackType.error,
      );
    }
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    final id = _conversationId;
    if (text.isEmpty || id == null) return;

    messageController.clear();
    try {
      await catalog.sendMessage(id, text);
    } catch (_) {
      showAppSnack(
        'Pesan gagal',
        'Pesan belum terkirim. Coba lagi.',
        type: AppSnackType.error,
      );
    }
  }

  void _scrollToLatest() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  String customerPhone = '';

  Future<void> callCustomer() async {
    if (customerPhone.isEmpty) {
      showAppSnack(
        'Nomor tidak tersedia',
        'Customer belum mengisi nomor telepon.',

        type: AppSnackType.error,
      );
      return;
    }
    try {
      await callNumber(customerPhone);
    } catch (_) {
      showAppSnack(
        'Telepon',
        'Tidak bisa membuka aplikasi telepon.',
        type: AppSnackType.error,
      );
    }
  }

  @override
  void onClose() {
    _subscription?.cancel();
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
