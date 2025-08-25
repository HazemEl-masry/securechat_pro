import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MessageContextMenuWidget extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isCurrentUser;
  final VoidCallback? onReply;
  final VoidCallback? onForward;
  final VoidCallback? onCopy;
  final VoidCallback? onDelete;
  final VoidCallback? onInfo;
  final VoidCallback? onStar;

  const MessageContextMenuWidget({
    Key? key,
    required this.message,
    required this.isCurrentUser,
    this.onReply,
    this.onForward,
    this.onCopy,
    this.onDelete,
    this.onInfo,
    this.onStar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final messageType = message['type'] as String? ?? 'text';
    final isStarred = message['isStarred'] as bool? ?? false;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(3.w),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMenuHeader(),
          _buildMenuActions(messageType, isStarred),
        ],
      ),
    );
  }

  Widget _buildMenuHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(3.w)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 4.w,
            child: CustomImageWidget(
              imageUrl: message['senderAvatar'] as String? ??
                  'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
              width: 8.w,
              height: 8.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message['senderName'] as String? ?? 'Unknown',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  _formatTimestamp(
                      message['timestamp'] as DateTime? ?? DateTime.now()),
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textMediumEmphasisLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuActions(String messageType, bool isStarred) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.w),
      child: Column(
        children: [
          _buildMenuAction(
            icon: 'reply',
            label: 'Reply',
            onTap: onReply,
          ),
          if (messageType == 'text')
            _buildMenuAction(
              icon: 'content_copy',
              label: 'Copy',
              onTap: onCopy,
            ),
          _buildMenuAction(
            icon: 'forward',
            label: 'Forward',
            onTap: onForward,
          ),
          _buildMenuAction(
            icon: isStarred ? 'star' : 'star_border',
            label: isStarred ? 'Unstar' : 'Star',
            onTap: onStar,
            iconColor: isStarred ? AppTheme.warningColor : null,
          ),
          _buildMenuAction(
            icon: 'info',
            label: 'Info',
            onTap: onInfo,
          ),
          if (isCurrentUser)
            _buildMenuAction(
              icon: 'delete',
              label: 'Delete',
              onTap: onDelete,
              iconColor: AppTheme.errorColor,
              textColor: AppTheme.errorColor,
            ),
        ],
      ),
    );
  }

  Widget _buildMenuAction({
    required String icon,
    required String label,
    VoidCallback? onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.w),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: iconColor ?? AppTheme.textMediumEmphasisLight,
              size: 5.w,
            ),
            SizedBox(width: 4.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: textColor ?? AppTheme.textHighEmphasisLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate =
        DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (messageDate == today) {
      return 'Today ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == today.subtract(Duration(days: 1))) {
      return 'Yesterday ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}
