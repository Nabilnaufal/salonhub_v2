import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:image_picker/image_picker.dart';
import 'package:salonhub_v2/app/services/auth_service.dart';
import 'package:salonhub_v2/app/services/catalog_service.dart';

class ChatRoomMessage {
  const ChatRoomMessage({
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

class ChatRoomController extends GetxController {
  final catalog = Get.find<CatalogService>();
  final auth = Get.find<AuthService>();

  final messageController = TextEditingController();
  final scrollController = ScrollController();
  final messages = <ChatRoomMessage>[].obs;
  final isLoading = true.obs;

  late final String conversationName;
  String conversationImage = '';
  String? _shopId;
  String? _conversationId;
  String? _passedConversationId;
  StreamSubscription<List<Map<String, dynamic>>>? _subscription;

  String get adminName {
    final nameParts = conversationName.split(' ');
    final shortName = nameParts.take(2).join(' ');
    return 'Admin $shortName';
  }

  @override
  void onInit() {
    final arguments = Get.arguments;
    if (arguments is Map) {
      conversationName = arguments['name']?.toString() ?? 'Barbershop';
      conversationImage = arguments['image']?.toString() ?? '';
      _shopId = arguments['shopId']?.toString();
      _passedConversationId = arguments['conversationId']?.toString();
    } else {
      conversationName = 'Barbershop';
    }

    _initConversation();
    super.onInit();
  }

  Future<void> _initConversation() async {
    try {
      final passedId = _passedConversationId;
      if (passedId != null && passedId.isNotEmpty) {
        _conversationId = passedId;
        await _markRead();
        _listen();
        return;
      }
      if (_shopId != null && _shopId!.isNotEmpty) {
        final conversation = await catalog.ensureConversation(_shopId!);
        _conversationId = conversation['id'] as String;
        await _markRead();
        _listen();
      }
    } catch (_) {
      isLoading.value = false;
    }
  }

  Future<void> _markRead() async {
    final id = _conversationId;
    if (id == null) return;
    try {
      await catalog.markConversationRead(id);
    } catch (_) {
      // Badge akan hilang saat daftar chat dimuat ulang.
    }
  }

  void _listen() {
    final id = _conversationId;
    if (id == null) {
      isLoading.value = false;
      return;
    }

    final uid = Supabase.instance.client.auth.currentUser?.id;
    _subscription = catalog.messagesStream(id).listen((rows) {
      messages.assignAll(
        rows.map((row) {
          final createdAt = DateTime.tryParse(
            row['created_at'] as String? ?? '',
          );
          return ChatRoomMessage(
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
      isLoading.value = false;
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
      Get.snackbar(
        'Foto gagal dikirim',
        'Coba lagi beberapa saat.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
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
      Get.snackbar(
        'Pesan gagal',
        'Pesan belum terkirim. Coba lagi.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
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

  @override
  void onClose() {
    _subscription?.cancel();
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
