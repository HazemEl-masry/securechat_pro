import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import '../contact_selection_screen/contact_selection_screen.dart';
import './widgets/group_photo_picker_widget.dart';
import './widgets/group_settings_widget.dart';
import './widgets/selected_member_chip_widget.dart';

class GroupChatCreationScreen extends StatefulWidget {
  const GroupChatCreationScreen({super.key});

  @override
  State<GroupChatCreationScreen> createState() =>
      _GroupChatCreationScreenState();
}

class _GroupChatCreationScreenState extends State<GroupChatCreationScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ScrollController _membersScrollController = ScrollController();

  late AnimationController _slideAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  int _currentStep = 0;
  List<Contact> _selectedMembers = [];
  String? _groupPhotoUrl;
  bool _isCreating = false;

  // Group settings
  bool _canMembersAddParticipants = true;
  bool _canMembersEditGroupInfo = false;
  bool _canMembersSendMessages = true;
  bool _canMembersShareMedia = true;
  bool _isGroupDiscoverable = false;
  bool _requireApprovalToJoin = true;
  bool _isAnnouncementOnly = false;
  int _disappearingMessagesTimer = 0;

  @override
  void initState() {
    super.initState();

    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeOut,
    ));

    // Get pre-selected contacts if any
    Future.microtask(() {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is List<Contact>) {
        setState(() {
          _selectedMembers = args;
        });
      }
    });

    _slideAnimationController.forward();
    _fadeAnimationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _groupNameController.dispose();
    _descriptionController.dispose();
    _membersScrollController.dispose();
    _slideAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 1) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _selectMembers() async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.contactSelection,
    );

    if (result is Contact) {
      setState(() {
        if (!_selectedMembers.any((m) => m.id == result.id)) {
          _selectedMembers.add(result);
        }
      });
    }
  }

  void _removeMember(Contact member) {
    setState(() {
      _selectedMembers.removeWhere((m) => m.id == member.id);
    });
  }

  void _createGroup() async {
    if (_groupNameController.text.trim().isEmpty) {
      _showSnackBar('Please enter a group name');
      return;
    }

    if (_selectedMembers.length < 1) {
      _showSnackBar('Please select at least one member');
      return;
    }

    setState(() => _isCreating = true);

    // Simulate group creation
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      _showSnackBar(
          'Group "${_groupNameController.text}" created successfully!');

      // Navigate back to chat list or directly to the new group chat
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  bool get _canProceedToNextStep {
    return _selectedMembers.isNotEmpty;
  }

  bool get _canCreateGroup {
    return _groupNameController.text.trim().isNotEmpty &&
        _selectedMembers.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(theme),
      body: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Step indicator
              _buildStepIndicator(theme),

              // Page content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildMemberSelectionStep(theme),
                    _buildGroupCustomizationStep(theme),
                  ],
                ),
              ),

              // Bottom navigation
              _buildBottomNavigation(theme),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    final steps = ['Select Members', 'Group Details'];

    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      scrolledUnderElevation: 1,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        onPressed:
            _currentStep > 0 ? _previousStep : () => Navigator.pop(context),
        icon: Icon(
          Icons.arrow_back,
          color: theme.colorScheme.onSurface,
        ),
      ),
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Text(
          steps[_currentStep],
          key: ValueKey(_currentStep),
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
      actions: [
        if (_currentStep == 0 && _selectedMembers.isNotEmpty)
          TextButton(
            onPressed: _nextStep,
            child: Text(
              'Next',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.primaryColor,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStepIndicator(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          for (int i = 0; i < 2; i++) ...[
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 4,
                decoration: BoxDecoration(
                  color: i <= _currentStep
                      ? theme.primaryColor
                      : theme.primaryColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            if (i < 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  Widget _buildMemberSelectionStep(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selected members
        if (_selectedMembers.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Selected Members (${_selectedMembers.length})',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 60,
            child: ListView.builder(
              controller: _membersScrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _selectedMembers.length,
              itemBuilder: (context, index) {
                final member = _selectedMembers[index];
                return SelectedMemberChipWidget(
                  name: member.name,
                  avatarUrl: member.avatarUrl,
                  onRemove: () => _removeMember(member),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],

        // Add members button
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: InkWell(
            onTap: _selectMembers,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.primaryColor.withValues(alpha: 0.3),
                  width: 2,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_add,
                      color: theme.primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedMembers.isEmpty
                              ? 'Add Members'
                              : 'Add More Members',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: theme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Select contacts to add to your group',
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
                    color: theme.primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Empty state
        if (_selectedMembers.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.group_add,
                      size: 40,
                      color: theme.primaryColor.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Add Group Members',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select contacts from your phone to add\nto your new group chat.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildGroupCustomizationStep(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Group photo and name section
          Center(
            child: Column(
              children: [
                GroupPhotoPickerWidget(
                  imageUrl: _groupPhotoUrl,
                  onImageSelected: (url) =>
                      setState(() => _groupPhotoUrl = url),
                  size: 100,
                ),

                const SizedBox(height: 24),

                // Group name
                TextField(
                  controller: _groupNameController,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Group Name',
                    hintText: 'Enter group name...',
                    counterText: '${_groupNameController.text.length}/25',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: theme.primaryColor, width: 2),
                    ),
                  ),
                  maxLength: 25,
                  onChanged: (_) => setState(() {}),
                ),

                const SizedBox(height: 16),

                // Group description
                TextField(
                  controller: _descriptionController,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: theme.colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Description (Optional)',
                    hintText: 'Add a group description...',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: theme.primaryColor, width: 2),
                    ),
                  ),
                  maxLines: 3,
                  maxLength: 100,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Members preview
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.primaryColor.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.group,
                      color: theme.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Group Members (${_selectedMembers.length})',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: theme.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selectedMembers.map((member) {
                    return SelectedMemberChipWidget(
                      name: member.name,
                      avatarUrl: member.avatarUrl,
                      isAdmin: member == _selectedMembers.first,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Group settings
          GroupSettingsWidget(
            canMembersAddParticipants: _canMembersAddParticipants,
            canMembersEditGroupInfo: _canMembersEditGroupInfo,
            canMembersSendMessages: _canMembersSendMessages,
            canMembersShareMedia: _canMembersShareMedia,
            isGroupDiscoverable: _isGroupDiscoverable,
            requireApprovalToJoin: _requireApprovalToJoin,
            isAnnouncementOnly: _isAnnouncementOnly,
            disappearingMessagesTimer: _disappearingMessagesTimer,
            onMembersAddParticipantsChanged: (value) =>
                setState(() => _canMembersAddParticipants = value),
            onMembersEditGroupInfoChanged: (value) =>
                setState(() => _canMembersEditGroupInfo = value),
            onMembersSendMessagesChanged: (value) =>
                setState(() => _canMembersSendMessages = value),
            onMembersShareMediaChanged: (value) =>
                setState(() => _canMembersShareMedia = value),
            onGroupDiscoverableChanged: (value) =>
                setState(() => _isGroupDiscoverable = value),
            onRequireApprovalToJoinChanged: (value) =>
                setState(() => _requireApprovalToJoin = value),
            onAnnouncementOnlyChanged: (value) =>
                setState(() => _isAnnouncementOnly = value),
            onDisappearingMessagesTimerChanged: (value) =>
                setState(() => _disappearingMessagesTimer = value),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: theme.dividerColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep == 1) ...[
              Expanded(
                child: OutlinedButton(
                  onPressed: _previousStep,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: theme.primaryColor),
                  ),
                  child: Text(
                    'Back',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: _currentStep == 0
                  ? ElevatedButton(
                      onPressed: _canProceedToNextStep ? _nextStep : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        'Next',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : ElevatedButton(
                      onPressed:
                          _canCreateGroup && !_isCreating ? _createGroup : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: _isCreating
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Creating...',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              'Create Group',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
