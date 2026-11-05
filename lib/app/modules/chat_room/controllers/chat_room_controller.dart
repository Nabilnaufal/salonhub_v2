import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  final messageController = TextEditingController();
  final scrollController = ScrollController();

  final messages = <ChatRoomMessage>[
    const ChatRoomMessage(
      text: 'Selamat pagi, saya ingin memesan layanan potong rambut sore ini.',
      time: '08.45',
      isMine: true,
      isRead: true,
    ),
    const ChatRoomMessage(
      text: 'Tentu, kami buka sampai sore ini.',
      time: '09.15',
      isMine: false,
    ),
    const ChatRoomMessage(
      text: 'Silakan pesan melalui aplikasi Gobar.',
      time: '09.17',
      isMine: false,
    ),
    const ChatRoomMessage(
      text: 'Oke, terima kasih informasinya.',
      time: '09.20',
      isMine: true,
      isRead: true,
    ),
  ].obs;

  late final String conversationName;
  late final String conversationImage;

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
      conversationImage =
          arguments['image']?.toString() ??
          'lib/assets/barbershop_haircut_3.jpg';
    } else {
      conversationName = 'Twinsky Monkey Barber';
      conversationImage = 'lib/assets/barbershop_exterior_1.jpg';
    }

    super.onInit();
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) {
      return;
    }

    messages.add(
      ChatRoomMessage(text: text, time: 'Sekarang', isMine: true, isRead: true),
    );
    messageController.clear();
    _scrollToLatest();
  }

  void _scrollToLatest() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) {
        return;
      }

      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
