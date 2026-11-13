import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  final messageController = TextEditingController();
  final scrollController = ScrollController();

  late final String conversationName;
  late final String conversationImage;

  final messages = <MitraChatMessage>[
    const MitraChatMessage(
      text: 'Halo bang, saya mau potong jam 8 pagi ini masih ada slot?',
      time: '08.12',
      isMine: false,
    ),
    const MitraChatMessage(
      text: 'Halo kak, slot jam 8 masih tersedia. Mau saya bantu pesankan?',
      time: '08.14',
      isMine: true,
      isRead: true,
    ),
    const MitraChatMessage(
      text: 'Boleh bang. Model undercut rapi ya.',
      time: '08.15',
      isMine: false,
    ),
    const MitraChatMessage(
      text: 'Siap kak, nanti saya info ke barber yang bertugas.',
      time: '08.16',
      isMine: true,
      isRead: true,
    ),
  ].obs;

  @override
  void onInit() {
    final arguments = Get.arguments;
    if (arguments is Map) {
      conversationName = arguments['name']?.toString() ?? 'Customer';
      conversationImage =
          arguments['image']?.toString() ??
          'lib/assets/barbershop_haircut_3.jpg';
    } else {
      conversationName = 'Alan Cartwright';
      conversationImage = 'lib/assets/barbershop_haircut_3.jpg';
    }
    super.onInit();
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) {
      return;
    }

    messages.add(
      MitraChatMessage(
        text: text,
        time: 'Sekarang',
        isMine: true,
        isRead: true,
      ),
    );
    messageController.clear();
  }

  void callCustomer() {
    Get.snackbar(
      'Telepon customer',
      'Menghubungi $conversationName...',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
