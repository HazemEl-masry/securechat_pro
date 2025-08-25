import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isInitialized = false;
  String _loadingText = 'Initializing SecureChat Pro...';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Initialize encryption keys
      setState(() => _loadingText = 'Setting up encryption...');
      await Future.delayed(const Duration(milliseconds: 800));

      // Initialize WebSocket connections
      setState(() => _loadingText = 'Connecting to secure servers...');
      await Future.delayed(const Duration(milliseconds: 600));

      // Load cached data
      setState(() => _loadingText = 'Loading your data...');
      await Future.delayed(const Duration(milliseconds: 500));

      // Check authentication status
      setState(() => _loadingText = 'Verifying authentication...');
      await Future.delayed(const Duration(milliseconds: 400));

      setState(() => _isInitialized = true);

      // Navigate based on authentication status
      await Future.delayed(const Duration(milliseconds: 300));
      _navigateToNextScreen();
    } catch (e) {
      // Handle initialization errors
      _showRetryOption();
    }
  }

  void _navigateToNextScreen() {
    // Mock authentication check - in real app, check stored tokens
    final bool isAuthenticated = false; // Mock value
    final bool isFirstTime = true; // Mock value

    if (isAuthenticated) {
      Navigator.pushReplacementNamed(context, '/chat-list-screen');
    } else if (isFirstTime) {
      Navigator.pushReplacementNamed(context, '/onboarding-flow');
    } else {
      Navigator.pushReplacementNamed(context, '/login-screen');
    }
  }

  void _showRetryOption() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Connection Error',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.errorColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Unable to initialize secure connection. Please check your internet connection and try again.',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _isInitialized = false;
                _loadingText = 'Retrying connection...';
              });
              _initializeApp();
            },
            child: Text(
              'Retry',
              style: TextStyle(
                color: AppTheme.primaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryLight,
              AppTheme.primaryLight.withValues(alpha: 0.8),
              AppTheme.accentColor.withValues(alpha: 0.6),
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo Section
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // App Logo
                              Container(
                                width: 25.w,
                                height: 25.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: CustomIconWidget(
                                    iconName: 'security',
                                    color: AppTheme.primaryLight,
                                    size: 12.w,
                                  ),
                                ),
                              ),
                              SizedBox(height: 3.h),
                              // App Name
                              Text(
                                'SecureChat Pro',
                                style: AppTheme
                                    .lightTheme.textTheme.headlineMedium
                                    ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              // Tagline
                              Text(
                                'End-to-End Encrypted Messaging',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Loading Section
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Loading Indicator
                          SizedBox(
                            width: 8.w,
                            height: 8.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          // Loading Text
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              _loadingText,
                              key: ValueKey(_loadingText),
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Bottom Section
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.h),
                      child: Column(
                        children: [
                          // Security Badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 4.w,
                              vertical: 1.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomIconWidget(
                                  iconName: 'verified_user',
                                  color: Colors.white,
                                  size: 4.w,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  'Military-Grade Encryption',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 2.h),
                          // Version Info
                          Text(
                            'Version 1.0.0',
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
