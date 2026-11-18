import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:salonhub_v2/app/data/mitra_data_service.dart';
import 'package:salonhub_v2/app/routes/app_pages.dart';
import 'package:salonhub_v2/app/services/catalog_service.dart';

class MitraChatController extends GetxController {
  final data = Get.find<MitraDataService>();
  final catalog = Get.find<CatalogService>();
  SupabaseClient get _client => Supabase.instance.client;

  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final isLoading = false.obs;

  final conversations =
      <
            ({
              String id,
              String name,
              String message,
              String time,
              String image,
              int unread,
              bool isOnline,
              String phone,
            })
          >[]
          .obs;

  @override
  void onInit() {
    load();
    super.onInit();
  }

  Future<void> load() async {
    final shopId = data.shopId;
    if (shopId == null) {
      await data.load();
    }
    final currentShopId = data.shopId;
    if (currentShopId == null) return;

    isLoading.value = true;
    try {
      final rows = await _client
          .from('conversations')
          .select()
          .eq('shop_id', currentShopId)
          .order('last_message_at', ascending: false);

      final unread = await catalog.unreadCounts();
      final ids = rows.map((row) => row['customer_id']).toSet().toList();
      final profiles = ids.isEmpty
          ? const <Map<String, dynamic>>[]
          : await _client
                .from('public_profiles')
                .select('id, full_name, avatar_url')
                .inFilter('id', ids);
      final byId = {for (final row in profiles) row['id'] as String: row};

      // Nomor telepon hanya terbaca untuk customer yang pernah booking.
      final phoneRows = ids.isEmpty
          ? const <Map<String, dynamic>>[]
          : await _client
                .from('profiles')
                .select('id, phone')
                .inFilter('id', ids);
      final phoneById = {
        for (final row in phoneRows)
          row['id'] as String: row['phone'] as String?,
      };

      conversations.assignAll(
        rows.map((row) {
          final profile = byId[row['customer_id']];
          final lastAt = DateTime.tryParse(
            row['last_message_at'] as String? ?? '',
          );
          return (
            id: row['id'] as String,
            name: profile?['full_name'] as String? ?? 'Customer',
            message: (row['last_message'] as String?)?.isNotEmpty == true
                ? row['last_message'] as String
                : 'Mulai percakapan',
            time: lastAt == null
                ? ''
                : '${lastAt.toLocal().hour.toString().padLeft(2, '0')}.'
                      '${lastAt.toLocal().minute.toString().padLeft(2, '0')}',
            image: profile?['avatar_url'] as String? ?? '',
            unread: unread[row['id']] ?? 0,
            isOnline: false,
            phone: phoneById[row['customer_id']] ?? '',
          );
        }),
      );
    } catch (_) {
      // Daftar kosong bila gagal memuat.
    } finally {
      isLoading.value = false;
    }
  }

  List<
    ({
      String id,
      String name,
      String message,
      String time,
      String image,
      int unread,
      bool isOnline,
      String phone,
    })
  >
  get filteredConversations {
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

  void changeQuery(String value) {
    searchQuery.value = value;
  }

  Future<void> openConversation(
    String id,
    String name,
    String image, {
    String phone = '',
  }) async {
    await catalog.markConversationRead(id);
    await Get.toNamed(
      Routes.MITRA_CHAT_ROOM,
      arguments: {
        'conversationId': id,
        'name': name,
        'image': image,
        'phone': phone,
      },
    );
    load();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
