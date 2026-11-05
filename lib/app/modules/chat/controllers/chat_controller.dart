import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/routes/app_pages.dart';

class ChatConversation {
  const ChatConversation({
    required this.name,
    required this.message,
    required this.time,
    required this.image,
    this.unreadCount = 0,
    this.isRead = false,
  });

  final String name;
  final String message;
  final String time;
  final String image;
  final int unreadCount;
  final bool isRead;
}

class ChatController extends GetxController {
  final searchController = TextEditingController();
  final searchQuery = ''.obs;

  final conversations = const [
    ChatConversation(
      name: 'Varcity Barbershop',
      message: 'Saya ingin konsultasi tentang gaya rambut terbaru...',
      time: '16.30',
      image: 'lib/assets/barbershop_haircut_3.jpg',
      isRead: true,
    ),
    ChatConversation(
      name: 'Twinsky Monkey Barber',
      message: 'Apakah ada rekomendasi untuk rambut saya?',
      time: '21.30',
      image: 'lib/assets/barbershop_exterior_1.jpg',
      isRead: true,
    ),
    ChatConversation(
      name: 'Barberman Haircut',
      message: 'Maaf, kami buka dari jam 7 sampai 9 malam.',
      time: '18.00',
      image: 'lib/assets/barbershop_interior_2.jpg',
      unreadCount: 2,
    ),
    ChatConversation(
      name: 'Alana Barbershop',
      message: 'Kami merekomendasikan gaya rambut ini untukmu.',
      time: '12.00',
      image: 'lib/assets/barbershop_haircut_1.jpg',
      unreadCount: 1,
    ),
    ChatConversation(
      name: 'Varcity Barbershop',
      message: 'Terima kasih sudah berkunjung ke tempat kami.',
      time: '08.53',
      image: 'lib/assets/barbershop_interior_1.jpg',
      unreadCount: 1,
    ),
    ChatConversation(
      name: 'Varcity Barbershop',
      message: 'Mohon maaf, hari ini kami sedang libur.',
      time: '09.24',
      image: 'lib/assets/barbershop_haircut_2.jpg',
      unreadCount: 1,
    ),
    ChatConversation(
      name: 'Varcity Barbershop',
      message: 'Kami siap melayani kebutuhan grooming kamu.',
      time: '11.57',
      image: 'lib/assets/barbershop_haircut_1.jpg',
      unreadCount: 1,
    ),
  ];

  List<ChatConversation> get filteredConversations {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) {
      return conversations;
    }

    return conversations
        .where(
          (conversation) =>
              conversation.name.toLowerCase().contains(query) ||
              conversation.message.toLowerCase().contains(query),
        )
        .toList();
  }

  @override
  void onInit() {
    searchController.addListener(_onSearchChanged);
    super.onInit();
  }

  @override
  void onClose() {
    searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.onClose();
  }

  void openConversation(ChatConversation conversation) {
    Get.toNamed(
      Routes.CHAT_ROOM,
      arguments: {'name': conversation.name, 'image': conversation.image},
    );
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
