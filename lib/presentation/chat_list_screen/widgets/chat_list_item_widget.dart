import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChatListItemWidget extends StatelessWidget {
  final Map<String, dynamic> chatData;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Function(DismissDirection)? onDismissed;

  const ChatListItemWidget({
    Key? key,
    required this.chatData,
    this.onTap,
    this.onLongPress,
    this.onDismissed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String name = chatData['name'] ?? 'Unknown';
    final String lastMessage = chatData['lastMessage'] ?? '';
    final String timestamp = chatData['timestamp'] ?? '';
    final int unreadCount = chatData['unreadCount'] ?? 0;
    final String avatarUrl = chatData['avatarUrl'] ?? '';
    final bool isOnline = chatData['isOnline'] ?? false;
    final bool isTyping = chatData['isTyping'] ?? false;
    final bool isEncrypted = chatData['isEncrypted'] ?? true;
    final bool isPinned = chatData['isPinned'] ?? false;
    final bool isMuted = chatData['isMuted'] ?? false;
    final String messageStatus = chatData['messageStatus'] ?? 'sent';

    return Dismissible(
      key: Key(chatData['id'].toString()),
      direction: DismissDirection.endToStart,
      onDismissed: onDismissed,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          color: AppTheme.errorColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomIconWidget(
              iconName: 'archive',
              color: Colors.white,
              size: 6.w,
            ),
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: 'volume_off',
              color: Colors.white,
              size: 6.w,
            ),
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: 'push_pin',
              color: Colors.white,
              size: 6.w,
            ),
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: 'delete',
              color: Colors.white,
              size: 6.w,
            ),
          ],
        ),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppTheme.shadowLight,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Avatar with online indicator
              Stack(
                children: [
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isEncrypted
                            ? AppTheme.successColor
                            : AppTheme.warningColor,
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: avatarUrl.isNotEmpty
                          ? CustomImageWidget(
                              imageUrl: avatarUrl,
                              width: 12.w,
                              height: 12.w,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              color:
                                  AppTheme.primaryLight.withValues(alpha: 0.1),
                              child: Center(
                                child: Text(
                                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: AppTheme.primaryLight,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            ),
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
                            color: Theme.of(context).cardColor,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: 3.w),

              // Chat content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and timestamp row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: unreadCount > 0
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isPinned) ...[
                                SizedBox(width: 1.w),
                                CustomIconWidget(
                                  iconName: 'push_pin',
                                  color: AppTheme.primaryLight,
                                  size: 4.w,
                                ),
                              ],
                              if (isMuted) ...[
                                SizedBox(width: 1.w),
                                CustomIconWidget(
                                  iconName: 'volume_off',
                                  color: AppTheme.textMediumEmphasisLight,
                                  size: 4.w,
                                ),
                              ],
                            ],
                          ),
                        ),
                        Text(
                          timestamp,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: unreadCount > 0
                                        ? AppTheme.primaryLight
                                        : AppTheme.textMediumEmphasisLight,
                                    fontWeight: unreadCount > 0
                                        ? FontWeight.w500
                                        : FontWeight.w400,
                                  ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),

                    // Last message and status row
                    Row(
                      children: [
                        // Message status icon
                        if (messageStatus != 'received') ...[
                          CustomIconWidget(
                            iconName: messageStatus == 'sent'
                                ? 'check'
                                : messageStatus == 'delivered'
                                    ? 'done_all'
                                    : 'done_all',
                            color: messageStatus == 'read'
                                ? AppTheme.primaryLight
                                : AppTheme.textMediumEmphasisLight,
                            size: 4.w,
                          ),
                          SizedBox(width: 1.w),
                        ],

                        // Last message text
                        Expanded(
                          child: Text(
                            isTyping ? 'Typing...' : lastMessage,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: isTyping
                                      ? AppTheme.primaryLight
                                      : unreadCount > 0
                                          ? AppTheme.textHighEmphasisLight
                                          : AppTheme.textMediumEmphasisLight,
                                  fontWeight: unreadCount > 0
                                      ? FontWeight.w500
                                      : FontWeight.w400,
                                  fontStyle: isTyping
                                      ? FontStyle.italic
                                      : FontStyle.normal,
                                ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),

                        // Unread count badge
                        if (unreadCount > 0)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.w,
                              vertical: 0.5.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 5.w,
                              minHeight: 2.5.h,
                            ),
                            child: Center(
                              child: Text(
                                unreadCount > 99
                                    ? '99+'
                                    : unreadCount.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
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
    );
  }
}
