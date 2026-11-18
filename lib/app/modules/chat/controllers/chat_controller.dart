import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:salonhub_v2/app/routes/app_pages.dart';
import 'package:salonhub_v2/app/services/catalog_service.dart';

class ChatConversation {
  const ChatConversation({
    this.shopId = '',
    required this.name,
    required this.message,
    required this.time,
    required this.image,
    this.unreadCount = 0,
    this.isRead = false,
  });

  final String shopId;
  final String name;
  final String message;
  final String time;
  final String image;
  final int unreadCount;
  final bool isRead;
}

class ChatController extends GetxController {
  final catalog = Get.find<CatalogService>();

  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final isLoading = false.obs;

  final conversations = <ChatConversation>[].obs;

  /// ID percakapan per toko, dipakai saat membuka room.
  final _conversationIds = <String, String>{};

  @override
  void onInit() {
    load();
    searchController.addListener(_onSearchChanged);
    super.onInit();
  }

  Future<void> load() async {
    isLoading.value = true;
    try {
      final rows = await catalog.loadConversations();
      _conversationIds
        ..clear()
        ..addAll({
          for (final row in rows) row['shop_id'] as String: row['id'] as String,
        });
      conversations.assignAll(
        rows.map((row) {
          final lastAt = DateTime.tryParse(
            row['last_message_at'] as String? ?? '',
          );
          return ChatConversation(
            shopId: row['shop_id'] as String,
            name: row['shop_name'] as String? ?? 'Barbershop',
            message: (row['last_message'] as String?)?.isNotEmpty == true
                ? row['last_message'] as String
                : 'Mulai percakapan',
            time: lastAt == null
                ? ''
                : '${lastAt.toLocal().hour.toString().padLeft(2, '0')}.'
                      '${lastAt.toLocal().minute.toString().padLeft(2, '0')}',
            image: row['shop_image'] as String? ?? '',
            unreadCount: (row['unread'] as num?)?.toInt() ?? 0,
            isRead: ((row['unread'] as num?)?.toInt() ?? 0) == 0,
          );
        }),
      );
    } catch (_) {
      // Daftar kosong bila gagal memuat.
    } finally {
      isLoading.value = false;
    }
  }

  List<ChatConversation> get filteredConversations {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return conversations;

    return conversations
        .where(
          (conversation) =>
              conversation.name.toLowerCase().contains(query) ||
              conversation.message.toLowerCase().contains(query),
        )
        .toList();
  }

  @override
  void onClose() {
    searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.onClose();
  }

  Future<void> openConversation(ChatConversation conversation) async {
    final conversationId = _conversationIds[conversation.shopId];
    if (conversationId != null) {
      // Tandai sudah dibaca supaya badge hilang saat kembali.
      await catalog.markConversationRead(conversationId);
    }
    await Get.toNamed(
      Routes.CHAT_ROOM,
      arguments: {
        'shopId': conversation.shopId,
        'conversationId': conversationId,
        'name': conversation.name,
        'image': conversation.image,
      },
    );
    load();
  }

  void changeNavigation(int index) {
    if (index == 0) {
      Get.offNamed(Routes.HOME);
    } else if (index == 1) {
      Get.offNamed(Routes.ORDERS);
    } else if (index == 3) {
      Get.offNamed(Routes.PROFILE);
    }
  }

  void _onSearchChanged() {
    searchQuery.value = searchController.text;
  }
}
