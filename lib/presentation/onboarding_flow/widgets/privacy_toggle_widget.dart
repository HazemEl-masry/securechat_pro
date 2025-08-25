import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PrivacyToggleWidget extends StatefulWidget {
  final String title;
  final String iconName;
  final bool initialValue;

  const PrivacyToggleWidget({
    Key? key,
    required this.title,
    required this.iconName,
    this.initialValue = false,
  }) : super(key: key);

  @override
  State<PrivacyToggleWidget> createState() => _PrivacyToggleWidgetState();
}

class _PrivacyToggleWidgetState extends State<PrivacyToggleWidget>
    with SingleTickerProviderStateMixin {
  late bool _isEnabled;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _isEnabled = widget.initialValue;

    _animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleSwitch() {
    setState(() {
      _isEnabled = !_isEnabled;
    });

    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 1.h),
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: _isEnabled
                  ? AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1)
                  : AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isEnabled
                    ? AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.3)
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: _isEnabled
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: widget.iconName,
                    color: _isEnabled
                        ? Colors.white
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    widget.title,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: _isEnabled
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight:
                          _isEnabled ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _toggleSwitch,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    width: 12.w,
                    height: 3.h,
                    decoration: BoxDecoration(
                      color: _isEnabled
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2.h),
                    ),
                    child: AnimatedAlign(
                      duration: Duration(milliseconds: 200),
                      alignment: _isEnabled
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        width: 2.5.h,
                        height: 2.5.h,
                        margin: EdgeInsets.all(0.25.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.lightTheme.colorScheme.shadow,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
