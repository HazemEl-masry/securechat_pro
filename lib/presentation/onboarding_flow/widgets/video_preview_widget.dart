import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VideoPreviewWidget extends StatefulWidget {
  const VideoPreviewWidget({Key? key}) : super(key: key);

  @override
  State<VideoPreviewWidget> createState() => _VideoPreviewWidgetState();
}

class _VideoPreviewWidgetState extends State<VideoPreviewWidget>
    with TickerProviderStateMixin {
  late AnimationController _rippleController;
  late AnimationController _playButtonController;
  late Animation<double> _rippleAnimation;
  late Animation<double> _playButtonAnimation;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();

    _rippleController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _playButtonController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));

    _playButtonAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _playButtonController,
      curve: Curves.easeInOut,
    ));

    _rippleController.repeat();
  }

  @override
  void dispose() {
    _rippleController.dispose();
    _playButtonController.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    _playButtonController.forward().then((_) {
      _playButtonController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Video thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CustomImageWidget(
              imageUrl:
                  "https://images.unsplash.com/photo-1556075798-4825dfaaf498?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
              width: 70.w,
              height: 40.w,
              fit: BoxFit.cover,
            ),
          ),

          // Dark overlay
          Container(
            width: 70.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
            ),
          ),

          // Ripple effect
          if (!_isPlaying)
            AnimatedBuilder(
              animation: _rippleAnimation,
              builder: (context, child) {
                return Container(
                  width: 20.w * (1 + _rippleAnimation.value * 0.5),
                  height: 20.w * (1 + _rippleAnimation.value * 0.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white
                          .withValues(alpha: 1 - _rippleAnimation.value),
                      width: 2,
                    ),
                  ),
                );
              },
            ),

          // Play button
          AnimatedBuilder(
            animation: _playButtonAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _playButtonAnimation.value,
                child: GestureDetector(
                  onTap: _togglePlay,
                  child: Container(
                    width: 15.w,
                    height: 15.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CustomIconWidget(
                      iconName: _isPlaying ? 'pause' : 'play_arrow',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 8.w,
                    ),
                  ),
                ),
              );
            },
          ),

          // Secure call indicator
          Positioned(
            top: 3.w,
            right: 3.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
              decoration: BoxDecoration(
                color: AppTheme.successColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'security',
                    color: Colors.white,
                    size: 3.w,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'Secure',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
