import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/constant/theme.dart';
import 'package:salonhub_v2/app/widgets/chat_message_body.dart';

import '../controllers/chat_room_controller.dart';
import 'package:salonhub_v2/app/widgets/app_photo.dart';

class ChatRoomView extends GetView<ChatRoomController> {
  const ChatRoomView({super.key});

  static const _assetPath = 'lib/assets/';
  static const _iconPath = '${_assetPath}icons/';

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.teal50,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.teal50,
        body: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildMessages()),
            _buildComposer(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: AppColors.teal50,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 106,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: [
                IconButton(
                  onPressed: Get.back,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 24,
                    color: AppColors.blueGray900,
                  ),
                ),
                const SizedBox(width: 12),
                _buildAvatar(size: 42),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.conversationName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.headline5.copyWith(
                          color: AppColors.blueGray900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.teal500,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 7),
                          Text(
                            'Online',
                            style: AppTextStyles.caption1.copyWith(
                              color: AppColors.blueGray500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessages() {
    return Obx(
      () => ListView.builder(
        controller: controller.scrollController,
        padding: const EdgeInsets.fromLTRB(20, 4, 16, 16),
        itemCount: controller.messages.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildDateLabel();
          }

          return _buildMessage(controller.messages[index - 1]);
        },
      ),
    );
  }

  Widget _buildDateLabel() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.primary700,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          'Hari ini',
          style: AppTextStyles.caption2.copyWith(color: AppColors.white),
        ),
      ),
    );
  }

  Widget _buildMessage(ChatRoomMessage message) {
    final bubble = Container(
      constraints: const BoxConstraints(maxWidth: 238),
      padding: const EdgeInsets.fromLTRB(14, 11, 12, 9),
      decoration: BoxDecoration(
        color: message.isMine ? AppColors.blueGray100 : AppColors.primary900,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: Radius.circular(message.isMine ? 16 : 4),
          bottomRight: Radius.circular(message.isMine ? 4 : 16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isMine) ...[
            Text(
              controller.adminName,
              style: AppTextStyles.caption1.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5),
          ],
          ChatMessageBody(
            text: message.text,
            textColor: message.isMine ? AppColors.blueGray900 : AppColors.white,
            textStyle: AppTextStyles.body3.copyWith(
              color: message.isMine ? AppColors.blueGray900 : AppColors.white,
            ),
          ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.time,
                  style: AppTextStyles.caption2.copyWith(
                    color: message.isMine
                        ? AppColors.blueGray400
                        : AppColors.white,
                  ),
                ),
                if (message.isMine && message.isRead) ...[
                  const SizedBox(width: 5),
                  SvgPicture.asset(
                    '${_iconPath}ion-checkmark-done-sharp.svg',
                    width: 14,
                    height: 14,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: message.isMine
          ? Align(alignment: Alignment.centerRight, child: bubble)
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAvatar(size: 28),
                const SizedBox(width: 8),
                Flexible(child: bubble),
              ],
            ),
    );
  }

  Widget _buildComposer() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 18, 16),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 52,
                padding: const EdgeInsets.only(left: 14, right: 8),
                decoration: BoxDecoration(
                  color: AppColors.blueGray100,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: controller.sendPhoto,
                      borderRadius: BorderRadius.circular(20),
                      child: const Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Icon(
                          Icons.attach_file_rounded,
                          size: 20,
                          color: AppColors.blueGray500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: controller.messageController,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => controller.sendMessage(),
                        style: AppTextStyles.body3.copyWith(
                          color: AppColors.blueGray900,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Ketik pesan',
                          hintStyle: AppTextStyles.body3.copyWith(
                            color: AppColors.blueGray400,
                          ),
                          filled: false,
                          fillColor: Colors.transparent,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    SvgPicture.asset(
                      '${_iconPath}Paperclip.svg',
                      width: 24,
                      height: 24,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Material(
              color: AppColors.primary900,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: controller.sendMessage,
                customBorder: const CircleBorder(),
                child: SizedBox(
                  width: 52,
                  height: 52,
                  child: Center(
                    child: SvgPicture.asset(
                      '${_iconPath}Plain.svg',
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar({required double size}) {
    return ClipOval(
      child: ColorFiltered(
        colorFilter: const ColorFilter.matrix([
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ]),
        child: AppPhoto(
          controller.conversationImage,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
