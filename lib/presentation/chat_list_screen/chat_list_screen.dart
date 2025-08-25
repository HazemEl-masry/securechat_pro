import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/archived_chats_widget.dart';
import './widgets/bottom_navigation_widget.dart';
import './widgets/chat_list_item_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/network_status_widget.dart';
import './widgets/search_bar_widget.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen>
    with TickerProviderStateMixin {
  int _currentBottomNavIndex = 0;
  String _searchQuery = '';
  bool _isConnected = true;
  bool _isConnecting = false;
  bool _isRefreshing = false;

  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  // Mock data for chat list
  final List<Map<String, dynamic>> _allChats = [
    {
      "id": 1,
      "name": "Sarah Johnson",
      "lastMessage":
          "Hey! Are we still on for dinner tonight? I found this amazing new restaurant downtown.",
      "timestamp": "2:30 PM",
      "unreadCount": 2,
      "avatarUrl":
          "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=400",
      "isOnline": true,
      "isTyping": false,
      "isEncrypted": true,
      "isPinned": true,
      "isMuted": false,
      "messageStatus": "read"
    },
    {
      "id": 2,
      "name": "Michael Chen",
      "lastMessage":
          "The project files have been uploaded to the secure server. Please review when you get a chance.",
      "timestamp": "1:45 PM",
      "unreadCount": 0,
      "avatarUrl":
          "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=400",
      "isOnline": false,
      "isTyping": false,
      "isEncrypted": true,
      "isPinned": false,
      "isMuted": false,
      "messageStatus": "delivered"
    },
    {
      "id": 3,
      "name": "Emma Rodriguez",
      "lastMessage": "Thanks for the birthday wishes! The party was amazing 🎉",
      "timestamp": "12:20 PM",
      "unreadCount": 0,
      "avatarUrl":
          "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
      "isOnline": true,
      "isTyping": true,
      "isEncrypted": true,
      "isPinned": false,
      "isMuted": false,
      "messageStatus": "sent"
    },
    {
      "id": 4,
      "name": "David Wilson",
      "lastMessage":
          "Can you send me the meeting notes from yesterday's conference call?",
      "timestamp": "11:30 AM",
      "unreadCount": 1,
      "avatarUrl":
          "https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg?auto=compress&cs=tinysrgb&w=400",
      "isOnline": false,
      "isTyping": false,
      "isEncrypted": true,
      "isPinned": false,
      "isMuted": true,
      "messageStatus": "read"
    },
    {
      "id": 5,
      "name": "Lisa Thompson",
      "lastMessage":
          "The encryption keys have been updated. All messages are now fully secure.",
      "timestamp": "10:15 AM",
      "unreadCount": 0,
      "avatarUrl":
          "https://images.pexels.com/photos/1130626/pexels-photo-1130626.jpeg?auto=compress&cs=tinysrgb&w=400",
      "isOnline": true,
      "isTyping": false,
      "isEncrypted": true,
      "isPinned": false,
      "isMuted": false,
      "messageStatus": "delivered"
    },
    {
      "id": 6,
      "name": "Alex Kumar",
      "lastMessage":
          "Ghost mode is now active. Your online status is hidden from all contacts.",
      "timestamp": "9:45 AM",
      "unreadCount": 3,
      "avatarUrl":
          "https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg?auto=compress&cs=tinysrgb&w=400",
      "isOnline": false,
      "isTyping": false,
      "isEncrypted": true,
      "isPinned": true,
      "isMuted": false,
      "messageStatus": "read"
    },
    {
      "id": 7,
      "name": "Rachel Green",
      "lastMessage": "Voice message received - tap to play securely",
      "timestamp": "Yesterday",
      "unreadCount": 0,
      "avatarUrl":
          "https://images.pexels.com/photos/1036623/pexels-photo-1036623.jpeg?auto=compress&cs=tinysrgb&w=400",
      "isOnline": false,
      "isTyping": false,
      "isEncrypted": true,
      "isPinned": false,
      "isMuted": false,
      "messageStatus": "sent"
    },
    {
      "id": 8,
      "name": "James Park",
      "lastMessage":
          "Anti-delete protection enabled. All messages are now preserved.",
      "timestamp": "Yesterday",
      "unreadCount": 0,
      "avatarUrl":
          "https://images.pexels.com/photos/1212984/pexels-photo-1212984.jpeg?auto=compress&cs=tinysrgb&w=400",
      "isOnline": true,
      "isTyping": false,
      "isEncrypted": true,
      "isPinned": false,
      "isMuted": false,
      "messageStatus": "delivered"
    }
  ];

  List<Map<String, dynamic>> _filteredChats = [];
  final int _archivedCount = 5;

  @override
  void initState() {
    super.initState();
    _filteredChats = List.from(_allChats);

    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fabAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    ));

    _fabAnimationController.forward();

    // Simulate network status changes
    _simulateNetworkChanges();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _simulateNetworkChanges() {
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _isConnected = false;
          _isConnecting = true;
        });

        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _isConnected = true;
              _isConnecting = false;
            });
          }
        });
      }
    });
  }

  void _filterChats(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredChats = List.from(_allChats);
      } else {
        _filteredChats = _allChats.where((chat) {
          final name = (chat['name'] as String).toLowerCase();
          final message = (chat['lastMessage'] as String).toLowerCase();
          final searchLower = query.toLowerCase();
          return name.contains(searchLower) || message.contains(searchLower);
        }).toList();
      }
    });
  }

  Future<void> _refreshChats() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate network refresh
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isRefreshing = false;
        // Simulate new message
        if (_allChats.isNotEmpty) {
          _allChats[0]['unreadCount'] =
              (_allChats[0]['unreadCount'] as int) + 1;
          _allChats[0]['timestamp'] = 'now';
        }
      });
      _filterChats(_searchQuery);
    }
  }

  void _onChatTap(Map<String, dynamic> chatData) {
    Navigator.pushNamed(context, '/chat-conversation-screen');
  }

  void _onChatLongPress(Map<String, dynamic> chatData) {
    _showChatOptionsBottomSheet(chatData);
  }

  void _onChatDismissed(
      DismissDirection direction, Map<String, dynamic> chatData) {
    setState(() {
      _allChats.removeWhere((chat) => chat['id'] == chatData['id']);
      _filterChats(_searchQuery);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Chat with ${chatData['name']} archived'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _allChats.add(chatData);
              _filterChats(_searchQuery);
            });
          },
        ),
      ),
    );
  }

  void _showChatOptionsBottomSheet(Map<String, dynamic> chatData) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.textMediumEmphasisLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            _buildBottomSheetOption(
              iconName: 'mark_email_read',
              title: 'Mark as Read',
              onTap: () => Navigator.pop(context),
            ),
            _buildBottomSheetOption(
              iconName: 'push_pin',
              title: chatData['isPinned'] ? 'Unpin Chat' : 'Pin Chat',
              onTap: () => Navigator.pop(context),
            ),
            _buildBottomSheetOption(
              iconName: 'volume_off',
              title: chatData['isMuted'] ? 'Unmute' : 'Mute',
              onTap: () => Navigator.pop(context),
            ),
            _buildBottomSheetOption(
              iconName: 'archive',
              title: 'Archive Chat',
              onTap: () => Navigator.pop(context),
            ),
            _buildBottomSheetOption(
              iconName: 'block',
              title: 'Block Contact',
              onTap: () => Navigator.pop(context),
              isDestructive: true,
            ),
            _buildBottomSheetOption(
              iconName: 'file_download',
              title: 'Export Chat',
              onTap: () => Navigator.pop(context),
            ),
            _buildBottomSheetOption(
              iconName: 'delete',
              title: 'Delete Chat',
              onTap: () => Navigator.pop(context),
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetOption({
    required String iconName,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: isDestructive
            ? AppTheme.errorColor
            : AppTheme.textHighEmphasisLight,
        size: 6.w,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDestructive
                  ? AppTheme.errorColor
                  : AppTheme.textHighEmphasisLight,
            ),
      ),
      onTap: onTap,
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });

    // Navigate to different screens based on index
    switch (index) {
      case 0:
        // Already on chats screen
        break;
      case 1:
        // Navigate to status screen
        break;
      case 2:
        // Navigate to calls screen
        break;
      case 3:
        // Navigate to settings screen
        break;
    }
  }

  void _onNewChatTap() {
    // Navigate to contact selection screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening contact selection...'),
      ),
    );
  }

  void _onFilterTap() {
    _showFilterBottomSheet();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 10.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.textMediumEmphasisLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Filter Chats',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 2.h),
            _buildFilterOption('All Chats', true),
            _buildFilterOption('Unread', false),
            _buildFilterOption('Groups', false),
            _buildFilterOption('Archived', false),
            _buildFilterOption('Muted', false),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String title, bool isSelected) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isSelected
                  ? AppTheme.primaryLight
                  : AppTheme.textHighEmphasisLight,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
      ),
      trailing: isSelected
          ? CustomIconWidget(
              iconName: 'check',
              color: AppTheme.primaryLight,
              size: 5.w,
            )
          : null,
      onTap: () => Navigator.pop(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // Network status indicator
          NetworkStatusWidget(
            isConnected: _isConnected,
            isConnecting: _isConnecting,
          ),

          // App bar
          SafeArea(
            bottom: false,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'SecureChat Pro',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primaryLight,
                              ),
                    ),
                  ),
                  CustomIconWidget(
                    iconName: 'security',
                    color: AppTheme.successColor,
                    size: 6.w,
                  ),
                  SizedBox(width: 2.w),
                  GestureDetector(
                    onTap: () {
                      // Navigate to profile or settings
                    },
                    child: Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: 'person',
                          color: AppTheme.primaryLight,
                          size: 5.w,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Search bar
          SearchBarWidget(
            onSearchChanged: _filterChats,
            onFilterTap: _onFilterTap,
          ),

          // Chat list
          Expanded(
            child: _filteredChats.isEmpty && _searchQuery.isNotEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'search_off',
                          color: AppTheme.textMediumEmphasisLight,
                          size: 15.w,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'No chats found',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppTheme.textMediumEmphasisLight,
                                  ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Try searching with different keywords',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textMediumEmphasisLight,
                                  ),
                        ),
                      ],
                    ),
                  )
                : _allChats.isEmpty
                    ? EmptyStateWidget(onStartChat: _onNewChatTap)
                    : RefreshIndicator(
                        onRefresh: _refreshChats,
                        color: AppTheme.primaryLight,
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: _filteredChats.length +
                              (_archivedCount > 0 ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == 0 && _archivedCount > 0) {
                              return ArchivedChatsWidget(
                                archivedCount: _archivedCount,
                                onTap: () {
                                  // Navigate to archived chats
                                },
                              );
                            }

                            final chatIndex =
                                _archivedCount > 0 ? index - 1 : index;
                            final chatData = _filteredChats[chatIndex];

                            return ChatListItemWidget(
                              chatData: chatData,
                              onTap: () => _onChatTap(chatData),
                              onLongPress: () => _onChatLongPress(chatData),
                              onDismissed: (direction) =>
                                  _onChatDismissed(direction, chatData),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),

      // Bottom navigation
      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: _currentBottomNavIndex,
        onTap: _onBottomNavTap,
      ),

      // Floating action button
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: FloatingActionButton(
          onPressed: _onNewChatTap,
          child: CustomIconWidget(
            iconName: 'add',
            color: Colors.white,
            size: 7.w,
          ),
        ),
      ),
    );
  }
}
