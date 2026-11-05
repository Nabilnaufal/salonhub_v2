import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:salonhub_v2/app/constant/theme.dart';

import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  static const _assetPath = 'lib/assets/';
  static const _iconPath = '${_assetPath}icons/';

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.primary900,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.teal50,
        body: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            Expanded(
              child: SafeArea(top: false, child: _buildConversationList()),
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: AppColors.primary900,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 62,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'Chat',
                  style: AppTextStyles.headline4.copyWith(
                    color: AppColors.white,
                  ),
                ),
                const Spacer(),
                Image.asset(
                  '${_assetPath}logo.png',
                  width: 78,
                  height: 38,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 10),
      child: SizedBox(
        height: 42,
        child: TextField(
          controller: controller.searchController,
          style: AppTextStyles.caption1.copyWith(color: AppColors.blueGray900),
          decoration: InputDecoration(
            hintText: 'Cari chat',
            hintStyle: AppTextStyles.caption1.copyWith(
              color: AppColors.primary500,
            ),
            filled: true,
            fillColor: AppColors.blueGray100,
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset(
                '${_iconPath}search-normal.svg',
                width: 18,
                height: 18,
              ),
            ),
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.primary900,
                width: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConversationList() {
    return Obx(
      () => ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 2, 16, 18),
        itemCount: controller.filteredConversations.length,
        itemBuilder: (context, index) {
          final conversation = controller.filteredConversations[index];

          return _buildConversationTile(conversation);
        },
      ),
    );
  }

  Widget _buildConversationTile(ChatConversation conversation) {
    return ListTile(
      onTap: () => controller.openConversation(conversation),
      contentPadding: const EdgeInsets.symmetric(vertical: 7),
      minVerticalPadding: 0,
      horizontalTitleGap: 10,
      leading: _buildAvatar(conversation.image),
      title: Text(
        conversation.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.body3.copyWith(
          color: AppColors.blueGray900,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Text(
          conversation.message,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption1.copyWith(color: AppColors.blueGray500),
        ),
      ),
      trailing: _buildTrailing(conversation),
    );
  }

  Widget _buildAvatar(String image) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipOval(
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
            child: Image.asset(image, width: 48, height: 48, fit: BoxFit.cover),
          ),
        ),
        Positioned(
          right: -1,
          top: -1,
          child: Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(
              color: AppColors.teal500,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.teal50, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrailing(ChatConversation conversation) {
    return SizedBox(
      width: 44,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            conversation.time,
            maxLines: 1,
            softWrap: false,
            style: AppTextStyles.caption1.copyWith(
              color: AppColors.blueGray500,
            ),
          ),
          const SizedBox(height: 7),
          if (conversation.unreadCount > 0)
            Container(
              width: 18,
              height: 18,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.primary900,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${conversation.unreadCount}',
                style: AppTextStyles.caption2.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          else if (conversation.isRead)
            SvgPicture.asset(
              '${_iconPath}ion-checkmark-done-sharp.svg',
              width: 18,
              height: 18,
            ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 2,
      onTap: controller.changeNavigation,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.teal50,
      selectedItemColor: AppColors.primary900,
      unselectedItemColor: AppColors.blueGray400,
      selectedFontSize: 10,
      unselectedFontSize: 10,
      items: [
        _bottomBarItem('Home', 'Home Smile.svg', false),
        _bottomBarItem('Booking', 'Calendar Mark.svg', false),
        _bottomBarItem('Chat', 'Chat Round Unread.svg', true),
        _bottomBarItem('Profile', 'User.svg', false),
      ],
    );
  }

  BottomNavigationBarItem _bottomBarItem(
    String label,
    String icon,
    bool isActive,
  ) {
    final iconColor = isActive ? AppColors.primary900 : AppColors.blueGray400;

    return BottomNavigationBarItem(
      label: label,
      icon: SvgPicture.asset(
        '$_iconPath$icon',
        width: 20,
        height: 20,
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      ),
    );
  }
}
