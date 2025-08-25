import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BottomNavigationWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigationWidget({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 8.h,
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context: context,
                index: 0,
                iconName: 'chat',
                label: 'Chats',
                isActive: currentIndex == 0,
              ),
              _buildNavItem(
                context: context,
                index: 1,
                iconName: 'radio_button_checked',
                label: 'Status',
                isActive: currentIndex == 1,
              ),
              _buildNavItem(
                context: context,
                index: 2,
                iconName: 'call',
                label: 'Calls',
                isActive: currentIndex == 2,
              ),
              _buildNavItem(
                context: context,
                index: 3,
                iconName: 'settings',
                label: 'Settings',
                isActive: currentIndex == 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required String iconName,
    required String label,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isActive
              ? AppTheme.primaryLight.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: isActive
                  ? AppTheme.primaryLight
                  : AppTheme.textMediumEmphasisLight,
              size: 6.w,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isActive
                        ? AppTheme.primaryLight
                        : AppTheme.textMediumEmphasisLight,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
