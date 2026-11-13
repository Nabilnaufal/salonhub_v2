import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/routes/app_pages.dart';

class MitraChatController extends GetxController {
  final searchController = TextEditingController();
  final searchQuery = ''.obs;

  final conversations =
      <
        ({
          String name,
          String message,
          String time,
          String image,
          int unread,
          bool isOnline,
        })
      >[
        (
          name: 'Alan Cartwright',
          message: 'Bang, bisa potong jam 8 pagi?',
          time: '08.12',
          image: 'lib/assets/barbershop_haircut_3.jpg',
          unread: 2,
          isOnline: true,
        ),
        (
          name: 'Robert Gleichner',
          message: 'Warna coklat ash ya, jangan terlalu terang.',
          time: '09.04',
          image: 'lib/assets/barbershop_haircut_1.jpg',
          unread: 1,
          isOnline: true,
        ),
        (
          name: 'Sergio Wilderman',
          message: 'Oke, nanti saya datang tepat waktu.',
          time: '09.42',
          image: 'lib/assets/barbershop_interior_2.jpg',
          unread: 0,
          isOnline: false,
        ),
        (
          name: 'Nadia Puspita',
          message: 'Terima kasih hasilnya rapi banget!',
          time: '13.20',
          image: 'lib/assets/barbershop_haircut_2.jpg',
          unread: 0,
          isOnline: false,
        ),
        (
          name: 'Bagas Pratama',
          message: 'Bisa reschedule ke sore?',
          time: 'Kemarin',
          image: 'lib/assets/barbershop_exterior_1.jpg',
          unread: 0,
          isOnline: false,
        ),
      ];

  List<
    ({
      String name,
      String message,
      String time,
      String image,
      int unread,
      bool isOnline,
    })
  >
  get filteredConversations {
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

  void changeQuery(String value) {
    searchQuery.value = value;
  }

  void openConversation(String name, String image) {
    Get.toNamed(
      Routes.MITRA_CHAT_ROOM,
      arguments: {'name': name, 'image': image},
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
