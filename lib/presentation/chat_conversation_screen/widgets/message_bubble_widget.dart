import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MessageBubbleWidget extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isCurrentUser;
  final VoidCallback? onReply;
  final VoidCallback? onReact;
  final VoidCallback? onLongPress;

  const MessageBubbleWidget({
    Key? key,
    required this.message,
    required this.isCurrentUser,
    this.onReply,
    this.onReact,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final messageType = message['type'] as String? ?? 'text';
    final timestamp = message['timestamp'] as DateTime? ?? DateTime.now();
    final isDelivered = message['isDelivered'] as bool? ?? false;
    final isRead = message['isRead'] as bool? ?? false;
    final reactions = message['reactions'] as List<dynamic>? ?? [];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isCurrentUser) ...[
            CircleAvatar(
              radius: 2.5.w,
              child: CustomImageWidget(
                imageUrl: message['senderAvatar'] as String? ??
                    'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
                width: 5.w,
                height: 5.w,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 2.w),
          ],
          Flexible(
            child: GestureDetector(
              onTap: onReact,
              onLongPress: onLongPress,
              child: Container(
                constraints: BoxConstraints(maxWidth: 70.w),
                decoration: BoxDecoration(
                  color: isCurrentUser
                      ? AppTheme.lightTheme.primaryColor
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.w),
                    topRight: Radius.circular(4.w),
                    bottomLeft: Radius.circular(isCurrentUser ? 4.w : 1.w),
                    bottomRight: Radius.circular(isCurrentUser ? 1.w : 4.w),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.shadowLight,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (message['replyTo'] != null) _buildReplyPreview(),
                    _buildMessageContent(messageType),
                    _buildMessageFooter(timestamp, isDelivered, isRead),
                    if (reactions.isNotEmpty) _buildReactions(reactions),
                  ],
                ),
              ),
            ),
          ),
          if (isCurrentUser) SizedBox(width: 2.w),
        ],
      ),
    );
  }

  Widget _buildReplyPreview() {
    final replyTo = message['replyTo'] as Map<String, dynamic>;
    return Container(
      margin: EdgeInsets.all(2.w),
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(2.w),
        border: Border(
          left: BorderSide(
            color: AppTheme.accentColor,
            width: 0.5.w,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            replyTo['senderName'] as String? ?? 'Unknown',
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: AppTheme.accentColor,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 0.5.h),
          Text(
            replyTo['content'] as String? ?? '',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: isCurrentUser
                  ? Colors.white.withValues(alpha: 0.8)
                  : AppTheme.textMediumEmphasisLight,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageContent(String messageType) {
    switch (messageType) {
      case 'text':
        return _buildTextMessage();
      case 'image':
        return _buildImageMessage();
      case 'voice':
        return _buildVoiceMessage();
      case 'document':
        return _buildDocumentMessage();
      default:
        return _buildTextMessage();
    }
  }

  Widget _buildTextMessage() {
    return Padding(
      padding: EdgeInsets.all(3.w),
      child: Text(
        message['content'] as String? ?? '',
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          color: isCurrentUser ? Colors.white : AppTheme.textHighEmphasisLight,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildImageMessage() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
          child: CustomImageWidget(
            imageUrl: message['imageUrl'] as String? ?? '',
            width: double.infinity,
            height: 40.w,
            fit: BoxFit.cover,
          ),
        ),
        if (message['caption'] != null &&
            (message['caption'] as String).isNotEmpty)
          Padding(
            padding: EdgeInsets.all(3.w),
            child: Text(
              message['caption'] as String,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: isCurrentUser
                    ? Colors.white
                    : AppTheme.textHighEmphasisLight,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildVoiceMessage() {
    final duration = message['duration'] as int? ?? 0;
    final isPlaying = message['isPlaying'] as bool? ?? false;

    return Padding(
      padding: EdgeInsets.all(3.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              // Handle voice message play/pause
            },
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: isCurrentUser
                    ? Colors.white.withValues(alpha: 0.2)
                    : AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: isPlaying ? 'pause' : 'play_arrow',
                color: isCurrentUser
                    ? Colors.white
                    : AppTheme.lightTheme.primaryColor,
                size: 5.w,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 1.w,
                  decoration: BoxDecoration(
                    color: isCurrentUser
                        ? Colors.white.withValues(alpha: 0.3)
                        : AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(0.5.w),
                  ),
                  child: LinearProgressIndicator(
                    value: 0.3,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isCurrentUser
                          ? Colors.white
                          : AppTheme.lightTheme.primaryColor,
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  '${duration ~/ 60}:${(duration % 60).toString().padLeft(2, '0')}',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: isCurrentUser
                        ? Colors.white.withValues(alpha: 0.8)
                        : AppTheme.textMediumEmphasisLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentMessage() {
    final fileName = message['fileName'] as String? ?? 'Document';
    final fileSize = message['fileSize'] as String? ?? '0 KB';

    return Padding(
      padding: EdgeInsets.all(3.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: isCurrentUser
                  ? Colors.white.withValues(alpha: 0.2)
                  : AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: CustomIconWidget(
              iconName: 'description',
              color: isCurrentUser
                  ? Colors.white
                  : AppTheme.lightTheme.primaryColor,
              size: 6.w,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: isCurrentUser
                        ? Colors.white
                        : AppTheme.textHighEmphasisLight,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  fileSize,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: isCurrentUser
                        ? Colors.white.withValues(alpha: 0.8)
                        : AppTheme.textMediumEmphasisLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageFooter(
      DateTime timestamp, bool isDelivered, bool isRead) {
    return Padding(
      padding: EdgeInsets.fromLTRB(3.w, 0, 3.w, 2.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}',
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: isCurrentUser
                  ? Colors.white.withValues(alpha: 0.7)
                  : AppTheme.textDisabledLight,
              fontSize: 10.sp,
            ),
          ),
          if (isCurrentUser) ...[
            SizedBox(width: 1.w),
            CustomIconWidget(
              iconName:
                  isRead ? 'done_all' : (isDelivered ? 'done' : 'schedule'),
              color: isRead
                  ? AppTheme.accentColor
                  : (isCurrentUser
                      ? Colors.white.withValues(alpha: 0.7)
                      : AppTheme.textDisabledLight),
              size: 3.w,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReactions(List<dynamic> reactions) {
    return Container(
      margin: EdgeInsets.fromLTRB(3.w, 0, 3.w, 2.w),
      child: Wrap(
        spacing: 1.w,
        children: reactions.map((reaction) {
          final emoji = reaction['emoji'] as String? ?? '❤️';
          final count = reaction['count'] as int? ?? 1;

          return Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
            decoration: BoxDecoration(
              color: isCurrentUser
                  ? Colors.white.withValues(alpha: 0.2)
                  : AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(3.w),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  emoji,
                  style: TextStyle(fontSize: 12.sp),
                ),
                if (count > 1) ...[
                  SizedBox(width: 1.w),
                  Text(
                    count.toString(),
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: isCurrentUser
                          ? Colors.white
                          : AppTheme.textHighEmphasisLight,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
