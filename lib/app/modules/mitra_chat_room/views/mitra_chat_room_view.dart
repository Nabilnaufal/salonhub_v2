import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/constant/theme.dart';
import 'package:salonhub_v2/app/modules/mitra_chat_room/controllers/mitra_chat_room_controller.dart';
import 'package:salonhub_v2/app/widgets/app_photo.dart';
import 'package:salonhub_v2/app/widgets/chat_message_body.dart';

class MitraChatRoomView extends GetView<MitraChatRoomController> {
  const MitraChatRoomView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueGray50,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Obx(
                () => ListView(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.blueGray100,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          'Hari ini',
                          style: AppTextStyles.caption2.copyWith(
                            color: AppColors.coolGray500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    for (final message in controller.messages)
                      _buildBubble(context, message),
                  ],
                ),
              ),
            ),
            _buildInputBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.blueGray100)),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: Get.back,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.blueGray50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 15,
                color: AppColors.primary900,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Stack(
            children: [
              avatarImage(controller.conversationImage, radius: 20),
              Positioned(
                right: 1,
                bottom: 1,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppColors.teal500,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.conversationName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.subHeadline3.copyWith(
                    color: AppColors.coolGray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Online • Customer',
                  style: AppTextStyles.caption2.copyWith(
                    color: AppColors.teal700,
                  ),
                ),
              ],
            ),
          ),
          _headerIcon(Icons.call_outlined, controller.callCustomer),
        ],
      ),
    );
  }

  Widget _headerIcon(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 36,
        height: 36,
        margin: const EdgeInsets.only(left: 6),
        decoration: BoxDecoration(
          color: AppColors.primary50,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 17, color: AppColors.primary900),
      ),
    );
  }

  Widget _buildBubble(BuildContext context, MitraChatMessage message) {
    final isMine = message.isMine;

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * .75,
        ),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.fromLTRB(12, 9, 12, 8),
        decoration: BoxDecoration(
          color: isMine ? AppColors.primary900 : AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft: Radius.circular(isMine ? 14 : 3),
            bottomRight: Radius.circular(isMine ? 3 : 14),
          ),
          border: isMine ? null : Border.all(color: AppColors.blueGray200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ChatMessageBody(
              text: message.text,
              textColor: isMine ? AppColors.white : AppColors.coolGray800,
              textStyle: AppTextStyles.body3.copyWith(
                color: isMine ? AppColors.white : AppColors.coolGray800,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.time,
                  style: AppTextStyles.caption2.copyWith(
                    color: isMine
                        ? AppColors.primary200
                        : AppColors.coolGray400,
                    fontSize: 9,
                  ),
                ),
                if (isMine) ...[
                  const SizedBox(width: 3),
                  message.isRead
                      ? SvgPicture.asset(
                          'lib/assets/icons/ion-checkmark-done-sharp.svg',
                          width: 12,
                          height: 12,
                          colorFilter: const ColorFilter.mode(
                            AppColors.primary200,
                            BlendMode.srcIn,
                          ),
                        )
                      : const Icon(
                          Icons.done_rounded,
                          size: 12,
                          color: AppColors.primary200,
                        ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        12,
        8,
        12,
        8 + MediaQuery.viewPaddingOf(context).bottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.blueGray100)),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: controller.sendPhoto,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.blueGray50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SvgPicture.asset(
                  'lib/assets/icons/Paperclip.svg',
                  colorFilter: const ColorFilter.mode(
                    AppColors.coolGray500,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              height: 42,
              child: TextField(
                controller: controller.messageController,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => controller.sendMessage(),
                style: AppTextStyles.body3.copyWith(
                  color: AppColors.coolGray900,
                ),
                decoration: InputDecoration(
                  hintText: 'Tulis pesan...',
                  hintStyle: AppTextStyles.caption1.copyWith(
                    color: AppColors.coolGray400,
                  ),
                  filled: true,
                  fillColor: AppColors.blueGray50,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.primary900,
                      width: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: controller.sendMessage,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary900,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(11),
                child: SvgPicture.asset(
                  'lib/assets/icons/Plain.svg',
                  colorFilter: const ColorFilter.mode(
                    AppColors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
