import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onStartChat;

  const EmptyStateWidget({
    Key? key,
    required this.onStartChat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppTheme.primaryLight.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'chat_bubble_outline',
                  color: AppTheme.primaryLight,
                  size: 20.w,
                ),
              ),
            ),
            SizedBox(height: 4.h),

            // Title
            Text(
              'Start Your First Conversation',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textHighEmphasisLight,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),

            // Description
            Text(
              'Connect with friends and family through secure, encrypted messaging. Your privacy is our priority.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textMediumEmphasisLight,
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),

            // CTA Button
            ElevatedButton.icon(
              onPressed: onStartChat,
              icon: CustomIconWidget(
                iconName: 'add',
                color: Colors.white,
                size: 5.w,
              ),
              label: Text(
                'Start New Chat',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            SizedBox(height: 2.h),

            // Secondary action
            TextButton(
              onPressed: () {
                // Navigate to contacts or invite friends
              },
              child: Text(
                'Invite Friends',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppTheme.primaryLight,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
