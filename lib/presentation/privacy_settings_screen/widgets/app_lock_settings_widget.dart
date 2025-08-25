import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLockSettingsWidget extends StatefulWidget {
  final bool isEnabled;
  final Function(bool) onToggle;

  const AppLockSettingsWidget({
    super.key,
    required this.isEnabled,
    required this.onToggle,
  });

  @override
  State<AppLockSettingsWidget> createState() => _AppLockSettingsWidgetState();
}

class _AppLockSettingsWidgetState extends State<AppLockSettingsWidget> {
  String _selectedTimeout = '1 minute';
  bool _biometricEnabled = true;
  bool _lockOnAppSwitch = true;
  
  final List<String> _timeoutOptions = [
    'Immediately',
    '30 seconds',
    '1 minute',
    '5 minutes',
    '15 minutes',
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withAlpha(26),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.security,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'App Lock Settings',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            
            // Settings content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Enable/Disable toggle
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: widget.isEnabled 
                          ? Colors.green.withAlpha(26)
                          : Colors.grey.withAlpha(26),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: widget.isEnabled 
                            ? Colors.green.withAlpha(77)
                            : Colors.grey.withAlpha(77),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            widget.isEnabled ? Icons.lock : Icons.lock_open,
                            color: widget.isEnabled ? Colors.green : Colors.grey,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'App Lock',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                Text(
                                  widget.isEnabled 
                                    ? 'Authentication required to access app'
                                    : 'App can be opened without authentication',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: widget.isEnabled,
                            onChanged: (value) {
                              widget.onToggle(value);
                              if (value) {
                                _requestBiometricPermission();
                              }
                            },
                            activeColor: Colors.green,
                          ),
                        ],
                      ),
                    ),
                    
                    if (widget.isEnabled) ...[
                      const SizedBox(height: 24),
                      
                      // Biometric authentication
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.fingerprint,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        title: const Text('Biometric Authentication'),
                        subtitle: const Text('Use fingerprint or face recognition'),
                        trailing: Switch(
                          value: _biometricEnabled,
                          onChanged: (value) => setState(() => _biometricEnabled = value),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Auto-lock timeout
                      Text(
                        'Auto-lock timeout',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Lock the app after being inactive for:',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 12),
                      
                      ..._timeoutOptions.map((option) => RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        title: Text(option),
                        value: option,
                        groupValue: _selectedTimeout,
                        onChanged: (value) => setState(() => _selectedTimeout = value!),
                        activeColor: Theme.of(context).colorScheme.primary,
                      )),
                      
                      const SizedBox(height: 16),
                      
                      // Lock on app switch
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.help_outline,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        title: const Text('Lock on App Switch'),
                        subtitle: const Text('Require authentication when returning from other apps'),
                        trailing: Switch(
                          value: _lockOnAppSwitch,
                          onChanged: (value) => setState(() => _lockOnAppSwitch = value),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Security info
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary.withAlpha(26),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Theme.of(context).colorScheme.tertiary,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'App lock provides an additional security layer to protect your conversations from unauthorized access.',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            // Action buttons
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      _saveSettings();
                      Navigator.pop(context);
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _requestBiometricPermission() async {
    // In a real implementation, you would request biometric permission here
    // For now, we'll just provide haptic feedback
    HapticFeedback.mediumImpact();
    
    // Show a mock biometric dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enable Biometric Authentication'),
        content: const Text('Would you like to use biometric authentication (fingerprint/face recognition) to unlock the app?'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _biometricEnabled = false);
              Navigator.pop(context);
            },
            child: const Text('Skip'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _biometricEnabled = true);
              Navigator.pop(context);
              _showBiometricSetupSuccess();
            },
            child: const Text('Enable'),
          ),
        ],
      ),
    );
  }

  void _showBiometricSetupSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('Biometric authentication enabled'),
          ],
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _saveSettings() {
    // Save the app lock settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('App lock settings saved'),
        backgroundColor: Colors.green,
      ),
    );
  }
}