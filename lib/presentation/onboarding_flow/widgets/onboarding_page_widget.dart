import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OnboardingPageWidget extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final Widget? customIcon;
  final VoidCallback? onNext;
  final VoidCallback? onSkip;
  final bool isLastPage;

  const OnboardingPageWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.imagePath,
    this.customIcon,
    this.onNext,
    this.onSkip,
    this.isLastPage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 100.h,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      child: Column(
        children: [
          // Skip button
          if (!isLastPage)
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: onSkip,
                child: Text(
                  'Skip',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
          else
            SizedBox(height: 6.h),

          // Hero illustration
          Expanded(
            flex: 3,
            child: Container(
              width: 80.w,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background gradient circle
                  Container(
                    width: 70.w,
                    height: 70.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1),
                          AppTheme.lightTheme.colorScheme.tertiary
                              .withValues(alpha: 0.1),
                        ],
                      ),
                    ),
                  ),
                  // Main image
                  CustomImageWidget(
                    imageUrl: imagePath,
                    width: 60.w,
                    height: 60.w,
                    fit: BoxFit.contain,
                  ),
                  // Custom animated icon overlay
                  if (customIcon != null)
                    Positioned(
                      top: 15.w,
                      right: 15.w,
                      child: Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.lightTheme.colorScheme.shadow,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: customIcon!,
                      ),
                    ),
                ],
              ),
            ),
          ),

          SizedBox(height: 4.h),

          // Content section
          Expanded(
            flex: 2,
            child: Column(
              children: [
                // Title
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 2.h),

                // Description
                Text(
                  description,
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                Spacer(),

                // Action button
                Container(
                  width: 80.w,
                  height: 6.h,
                  child: ElevatedButton(
                    onPressed: onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shadowColor: AppTheme.lightTheme.colorScheme.shadow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isLastPage ? 'Get Started' : 'Next',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 2.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
