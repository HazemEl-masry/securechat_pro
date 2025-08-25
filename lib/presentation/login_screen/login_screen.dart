import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final LocalAuthentication _localAuth = LocalAuthentication();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _rememberDevice = false;
  bool _isBiometricAvailable = false;
  String _selectedCountryCode = '+1';
  String? _phoneError;
  String? _passwordError;

  // Mock credentials for demonstration
  final Map<String, String> _mockCredentials = {
    '1234567890': 'SecurePass123',
    '9876543210': 'MyPassword456',
    '5555555555': 'TestUser789',
  };

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
    _loadSavedCredentials();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      final bool isAvailable = await _localAuth.canCheckBiometrics;
      final List<BiometricType> availableBiometrics =
          await _localAuth.getAvailableBiometrics();

      setState(() {
        _isBiometricAvailable = isAvailable && availableBiometrics.isNotEmpty;
      });
    } catch (e) {
      setState(() {
        _isBiometricAvailable = false;
      });
    }
  }

  Future<void> _loadSavedCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedPhone = prefs.getString('saved_phone');
      if (savedPhone != null) {
        setState(() {
          _phoneController.text = savedPhone;
          _rememberDevice = true;
        });
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _saveCredentials() async {
    if (_rememberDevice) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('saved_phone', _phoneController.text);
        await prefs.setBool('biometric_enabled', true);
      } catch (e) {
        // Handle error silently
      }
    }
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (value.length < 10) {
      return 'Phone number must be at least 10 digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Phone number must contain only digits';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<void> _performBiometricAuth() async {
    try {
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to sign in to SecureChat Pro',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (didAuthenticate) {
        HapticFeedback.lightImpact();
        _navigateToHome();
      }
    } catch (e) {
      _showErrorSnackBar('Biometric authentication failed. Please try again.');
    }
  }

  Future<void> _handleLogin() async {
    setState(() {
      _phoneError = _validatePhone(_phoneController.text);
      _passwordError = _validatePassword(_passwordController.text);
    });

    if (_phoneError != null || _passwordError != null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Check mock credentials
    final phone = _phoneController.text;
    final password = _passwordController.text;

    if (_mockCredentials.containsKey(phone) &&
        _mockCredentials[phone] == password) {
      await _saveCredentials();
      HapticFeedback.lightImpact();
      _navigateToHome();
    } else {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar(
          'Invalid phone number or password. Please check your credentials and try again.');
    }
  }

  void _navigateToHome() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/chat-list-screen',
      (route) => false,
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildCountryCodeSelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.lightTheme.colorScheme.outline),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCountryCode,
          isDense: true,
          items: const [
            DropdownMenuItem(value: '+1', child: Text('+1')),
            DropdownMenuItem(value: '+44', child: Text('+44')),
            DropdownMenuItem(value: '+91', child: Text('+91')),
            DropdownMenuItem(value: '+971', child: Text('+971')),
          ],
          onChanged: (value) {
            setState(() {
              _selectedCountryCode = value!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone Number',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            _buildCountryCodeSelector(),
            SizedBox(width: 3.w),
            Expanded(
              child: TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  hintText: 'Enter phone number',
                  errorText: _phoneError,
                  prefixIcon: CustomIconWidget(
                    iconName: 'phone',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                onChanged: (value) {
                  if (_phoneError != null) {
                    setState(() {
                      _phoneError = null;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Password',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            TextButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      // Navigate to forgot password screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Forgot password feature coming soon'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
              child: Text(
                'Forgot Password?',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          enabled: !_isLoading,
          decoration: InputDecoration(
            hintText: 'Enter password',
            errorText: _passwordError,
            prefixIcon: CustomIconWidget(
              iconName: 'lock',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
              icon: CustomIconWidget(
                iconName: _isPasswordVisible ? 'visibility_off' : 'visibility',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          ),
          onChanged: (value) {
            if (_passwordError != null) {
              setState(() {
                _passwordError = null;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildRememberDeviceToggle() {
    return Row(
      children: [
        Checkbox(
          value: _rememberDevice,
          onChanged: _isLoading
              ? null
              : (value) {
                  setState(() {
                    _rememberDevice = value ?? false;
                  });
                },
        ),
        Expanded(
          child: Text(
            'Remember this device',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton() {
    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
        child: _isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.colorScheme.onPrimary,
                  ),
                ),
              )
            : Text(
                'Sign In',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildBiometricButton() {
    if (!_isBiometricAvailable || !_rememberDevice)
      return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(top: 2.h),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child:
                      Divider(color: AppTheme.lightTheme.colorScheme.outline)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  'OR',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Expanded(
                  child:
                      Divider(color: AppTheme.lightTheme.colorScheme.outline)),
            ],
          ),
          SizedBox(height: 2.h),
          OutlinedButton.icon(
            onPressed: _isLoading ? null : _performBiometricAuth,
            icon: CustomIconWidget(
              iconName: 'fingerprint',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            label: Text(
              'Use Biometric Authentication',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 6.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateAccountLink() {
    return Container(
      margin: EdgeInsets.only(top: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'New user? ',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          TextButton(
            onPressed: _isLoading
                ? null
                : () {
                    Navigator.pushNamed(context, '/registration-screen');
                  },
            child: Text(
              'Create Account',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 8.h),

              // App Logo
              Container(
                width: 25.w,
                height: 25.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.lightTheme.colorScheme.primary,
                      AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: CustomIconWidget(
                  iconName: 'chat_bubble',
                  color: Colors.white,
                  size: 12.w,
                ),
              ),

              SizedBox(height: 3.h),

              // Welcome Text
              Text(
                'Welcome Back',
                style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: 1.h),

              Text(
                'Sign in to continue to SecureChat Pro',
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 6.h),

              // Login Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildPhoneField(),
                    SizedBox(height: 3.h),
                    _buildPasswordField(),
                    SizedBox(height: 2.h),
                    _buildRememberDeviceToggle(),
                    SizedBox(height: 4.h),
                    _buildSignInButton(),
                    _buildBiometricButton(),
                  ],
                ),
              ),

              _buildCreateAccountLink(),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }
}
