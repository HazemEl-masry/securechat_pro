import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import './widgets/contact_empty_state_widget.dart';
import './widgets/contact_item_widget.dart';
import './widgets/contact_search_widget.dart';
import './widgets/contact_section_header_widget.dart';

class ContactSelectionScreen extends StatefulWidget {
  const ContactSelectionScreen({super.key});

  @override
  State<ContactSelectionScreen> createState() => _ContactSelectionScreenState();
}

class _ContactSelectionScreenState extends State<ContactSelectionScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  List<Contact> _allContacts = [];
  List<Contact> _filteredContacts = [];
  List<Contact> _recentContacts = [];
  List<Contact> _selectedContacts = [];

  bool _isLoading = true;
  bool _isMultiSelectMode = false;
  bool _isSearching = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _loadContacts();
    _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _loadContacts() async {
    // Simulate loading contacts
    await Future.delayed(const Duration(milliseconds: 1500));

    // Mock contact data
    final contacts = [
      Contact(
        id: '1',
        name: 'Ahmed Hassan',
        phoneNumber: '+20 123 456 7890',
        username: 'ahmed_hassan',
        avatarUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
        isOnline: true,
        isSecureChatUser: true,
      ),
      Contact(
        id: '2',
        name: 'Sarah Johnson',
        phoneNumber: '+1 555 123 4567',
        username: 'sarah_j',
        avatarUrl:
            'https://images.unsplash.com/photo-1494790108755-2616b9da4e8a?w=150&h=150&fit=crop&crop=face',
        isOnline: false,
        lastSeen: '2 hours ago',
        isSecureChatUser: true,
      ),
      Contact(
        id: '3',
        name: 'Mohammed Ali',
        phoneNumber: '+966 50 123 4567',
        isOnline: true,
        isSecureChatUser: false,
      ),
      Contact(
        id: '4',
        name: 'Emily Chen',
        phoneNumber: '+86 138 0013 8000',
        username: 'emily_chen',
        avatarUrl:
            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
        isOnline: false,
        lastSeen: 'yesterday',
        isSecureChatUser: true,
      ),
      Contact(
        id: '5',
        name: 'David Wilson',
        phoneNumber: '+44 20 7946 0958',
        isOnline: false,
        lastSeen: '3 days ago',
        isSecureChatUser: false,
      ),
    ];

    final recentContacts = [contacts[0], contacts[1]];

    if (mounted) {
      setState(() {
        _allContacts = contacts;
        _filteredContacts = contacts;
        _recentContacts = recentContacts;
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _isSearching = query.isNotEmpty;

      if (query.isEmpty) {
        _filteredContacts = _allContacts;
      } else {
        _filteredContacts = _allContacts.where((contact) {
          return contact.name.toLowerCase().contains(query) ||
              contact.phoneNumber.contains(query) ||
              (contact.username?.toLowerCase().contains(query) ?? false);
        }).toList();
      }
    });
  }

  void _onContactTap(Contact contact) {
    if (_isMultiSelectMode) {
      _toggleContactSelection(contact);
    } else {
      // Navigate to chat with selected contact
      Navigator.pop(context, contact);
    }
  }

  void _onContactLongPress(Contact contact) {
    if (!_isMultiSelectMode) {
      setState(() {
        _isMultiSelectMode = true;
        _selectedContacts.add(contact);
      });
    }
  }

  void _toggleContactSelection(Contact contact) {
    setState(() {
      if (_selectedContacts.any((c) => c.id == contact.id)) {
        _selectedContacts.removeWhere((c) => c.id == contact.id);
        if (_selectedContacts.isEmpty) {
          _isMultiSelectMode = false;
        }
      } else {
        _selectedContacts.add(contact);
      }
    });
  }

  void _exitMultiSelectMode() {
    setState(() {
      _isMultiSelectMode = false;
      _selectedContacts.clear();
    });
  }

  void _createGroupChat() {
    if (_selectedContacts.isNotEmpty) {
      Navigator.pushNamed(
        context,
        AppRoutes.groupChatCreation,
        arguments: _selectedContacts,
      );
    }
  }

  void _inviteFriends() {
    // Implement invite friends functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Invite friends feature coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _refreshContacts() async {
    setState(() => _isLoading = true);
    _loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(theme),
      body: SlideTransition(
        position: _slideAnimation,
        child: _isLoading
            ? _buildLoadingState(theme)
            : _buildContactList(theme, isDark),
      ),
      floatingActionButton: _buildFloatingActionButton(theme),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      scrolledUnderElevation: 1,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        onPressed: _isMultiSelectMode
            ? _exitMultiSelectMode
            : () => Navigator.pop(context),
        icon: Icon(
          _isMultiSelectMode ? Icons.close : Icons.arrow_back,
          color: theme.colorScheme.onSurface,
        ),
      ),
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: _isMultiSelectMode
            ? Text(
                '${_selectedContacts.length} selected',
                key: const ValueKey('selected'),
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              )
            : Text(
                'Select Contact',
                key: const ValueKey('title'),
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
      ),
      actions: [
        if (_isMultiSelectMode && _selectedContacts.length > 1)
          IconButton(
            onPressed: _createGroupChat,
            icon: Icon(
              Icons.group_add,
              color: theme.primaryColor,
            ),
            tooltip: 'Create Group',
          ),
        IconButton(
          onPressed: _refreshContacts,
          icon: Icon(
            Icons.refresh,
            color: theme.colorScheme.onSurface,
          ),
          tooltip: 'Refresh Contacts',
        ),
      ],
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: theme.primaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading contacts...',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactList(ThemeData theme, bool isDark) {
    if (_filteredContacts.isEmpty && !_isSearching) {
      return ContactEmptyStateWidget(
        title: 'No Contacts Found',
        subtitle:
            'Allow SecureChat Pro to access your contacts or invite friends to join.',
        buttonText: 'Invite Friends',
        onButtonPressed: _inviteFriends,
        icon: Icons.contacts_outlined,
      );
    }

    if (_filteredContacts.isEmpty && _isSearching) {
      return ContactEmptyStateWidget(
        title: 'No Results',
        subtitle: 'No contacts match your search for "$_searchQuery".',
        buttonText: 'Clear Search',
        onButtonPressed: () {
          _searchController.clear();
          _onSearchChanged('');
        },
        icon: Icons.search_off,
      );
    }

    return Column(
      children: [
        // Search bar
        ContactSearchWidget(
          controller: _searchController,
          onChanged: _onSearchChanged,
          onClear: () => _onSearchChanged(''),
          isLoading: false,
        ),

        // Contact list
        Expanded(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Recent contacts section (only when not searching)
              if (!_isSearching && _recentContacts.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: ContactSectionHeaderWidget(
                    title: 'RECENT',
                    count: _recentContacts.length,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final contact = _recentContacts[index];
                      final isSelected =
                          _selectedContacts.any((c) => c.id == contact.id);

                      return ContactItemWidget(
                        name: contact.name,
                        phoneNumber: contact.phoneNumber,
                        username: contact.username,
                        avatarUrl: contact.avatarUrl,
                        isOnline: contact.isOnline,
                        lastSeen: contact.lastSeen,
                        isSecureChatUser: contact.isSecureChatUser,
                        isSelected: isSelected,
                        isMultiSelectMode: _isMultiSelectMode,
                        onTap: () => _onContactTap(contact),
                        onLongPress: () => _onContactLongPress(contact),
                        onSelectionChanged: (selected) =>
                            _toggleContactSelection(contact),
                      );
                    },
                    childCount: _recentContacts.length,
                  ),
                ),
              ],

              // All contacts section
              SliverToBoxAdapter(
                child: ContactSectionHeaderWidget(
                  title: _isSearching ? 'SEARCH RESULTS' : 'ALL CONTACTS',
                  count: _filteredContacts.length,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final contact = _filteredContacts[index];
                    final isSelected =
                        _selectedContacts.any((c) => c.id == contact.id);

                    return ContactItemWidget(
                      name: contact.name,
                      phoneNumber: contact.phoneNumber,
                      username: contact.username,
                      avatarUrl: contact.avatarUrl,
                      isOnline: contact.isOnline,
                      lastSeen: contact.lastSeen,
                      isSecureChatUser: contact.isSecureChatUser,
                      isSelected: isSelected,
                      isMultiSelectMode: _isMultiSelectMode,
                      onTap: () => _onContactTap(contact),
                      onLongPress: () => _onContactLongPress(contact),
                      onSelectionChanged: (selected) =>
                          _toggleContactSelection(contact),
                    );
                  },
                  childCount: _filteredContacts.length,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget? _buildFloatingActionButton(ThemeData theme) {
    if (_filteredContacts.isEmpty || _isMultiSelectMode) return null;

    return FloatingActionButton.extended(
      onPressed: _inviteFriends,
      backgroundColor: theme.primaryColor,
      foregroundColor: Colors.white,
      elevation: 4,
      label: Text(
        'Invite Friends',
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      icon: const Icon(Icons.person_add),
    );
  }
}

// Contact model
class Contact {
  final String id;
  final String name;
  final String phoneNumber;
  final String? username;
  final String? avatarUrl;
  final bool isOnline;
  final String? lastSeen;
  final bool isSecureChatUser;

  Contact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.username,
    this.avatarUrl,
    this.isOnline = false,
    this.lastSeen,
    this.isSecureChatUser = false,
  });
}