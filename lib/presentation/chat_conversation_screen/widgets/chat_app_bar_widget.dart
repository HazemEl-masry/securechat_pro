import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChatAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final Map<String, dynamic> contact;
  final VoidCallback? onBackPressed;
  final VoidCallback? onCallPressed;
  final VoidCallback? onVideoCallPressed;
  final VoidCallback? onMorePressed;

  const ChatAppBarWidget({
    Key? key,
    required this.contact,
    this.onBackPressed,
    this.onCallPressed,
    this.onVideoCallPressed,
    this.onMorePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final contactName = contact['name'] as String? ?? 'Unknown';
    final contactAvatar = contact['avatar'] as String? ??
        'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png';
    final isOnline = contact['isOnline'] as bool? ?? false;
    final lastSeen = contact['lastSeen'] as DateTime?;
    final isTyping = contact['isTyping'] as bool? ?? false;

    return AppBar(
      elevation: 2,
      shadowColor: AppTheme.shadowLight,
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      leading: GestureDetector(
        onTap: onBackPressed ?? () => Navigator.pop(context),
        child: Container(
          padding: EdgeInsets.all(3.w),
          child: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.textHighEmphasisLight,
            size: 6.w,
          ),
        ),
      ),
      title: GestureDetector(
        onTap: () {
          // Navigate to contact profile
        },
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 5.w,
                  child: CustomImageWidget(
                    imageUrl: contactAvatar,
                    width: 10.w,
                    height: 10.w,
                    fit: BoxFit.cover,
                  ),
                ),
                if (isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 3.w,
                      height: 3.w,
                      decoration: BoxDecoration(
                        color: AppTheme.successColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.lightTheme.scaffoldBackgroundColor,
                          width: 0.5.w,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contactName,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textHighEmphasisLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    _getStatusText(isOnline, isTyping, lastSeen),
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: isTyping
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.textMediumEmphasisLight,
                      fontSize: 11.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        GestureDetector(
          onTap: onCallPressed,
          child: Container(
            padding: EdgeInsets.all(3.w),
            child: CustomIconWidget(
              iconName: 'call',
              color: AppTheme.textHighEmphasisLight,
              size: 5.w,
            ),
          ),
        ),
        GestureDetector(
          onTap: onVideoCallPressed,
          child: Container(
            padding: EdgeInsets.all(3.w),
            child: CustomIconWidget(
              iconName: 'videocam',
              color: AppTheme.textHighEmphasisLight,
              size: 5.w,
            ),
          ),
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'view_contact':
                // Navigate to contact info
                break;
              case 'media':
                // Navigate to shared media
                break;
              case 'search':
                // Open search in chat
                break;
              case 'mute':
                // Toggle mute notifications
                break;
              case 'wallpaper':
                // Change chat wallpaper
                break;
              case 'clear_chat':
                // Clear chat history
                break;
              case 'block':
                // Block contact
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'view_contact',
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'person',
                    color: AppTheme.textMediumEmphasisLight,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'View contact',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'media',
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'photo_library',
                    color: AppTheme.textMediumEmphasisLight,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Media, links, and docs',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'search',
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'search',
                    color: AppTheme.textMediumEmphasisLight,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Search',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'mute',
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'notifications_off',
                    color: AppTheme.textMediumEmphasisLight,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Mute notifications',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'wallpaper',
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'wallpaper',
                    color: AppTheme.textMediumEmphasisLight,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Wallpaper',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'clear_chat',
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'delete_sweep',
                    color: AppTheme.textMediumEmphasisLight,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Clear chat',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'block',
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'block',
                    color: AppTheme.errorColor,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Block',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.errorColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
          icon: CustomIconWidget(
            iconName: 'more_vert',
            color: AppTheme.textHighEmphasisLight,
            size: 5.w,
          ),
        ),
      ],
    );
  }

  String _getStatusText(bool isOnline, bool isTyping, DateTime? lastSeen) {
    if (isTyping) {
      return 'typing...';
    }

    if (isOnline) {
      return 'online';
    }

    if (lastSeen != null) {
      final now = DateTime.now();
      final difference = now.difference(lastSeen);

      if (difference.inMinutes < 1) {
        return 'last seen just now';
      } else if (difference.inHours < 1) {
        return 'last seen ${difference.inMinutes}m ago';
      } else if (difference.inDays < 1) {
        return 'last seen ${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return 'last seen ${difference.inDays}d ago';
      } else {
        return 'last seen ${lastSeen.day}/${lastSeen.month}/${lastSeen.year}';
      }
    }

    return 'offline';
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
