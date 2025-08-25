import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NetworkStatusWidget extends StatelessWidget {
  final bool isConnected;
  final bool isConnecting;

  const NetworkStatusWidget({
    Key? key,
    required this.isConnected,
    this.isConnecting = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isConnected && !isConnecting) return const SizedBox.shrink();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isConnected ? 0 : 6.h,
      child: Container(
        width: double.infinity,
        color: isConnecting ? AppTheme.warningColor : AppTheme.errorColor,
        child: SafeArea(
          bottom: false,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isConnecting) ...[
                  SizedBox(
                    width: 4.w,
                    height: 4.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Connecting...',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ] else ...[
                  CustomIconWidget(
                    iconName: 'wifi_off',
                    color: Colors.white,
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'No internet connection',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
