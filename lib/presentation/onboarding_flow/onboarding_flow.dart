import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/animated_lock_widget.dart';
import './widgets/onboarding_page_widget.dart';
import './widgets/page_indicator_widget.dart';
import './widgets/privacy_toggle_widget.dart';
import './widgets/video_preview_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({Key? key}) : super(key: key);

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 3;

  // Mock data for onboarding content
  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "End-to-End Encryption",
      "description":
          "Your messages are secured with military-grade encryption. Only you and your recipient can read them - not even we can access your conversations.",
      "image":
          "https://images.unsplash.com/photo-1563013544-824ae1b704d3?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "hasCustomIcon": true,
    },
    {
      "title": "Advanced Privacy Controls",
      "description":
          "Take complete control of your digital footprint. Hide your online status, disable read receipts, and communicate in complete stealth mode.",
      "image":
          "https://images.unsplash.com/photo-1555949963-aa79dcee981c?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "hasCustomIcon": false,
    },
    {
      "title": "Secure Calling & Media",
      "description":
          "Make encrypted voice and video calls with crystal clear quality. Share photos, videos, and documents with complete privacy protection.",
      "image":
          "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "hasCustomIcon": false,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      HapticFeedback.lightImpact();
    } else {
      _navigateToRegistration();
    }
  }

  void _skipOnboarding() {
    _navigateToRegistration();
    HapticFeedback.mediumImpact();
  }

  void _navigateToRegistration() {
    Navigator.pushReplacementNamed(context, '/registration-screen');
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    HapticFeedback.selectionClick();
  }

  Widget _buildFirstPageContent() {
    return Column(
      children: [
        // Messaging bubbles illustration
        Container(
          width: 80.w,
          height: 25.h,
          child: Stack(
            children: [
              // Received message bubble
              Positioned(
                left: 0,
                top: 5.h,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(4),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.lightTheme.colorScheme.shadow,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'lock',
                        color: AppTheme.successColor,
                        size: 4.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Message encrypted',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Sent message bubble
              Positioned(
                right: 0,
                top: 12.h,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(4),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.lightTheme.colorScheme.shadow,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Secure & Private',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      CustomIconWidget(
                        iconName: 'verified',
                        color: Colors.white,
                        size: 4.w,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSecondPageContent() {
    return Column(
      children: [
        SizedBox(height: 2.h),
        PrivacyToggleWidget(
          title: "Ghost Mode",
          iconName: "visibility_off",
          initialValue: true,
        ),
        PrivacyToggleWidget(
          title: "Hide Online Status",
          iconName: "schedule",
          initialValue: false,
        ),
        PrivacyToggleWidget(
          title: "Disable Read Receipts",
          iconName: "done_all",
          initialValue: true,
        ),
        PrivacyToggleWidget(
          title: "Anonymous Story Viewing",
          iconName: "remove_red_eye",
          initialValue: false,
        ),
      ],
    );
  }

  Widget _buildThirdPageContent() {
    return Column(
      children: [
        SizedBox(height: 2.h),
        VideoPreviewWidget(),
        SizedBox(height: 3.h),

        // Feature highlights
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildFeatureItem("voice_chat", "Voice Calls"),
            _buildFeatureItem("videocam", "Video Calls"),
            _buildFeatureItem("photo_library", "Media Share"),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureItem(String iconName, String label) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 6.w,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Main content area
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _totalPages,
                itemBuilder: (context, index) {
                  final data = _onboardingData[index];

                  return OnboardingPageWidget(
                    title: data["title"] as String,
                    description: data["description"] as String,
                    imagePath: data["image"] as String,
                    customIcon: index == 0 && data["hasCustomIcon"] == true
                        ? AnimatedLockWidget()
                        : null,
                    onNext: _nextPage,
                    onSkip: _skipOnboarding,
                    isLastPage: index == _totalPages - 1,
                  );
                },
              ),
            ),

            // Additional content based on page
            Container(
              height: 25.h,
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: _currentPage == 0
                  ? _buildFirstPageContent()
                  : _currentPage == 1
                      ? _buildSecondPageContent()
                      : _buildThirdPageContent(),
            ),

            // Page indicators
            Container(
              padding: EdgeInsets.symmetric(vertical: 3.h),
              child: PageIndicatorWidget(
                currentPage: _currentPage,
                totalPages: _totalPages,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
