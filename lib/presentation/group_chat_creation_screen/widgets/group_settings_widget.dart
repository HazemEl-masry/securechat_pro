import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupSettingsWidget extends StatefulWidget {
  final bool canMembersAddParticipants;
  final bool canMembersEditGroupInfo;
  final bool canMembersSendMessages;
  final bool canMembersShareMedia;
  final bool isGroupDiscoverable;
  final bool requireApprovalToJoin;
  final bool isAnnouncementOnly;
  final int disappearingMessagesTimer;
  final ValueChanged<bool>? onMembersAddParticipantsChanged;
  final ValueChanged<bool>? onMembersEditGroupInfoChanged;
  final ValueChanged<bool>? onMembersSendMessagesChanged;
  final ValueChanged<bool>? onMembersShareMediaChanged;
  final ValueChanged<bool>? onGroupDiscoverableChanged;
  final ValueChanged<bool>? onRequireApprovalToJoinChanged;
  final ValueChanged<bool>? onAnnouncementOnlyChanged;
  final ValueChanged<int>? onDisappearingMessagesTimerChanged;

  const GroupSettingsWidget({
    super.key,
    this.canMembersAddParticipants = true,
    this.canMembersEditGroupInfo = false,
    this.canMembersSendMessages = true,
    this.canMembersShareMedia = true,
    this.isGroupDiscoverable = false,
    this.requireApprovalToJoin = true,
    this.isAnnouncementOnly = false,
    this.disappearingMessagesTimer = 0,
    this.onMembersAddParticipantsChanged,
    this.onMembersEditGroupInfoChanged,
    this.onMembersSendMessagesChanged,
    this.onMembersShareMediaChanged,
    this.onGroupDiscoverableChanged,
    this.onRequireApprovalToJoinChanged,
    this.onAnnouncementOnlyChanged,
    this.onDisappearingMessagesTimerChanged,
  });

  @override
  State<GroupSettingsWidget> createState() => _GroupSettingsWidgetState();
}

class _GroupSettingsWidgetState extends State<GroupSettingsWidget> {
  bool _isExpanded = false;

  void _showDisappearingMessagesDialog() {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.scaffoldBackgroundColor,
        title: Text(
          'Disappearing Messages',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select when messages should disappear after being read:',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            ..._buildDisappearingOptions(theme),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDisappearingOptions(ThemeData theme) {
    final options = [
      {'value': 0, 'label': 'Off'},
      {'value': 3600, 'label': '1 hour'},
      {'value': 86400, 'label': '24 hours'},
      {'value': 604800, 'label': '7 days'},
      {'value': 2592000, 'label': '30 days'},
    ];

    return options.map((option) {
      final isSelected = widget.disappearingMessagesTimer == option['value'];
      return RadioListTile<int>(
        value: option['value'] as int,
        groupValue: widget.disappearingMessagesTimer,
        onChanged: (value) {
          Navigator.pop(context);
          widget.onDisappearingMessagesTimerChanged?.call(value ?? 0);
        },
        title: Text(
          option['label'] as String,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: theme.colorScheme.onSurface,
          ),
        ),
        activeColor: theme.primaryColor,
      );
    }).toList();
  }

  String _getDisappearingTimerLabel() {
    switch (widget.disappearingMessagesTimer) {
      case 0:
        return 'Off';
      case 3600:
        return '1 hour';
      case 86400:
        return '24 hours';
      case 604800:
        return '7 days';
      case 2592000:
        return '30 days';
      default:
        return 'Off';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.settings,
                    color: theme.primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Group Settings',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _buildSettingsContent(theme),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsContent(ThemeData theme) {
    return Column(
      children: [
        const Divider(height: 1),

        // Member permissions
        _buildSectionHeader(theme, 'Member Permissions'),

        _buildSwitchTile(
          theme: theme,
          title: 'Add Participants',
          subtitle: 'Let members add new participants',
          value: widget.canMembersAddParticipants,
          onChanged: widget.onMembersAddParticipantsChanged,
        ),

        _buildSwitchTile(
          theme: theme,
          title: 'Edit Group Info',
          subtitle: 'Let members edit group name and photo',
          value: widget.canMembersEditGroupInfo,
          onChanged: widget.onMembersEditGroupInfoChanged,
        ),

        _buildSwitchTile(
          theme: theme,
          title: 'Send Messages',
          subtitle: 'Let members send messages',
          value: widget.canMembersSendMessages,
          onChanged: widget.onMembersSendMessagesChanged,
        ),

        _buildSwitchTile(
          theme: theme,
          title: 'Share Media',
          subtitle: 'Let members share photos and files',
          value: widget.canMembersShareMedia,
          onChanged: widget.onMembersShareMediaChanged,
        ),

        // Privacy settings
        _buildSectionHeader(theme, 'Privacy'),

        _buildSwitchTile(
          theme: theme,
          title: 'Group Discoverable',
          subtitle: 'Let others find this group',
          value: widget.isGroupDiscoverable,
          onChanged: widget.onGroupDiscoverableChanged,
        ),

        _buildSwitchTile(
          theme: theme,
          title: 'Require Approval',
          subtitle: 'Admin approval required to join',
          value: widget.requireApprovalToJoin,
          onChanged: widget.onRequireApprovalToJoinChanged,
        ),

        // Special modes
        _buildSectionHeader(theme, 'Special Modes'),

        _buildSwitchTile(
          theme: theme,
          title: 'Announcement Only',
          subtitle: 'Only admins can send messages',
          value: widget.isAnnouncementOnly,
          onChanged: widget.onAnnouncementOnlyChanged,
        ),

        // Disappearing messages
        InkWell(
          onTap: _showDisappearingMessagesDialog,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Disappearing Messages',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Auto-delete messages after: ${_getDisappearingTimerLabel()}',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: theme.primaryColor.withValues(alpha: 0.05),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: theme.primaryColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required ThemeData theme,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: theme.primaryColor,
          ),
        ],
      ),
    );
  }
}
