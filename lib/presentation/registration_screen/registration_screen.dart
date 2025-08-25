import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _acceptTerms = false;
  bool _isUsernameAvailable = true;
  bool _isCheckingUsername = false;
  String _selectedCountryCode = '+1';
  String _passwordStrength = '';
  Color _passwordStrengthColor = Colors.grey;

  final List<Map<String, String>> _countryCodes = [
    {'code': '+1', 'flag': '🇺🇸', 'country': 'US'},
    {'code': '+44', 'flag': '🇬🇧', 'country': 'UK'},
    {'code': '+91', 'flag': '🇮🇳', 'country': 'IN'},
    {'code': '+971', 'flag': '🇦🇪', 'country': 'UAE'},
    {'code': '+966', 'flag': '🇸🇦', 'country': 'SA'},
    {'code': '+20', 'flag': '🇪🇬', 'country': 'EG'},
  ];

  @override
  void dispose() {
    _phoneController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _checkPasswordStrength(String password) {
    if (password.isEmpty) {
      setState(() {
        _passwordStrength = '';
        _passwordStrengthColor = Colors.grey;
      });
      return;
    }

    int score = 0;
    if (password.length >= 8) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    setState(() {
      switch (score) {
        case 0:
        case 1:
          _passwordStrength = 'Weak';
          _passwordStrengthColor = AppTheme.errorColor;
          break;
        case 2:
        case 3:
          _passwordStrength = 'Medium';
          _passwordStrengthColor = AppTheme.warningColor;
          break;
        case 4:
        case 5:
          _passwordStrength = 'Strong';
          _passwordStrengthColor = AppTheme.successColor;
          break;
      }
    });
  }

  Future<void> _checkUsernameAvailability(String username) async {
    if (username.length < 3) return;

    setState(() => _isCheckingUsername = true);

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock unavailable usernames
    final unavailableUsernames = [
      'admin',
      'user',
      'test',
      'john',
      'jane',
      'secure'
    ];

    setState(() {
      _isUsernameAvailable =
          !unavailableUsernames.contains(username.toLowerCase());
      _isCheckingUsername = false;
    });
  }

  bool _isFormValid() {
    return _formKey.currentState?.validate() == true &&
        _acceptTerms &&
        _isUsernameAvailable &&
        _passwordStrength.isNotEmpty;
  }

  Future<void> _handleRegistration() async {
    if (!_isFormValid()) return;

    setState(() => _isLoading = true);

    try {
      // Simulate registration API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock registration failure for specific phone numbers
      if (_phoneController.text == '1234567890') {
        throw Exception('Phone number already registered');
      }

      // Success - trigger haptic feedback
      HapticFeedback.lightImpact();

      // Navigate to SMS verification (mock navigation)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration successful! SMS verification sent.'),
            backgroundColor: AppTheme.successColor,
          ),
        );

        // Navigate to chat list screen after successful registration
        Navigator.pushReplacementNamed(context, '/chat-list-screen');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showPrivacyInfo() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Privacy & Data Protection',
              style: AppTheme.lightTheme.textTheme.headlineSmall,
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  '''SecureChat Pro is committed to protecting your privacy and ensuring the security of your personal information.

Data Collection:
• Phone number for account verification
• Username for identification
• Profile information you choose to share

Security Measures:
• End-to-end encryption for all messages
• Secure storage of credentials
• No message content stored on servers
• Advanced privacy controls

Your Rights:
• Delete your account anytime
• Control who can see your information
• Export your data
• Opt-out of optional features

We never sell your data to third parties and only use it to provide you with the best secure messaging experience.''',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Got it'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 6.h),

                // App Logo
                Container(
                  width: 25.w,
                  height: 25.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryLight,
                        AppTheme.accentColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryLight.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'lock',
                      color: Colors.white,
                      size: 12.w,
                    ),
                  ),
                ),

                SizedBox(height: 4.h),

                Text(
                  'Create Account',
                  style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),

                SizedBox(height: 1.h),

                Text(
                  'Join SecureChat Pro for private messaging',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textMediumEmphasisLight,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 4.h),

                // Phone Number Input
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Phone Number',
                      style: AppTheme.lightTheme.textTheme.labelLarge,
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        // Country Code Picker
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                height: 40.h,
                                padding: EdgeInsets.all(4.w),
                                child: Column(
                                  children: [
                                    Text(
                                      'Select Country',
                                      style: AppTheme
                                          .lightTheme.textTheme.titleLarge,
                                    ),
                                    SizedBox(height: 2.h),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: _countryCodes.length,
                                        itemBuilder: (context, index) {
                                          final country = _countryCodes[index];
                                          return ListTile(
                                            leading: Text(
                                              country['flag']!,
                                              style: TextStyle(fontSize: 6.w),
                                            ),
                                            title: Text(country['country']!),
                                            trailing: Text(country['code']!),
                                            onTap: () {
                                              setState(() {
                                                _selectedCountryCode =
                                                    country['code']!;
                                              });
                                              Navigator.pop(context);
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 3.h),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _countryCodes.firstWhere(
                                    (c) => c['code'] == _selectedCountryCode,
                                  )['flag']!,
                                  style: TextStyle(fontSize: 5.w),
                                ),
                                SizedBox(width: 2.w),
                                Text(_selectedCountryCode),
                                SizedBox(width: 1.w),
                                CustomIconWidget(
                                  iconName: 'keyboard_arrow_down',
                                  size: 5.w,
                                  color: Colors.grey[600]!,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              hintText: 'Phone number',
                              prefixIcon: Icon(Icons.phone),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Phone number is required';
                              }
                              if (value.length < 10) {
                                return 'Enter a valid phone number';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 3.h),

                // Username Input
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Username',
                      style: AppTheme.lightTheme.textTheme.labelLarge,
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: 'Choose a unique username',
                        prefixIcon: Icon(Icons.person),
                        suffixIcon: _isCheckingUsername
                            ? SizedBox(
                                width: 5.w,
                                height: 5.w,
                                child: Center(
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                ),
                              )
                            : _usernameController.text.length >= 3
                                ? Icon(
                                    _isUsernameAvailable
                                        ? Icons.check_circle
                                        : Icons.error,
                                    color: _isUsernameAvailable
                                        ? AppTheme.successColor
                                        : AppTheme.errorColor,
                                  )
                                : null,
                      ),
                      onChanged: (value) {
                        if (value.length >= 3) {
                          _checkUsernameAvailability(value);
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Username is required';
                        }
                        if (value.length < 3) {
                          return 'Username must be at least 3 characters';
                        }
                        if (!_isUsernameAvailable) {
                          return 'Username is not available';
                        }
                        return null;
                      },
                    ),
                  ],
                ),

                SizedBox(height: 3.h),

                // Password Input
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Password',
                      style: AppTheme.lightTheme.textTheme.labelLarge,
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        hintText: 'Create a strong password',
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      onChanged: _checkPasswordStrength,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                    ),
                    if (_passwordStrength.isNotEmpty) ...[
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          Text(
                            'Strength: ',
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                          Text(
                            _passwordStrength,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: _passwordStrengthColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),

                SizedBox(height: 3.h),

                // Confirm Password Input
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Confirm Password',
                      style: AppTheme.lightTheme.textTheme.labelLarge,
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: !_isConfirmPasswordVisible,
                      decoration: InputDecoration(
                        hintText: 'Confirm your password',
                        prefixIcon: Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ],
                ),

                SizedBox(height: 3.h),

                // Privacy Information
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.primaryLight.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'security',
                            color: AppTheme.primaryLight,
                            size: 5.w,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              'Your privacy is our priority. We use end-to-end encryption to protect your data.',
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      GestureDetector(
                        onTap: _showPrivacyInfo,
                        child: Text(
                          'Learn More',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.primaryLight,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 3.h),

                // Terms Acceptance
                Row(
                  children: [
                    Checkbox(
                      value: _acceptTerms,
                      onChanged: (value) {
                        setState(() {
                          _acceptTerms = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _acceptTerms = !_acceptTerms;
                          });
                        },
                        child: RichText(
                          text: TextSpan(
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                            children: [
                              TextSpan(text: 'I agree to the '),
                              TextSpan(
                                text: 'Terms of Service',
                                style: TextStyle(
                                  color: AppTheme.primaryLight,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                  color: AppTheme.primaryLight,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 4.h),

                // Create Account Button
                SizedBox(
                  width: double.infinity,
                  height: 6.h,
                  child: ElevatedButton(
                    onPressed: _isFormValid() && !_isLoading
                        ? _handleRegistration
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFormValid()
                          ? AppTheme.primaryLight
                          : Colors.grey[300],
                      foregroundColor:
                          _isFormValid() ? Colors.white : Colors.grey[600],
                      elevation: _isFormValid() ? 4 : 0,
                      shadowColor: AppTheme.primaryLight.withValues(alpha: 0.3),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 5.w,
                            height: 5.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                SizedBox(height: 3.h),

                // Sign In Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, '/login-screen');
                      },
                      child: Text(
                        'Sign In',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.primaryLight,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 4.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
