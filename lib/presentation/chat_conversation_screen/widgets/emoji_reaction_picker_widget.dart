import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmojiReactionPickerWidget extends StatelessWidget {
  final Function(String) onEmojiSelected;
  final VoidCallback? onClose;

  const EmojiReactionPickerWidget({
    Key? key,
    required this.onEmojiSelected,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final quickReactions = ['❤️', '😂', '😮', '😢', '😡', '👍'];
    final allEmojis = [
      // Smileys & Emotion
      '😀', '😃', '😄', '😁', '😆', '😅', '🤣', '😂', '🙂', '🙃',
      '😉', '😊', '😇', '🥰', '😍', '🤩', '😘', '😗', '☺️', '😚',
      '😙', '🥲', '😋', '😛', '😜', '🤪', '😝', '🤑', '🤗', '🤭',
      '🤫', '🤔', '🤐', '🤨', '😐', '😑', '😶', '😏', '😒', '🙄',
      '😬', '🤥', '😔', '😪', '🤤', '😴', '😷', '🤒', '🤕', '🤢',
      '🤮', '🤧', '🥵', '🥶', '🥴', '😵', '🤯', '🤠', '🥳', '🥸',
      '😎', '🤓', '🧐', '😕', '😟', '🙁', '☹️', '😮', '😯', '😲',
      '😳', '🥺', '😦', '😧', '😨', '😰', '😥', '😢', '😭', '😱',
      '😖', '😣', '😞', '😓', '😩', '😫', '🥱', '😤', '😡', '😠',
      '🤬', '😈', '👿', '💀', '☠️', '💩', '🤡', '👹', '👺', '👻',
      '👽', '👾', '🤖', '😺', '😸', '😹', '😻', '😼', '😽', '🙀',
      '😿', '😾',
      // Hand gestures
      '👍', '👎', '👌', '🤌', '🤏', '✌️', '🤞', '🤟', '🤘', '🤙',
      '👈', '👉', '👆', '🖕', '👇', '☝️', '👋', '🤚', '🖐️', '✋',
      '🖖', '👏', '🙌', '🤲', '🤝', '🙏', '✍️', '💅', '🤳', '💪',
      // Hearts & Symbols
      '❤️', '🧡', '💛', '💚', '💙', '💜', '🖤', '🤍', '🤎', '💔',
      '❣️', '💕', '💞', '💓', '💗', '💖', '💘', '💝', '💟', '♥️',
      '💯', '💢', '💥', '💫', '💦', '💨', '🕳️', '💬', '👁️‍🗨️', '🗨️',
      '🗯️', '💭', '💤', '👋', '🤚', '🖐️', '✋', '🖖', '👌', '🤌',
      '🤏', '✌️', '🤞', '🤟', '🤘', '🤙', '👈', '👉', '👆', '🖕',
      '👇', '☝️', '👍', '👎', '👊', '✊', '🤛', '🤜', '👏', '🙌',
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildQuickReactions(quickReactions),
          _buildAllEmojis(allEmojis),
        ],
      ),
    );
  }

  Widget _buildQuickReactions(List<String> quickReactions) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: quickReactions.map((emoji) {
          return GestureDetector(
            onTap: () => onEmojiSelected(emoji),
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.scaffoldBackgroundColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.lightTheme.dividerColor,
                  width: 0.5,
                ),
              ),
              child: Text(
                emoji,
                style: TextStyle(fontSize: 20.sp),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAllEmojis(List<String> allEmojis) {
    return Container(
      height: 40.h,
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'All Emojis',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: onClose,
                child: Container(
                  padding: EdgeInsets.all(1.w),
                  child: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.textMediumEmphasisLight,
                    size: 5.w,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                crossAxisSpacing: 1.w,
                mainAxisSpacing: 1.h,
              ),
              itemCount: allEmojis.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => onEmojiSelected(allEmojis[index]),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                    child: Center(
                      child: Text(
                        allEmojis[index],
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
