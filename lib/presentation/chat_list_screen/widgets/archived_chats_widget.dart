import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ArchivedChatsWidget extends StatelessWidget {
  final int archivedCount;
  final VoidCallback onTap;

  const ArchivedChatsWidget({
    Key? key,
    required this.archivedCount,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (archivedCount == 0) return const SizedBox.shrink();

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
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
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: AppTheme.textMediumEmphasisLight.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'archive',
                  color: AppTheme.textMediumEmphasisLight,
                  size: 6.w,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Archived',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    '$archivedCount ${archivedCount == 1 ? 'chat' : 'chats'}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textMediumEmphasisLight,
                        ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.textMediumEmphasisLight,
              size: 5.w,
            ),
          ],
        ),
      ),
    );
  }
}
