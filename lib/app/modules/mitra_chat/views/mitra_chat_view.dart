import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/constant/theme.dart';
import 'package:salonhub_v2/app/modules/mitra_chat/controllers/mitra_chat_controller.dart';
import 'package:salonhub_v2/app/widgets/mitra_empty_state.dart';
import 'package:salonhub_v2/app/widgets/mitra_page_header.dart';

class MitraChatView extends GetView<MitraChatController> {
  const MitraChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueGray50,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: MitraPageHeader(
                title: 'Pesan',
                subtitle:
                    '${controller.conversations.length} percakapan customer',
                onBack: Get.back,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 44,
                child: TextField(
                  controller: controller.searchController,
                  onChanged: controller.changeQuery,
                  style: AppTextStyles.body3.copyWith(
                    color: AppColors.coolGray900,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Cari nama customer...',
                    hintStyle: AppTextStyles.caption1.copyWith(
                      color: AppColors.blueGray400,
                    ),
                    filled: true,
                    fillColor: AppColors.white,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        'lib/assets/icons/search-normal.svg',
                        width: 18,
                        height: 18,
                      ),
                    ),
                    contentPadding: EdgeInsets.zero,
                    border: _border(),
                    enabledBorder: _border(),
                    focusedBorder: _border(color: AppColors.primary900),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Obx(() {
                final conversations = controller.filteredConversations;
                if (conversations.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: MitraEmptyState(
                      iconPath: 'lib/assets/icons/Chat Round Unread.svg',
                      title: 'Percakapan tidak ditemukan',
                      description: 'Coba kata kunci lain atau mulai chat baru.',
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: conversations.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final conversation = conversations[index];
                    return Material(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        onTap: () => controller.openConversation(
                          conversation.id,
                          conversation.name,
                          conversation.image,
                          phone: conversation.phone,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.blueGray200),
                          ),
                          child: Row(
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundImage: AssetImage(
                                      conversation.image,
                                    ),
                                  ),
                                  if (conversation.isOnline)
                                    Positioned(
                                      right: 1,
                                      bottom: 1,
                                      child: Container(
                                        width: 11,
                                        height: 11,
                                        decoration: BoxDecoration(
                                          color: AppColors.teal500,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.white,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      conversation.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.subHeadline3
                                          .copyWith(
                                            color: AppColors.coolGray900,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      conversation.message,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.caption1.copyWith(
                                        color: conversation.unread > 0
                                            ? AppColors.coolGray800
                                            : AppColors.coolGray500,
                                        fontWeight: conversation.unread > 0
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    conversation.time,
                                    style: AppTextStyles.caption2.copyWith(
                                      color: AppColors.coolGray400,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  if (conversation.unread > 0)
                                    Container(
                                      width: 18,
                                      height: 18,
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary900,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        '${conversation.unread}',
                                        style: AppTextStyles.caption2.copyWith(
                                          color: AppColors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    )
                                  else
                                    const SizedBox(height: 18),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  OutlineInputBorder _border({Color color = AppColors.blueGray200}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color),
    );
  }
}
