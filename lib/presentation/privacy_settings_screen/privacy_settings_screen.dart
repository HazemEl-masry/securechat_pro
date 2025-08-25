import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './widgets/app_lock_settings_widget.dart';
import './widgets/ghost_mode_settings_widget.dart';
import './widgets/privacy_audit_widget.dart';
import './widgets/privacy_section_widget.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen>
    with TickerProviderStateMixin {
  late TextEditingController _searchController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  String _searchQuery = '';
  int _privacyScore = 85; // Mock privacy score

  // Privacy settings state
  Map<String, bool> _privacySettings = {
    'freezeLastSeen': true,
    'hideOnlineStatus': false,
    'ghostMode': false,
    'hideReadReceipts': true,
    'hideTypingIndicator': false,
    'antiDeleteProtection': true,
    'appLock': false,
    'chatLock': false,
    'screenshotBlocking': true,
    'contactSyncBlocking': false,
    'callPrivacy': true,
    'mediaAutoDownload': false,
    'profilePhotoPrivacy': true,
    'statusPrivacy': false,
    'aboutPrivacy': true,
    'seenMessagePrivacy': false,
  };

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _updatePrivacySetting(String key, bool value) {
    setState(() {
      _privacySettings[key] = value;
      _updatePrivacyScore();
    });

    // Provide haptic feedback for important privacy changes
    if (['appLock', 'ghostMode', 'screenshotBlocking'].contains(key)) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.selectionClick();
    }

    // Show confirmation for critical changes
    if (['appLock', 'chatLock', 'ghostMode'].contains(key)) {
      _showPrivacyChangeConfirmation(key, value);
    }
  }

  void _updatePrivacyScore() {
    int score = 0;
    int totalSettings = _privacySettings.length;

    _privacySettings.forEach((key, value) {
      if (value) {
        // Weight critical privacy settings more
        if (['appLock', 'screenshotBlocking', 'antiDeleteProtection']
            .contains(key)) {
          score += 8;
        } else if (['ghostMode', 'chatLock', 'callPrivacy'].contains(key)) {
          score += 6;
        } else {
          score += 4;
        }
      }
    });

    _privacyScore = (score / (totalSettings * 6) * 100).clamp(0, 100).round();
  }

  void _showPrivacyChangeConfirmation(String setting, bool enabled) {
    String message = _getPrivacyChangeMessage(setting, enabled);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              enabled ? Icons.security : Icons.security_outlined,
              color: enabled ? Colors.green : Colors.orange,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ],
        ),
        backgroundColor:
            enabled ? const Color(0xFF4CAF50) : const Color(0xFFFF9800),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              _privacySettings[setting] = !enabled;
              _updatePrivacyScore();
            });
          },
        ),
      ),
    );
  }

  String _getPrivacyChangeMessage(String setting, bool enabled) {
    Map<String, Map<String, String>> messages = {
      'appLock': {
        'true': 'App lock enabled for enhanced security',
        'false': 'App lock disabled - consider enabling for better protection'
      },
      'chatLock': {
        'true': 'Individual chat locks activated',
        'false': 'Chat locks disabled'
      },
      'ghostMode': {
        'true': 'Ghost mode active - you\'re now invisible',
        'false': 'Ghost mode deactivated - online status visible'
      },
    };

    return messages[setting]?[enabled.toString()] ??
        '${setting.replaceAll(RegExp(r'([A-Z])'), ' \$1').toLowerCase()} ${enabled ? "enabled" : "disabled"}';
  }

  List<Widget> _getFilteredSections() {
    if (_searchQuery.isEmpty) {
      return _buildAllSections();
    }

    return _buildAllSections().where((widget) {
      // Simple search implementation - in a real app, you'd have more sophisticated filtering
      return true;
    }).toList();
  }

  List<Widget> _buildAllSections() {
    return [
      PrivacyAuditWidget(
        privacyScore: _privacyScore,
        onViewDetails: () => _showPrivacyAuditDetails(),
      ),
      const SizedBox(height: 24),
      PrivacySectionWidget(
        title: 'Visibility Controls',
        icon: Icons.visibility_off,
        items: [
          _buildPrivacyItem(
            'Freeze Last Seen',
            'Hide when you were last active',
            'freezeLastSeen',
            Icons.access_time,
          ),
          _buildPrivacyItem(
            'Hide Online Status',
            'Don\'t show when you\'re online',
            'hideOnlineStatus',
            Icons.circle_outlined,
          ),
        ],
      ),
      const SizedBox(height: 16),
      GhostModeSettingsWidget(
        isEnabled: _privacySettings['ghostMode'] ?? false,
        onToggle: (value) => _updatePrivacySetting('ghostMode', value),
        exceptions: const ['John Doe', 'Sarah Wilson'], // Mock data
      ),
      const SizedBox(height: 16),
      PrivacySectionWidget(
        title: 'Message Privacy',
        icon: Icons.message_outlined,
        items: [
          _buildPrivacyItem(
            'Hide Read Receipts',
            'Don\'t show blue ticks to others',
            'hideReadReceipts',
            Icons.done_all,
          ),
          _buildPrivacyItem(
            'Hide Typing Indicators',
            'Don\'t show when you\'re typing',
            'hideTypingIndicator',
            Icons.keyboard,
          ),
          _buildPrivacyItem(
            'Anti-Delete Protection',
            'Keep original messages when others delete',
            'antiDeleteProtection',
            Icons.restore,
            isHighPriority: true,
          ),
        ],
      ),
      const SizedBox(height: 16),
      PrivacySectionWidget(
        title: 'Security Features',
        icon: Icons.security,
        items: [
          _buildAppLockItem(),
          _buildPrivacyItem(
            'Chat Lock',
            'Lock individual conversations',
            'chatLock',
            Icons.lock_outline,
            isHighPriority: true,
          ),
          _buildPrivacyItem(
            'Screenshot Blocking',
            'Prevent screenshots in app',
            'screenshotBlocking',
            Icons.screenshot_monitor,
            isHighPriority: true,
          ),
        ],
      ),
      const SizedBox(height: 16),
      PrivacySectionWidget(
        title: 'Advanced Options',
        icon: Icons.settings_applications,
        items: [
          _buildPrivacyItem(
            'Block Contact Sync',
            'Don\'t sync contacts to server',
            'contactSyncBlocking',
            Icons.contacts,
          ),
          _buildPrivacyItem(
            'Call Privacy Mode',
            'Enhanced privacy during calls',
            'callPrivacy',
            Icons.phone_locked,
          ),
          _buildPrivacyItem(
            'Restrict Media Auto-Download',
            'Control automatic media downloads',
            'mediaAutoDownload',
            Icons.download_outlined,
          ),
        ],
      ),
      const SizedBox(height: 16),
      PrivacySectionWidget(
        title: 'Profile Privacy',
        icon: Icons.person_outline,
        items: [
          _buildPrivacyItem(
            'Profile Photo Privacy',
            'Control who sees your profile photo',
            'profilePhotoPrivacy',
            Icons.photo_camera,
          ),
          _buildPrivacyItem(
            'Status Privacy',
            'Control who sees your status updates',
            'statusPrivacy',
            Icons.update,
          ),
          _buildPrivacyItem(
            'About Info Privacy',
            'Control who sees your about information',
            'aboutPrivacy',
            Icons.info_outline,
          ),
        ],
      ),
      const SizedBox(height: 24),
      _buildExportSection(),
    ];
  }

  Widget _buildPrivacyItem(
    String title,
    String subtitle,
    String key,
    IconData icon, {
    bool isHighPriority = false,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isHighPriority
              ? Theme.of(context).colorScheme.error.withAlpha(26)
              : Theme.of(context).colorScheme.primary.withAlpha(26),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isHighPriority
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.primary,
          size: 20,
        ),
      ),
      title: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (isHighPriority) ...[
            const SizedBox(width: 8),
            Icon(
              Icons.priority_high,
              size: 16,
              color: Theme.of(context).colorScheme.error,
            ),
          ],
        ],
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: Switch(
        value: _privacySettings[key] ?? false,
        onChanged: (value) => _updatePrivacySetting(key, value),
        activeColor: isHighPriority
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildAppLockItem() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error.withAlpha(26),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.lock,
          color: Theme.of(context).colorScheme.error,
          size: 20,
        ),
      ),
      title: Row(
        children: [
          Text(
            'App Lock',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.priority_high,
            size: 16,
            color: Theme.of(context).colorScheme.error,
          ),
        ],
      ),
      subtitle: Text(
        'Biometric authentication required',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Switch(
            value: _privacySettings['appLock'] ?? false,
            onChanged: (value) => _updatePrivacySetting('appLock', value),
            activeColor: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => _showAppLockSettings(),
            icon: const Icon(Icons.settings),
            iconSize: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildExportSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(128),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha(51),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.backup,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Text(
                'Privacy Settings Backup',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Export and restore your privacy configuration',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _exportSettings(),
                  icon: const Icon(Icons.file_download),
                  label: const Text('Export'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _importSettings(),
                  icon: const Icon(Icons.file_upload),
                  label: const Text('Import'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPrivacyAuditDetails() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Audit Details',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text(
                'Your current privacy score: $_privacyScore/100',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _buildRecommendationItem(
                      'Enable App Lock',
                      'Add biometric authentication for enhanced security',
                      !(_privacySettings['appLock'] ?? false),
                    ),
                    _buildRecommendationItem(
                      'Activate Ghost Mode',
                      'Stay invisible while using the app',
                      !(_privacySettings['ghostMode'] ?? false),
                    ),
                    _buildRecommendationItem(
                      'Enable Screenshot Blocking',
                      'Prevent unauthorized screenshots',
                      !(_privacySettings['screenshotBlocking'] ?? false),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationItem(
      String title, String subtitle, bool showRecommendation) {
    if (!showRecommendation) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          Icons.lightbulb_outline,
          color: Theme.of(context).colorScheme.secondary,
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: TextButton(
          onPressed: () {
            Navigator.pop(context);
            // Auto-navigate to specific setting
          },
          child: const Text('Enable'),
        ),
      ),
    );
  }

  void _showAppLockSettings() {
    showDialog(
      context: context,
      builder: (context) => AppLockSettingsWidget(
        isEnabled: _privacySettings['appLock'] ?? false,
        onToggle: (value) => _updatePrivacySetting('appLock', value),
      ),
    );
  }

  void _exportSettings() {
    // Implementation for exporting settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Privacy settings exported successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _importSettings() {
    // Implementation for importing settings
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import Privacy Settings'),
        content: const Text('Select a privacy configuration file to import.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Privacy settings imported successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Import'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Settings'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _showPrivacyAuditDetails(),
            icon: Badge(
              label: Text(_privacyScore.toString()),
              child: const Icon(Icons.security),
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'reset':
                  _showResetDialog();
                  break;
                case 'help':
                  _showHelpDialog();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'reset',
                child: Row(
                  children: [
                    Icon(Icons.restore),
                    SizedBox(width: 12),
                    Text('Reset to Defaults'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'help',
                child: Row(
                  children: [
                    Icon(Icons.help_outline),
                    SizedBox(width: 12),
                    Text('Privacy Guide'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Search bar
            Container(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search privacy features...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                          icon: const Icon(Icons.clear),
                        )
                      : null,
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),

            // Settings list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 24),
                children: _getFilteredSections(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Privacy Settings'),
        content: const Text(
            'This will reset all privacy settings to their default values. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _privacySettings = Map.fromIterable(
                  _privacySettings.keys,
                  value: (key) => false,
                );
                _updatePrivacyScore();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Privacy settings reset to defaults'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Guide'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Understanding Privacy Features:\n\n'
                '🔒 Critical Features (Red): Essential for maximum security\n'
                '🛡️ Important Features (Blue): Recommended for privacy\n'
                '👁️ Visibility Controls: Manage your online presence\n'
                '💬 Message Privacy: Control message interactions\n'
                '🔐 Security Features: Advanced protection mechanisms\n\n'
                'Higher privacy scores indicate better protection. Aim for 80+ for optimal security.',
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
