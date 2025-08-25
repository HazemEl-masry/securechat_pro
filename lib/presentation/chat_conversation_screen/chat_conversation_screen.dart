import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/chat_app_bar_widget.dart';
import './widgets/emoji_reaction_picker_widget.dart';
import './widgets/message_bubble_widget.dart';
import './widgets/message_context_menu_widget.dart';
import './widgets/message_input_widget.dart';

class ChatConversationScreen extends StatefulWidget {
  const ChatConversationScreen({Key? key}) : super(key: key);

  @override
  State<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  Map<String, dynamic>? _selectedMessage;
  bool _showContextMenu = false;
  bool _showEmojiPicker = false;
  String _currentUserId = 'user_1';

  // Mock contact data
  final Map<String, dynamic> _contact = {
    'id': 'contact_1',
    'name': 'Sarah Johnson',
    'avatar':
        'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
    'isOnline': true,
    'lastSeen': DateTime.now().subtract(Duration(minutes: 5)),
    'isTyping': false,
  };

  @override
  void initState() {
    super.initState();
    _loadMockMessages();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMockMessages() {
    final mockMessages = [
      {
        'id': 'msg_1',
        'senderId': 'contact_1',
        'senderName': 'Sarah Johnson',
        'senderAvatar':
            'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
        'content': 'Hey! How are you doing today?',
        'type': 'text',
        'timestamp': DateTime.now().subtract(Duration(hours: 2)),
        'isDelivered': true,
        'isRead': true,
        'reactions': [],
        'isStarred': false,
      },
      {
        'id': 'msg_2',
        'senderId': _currentUserId,
        'senderName': 'You',
        'senderAvatar':
            'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
        'content':
            'I\'m doing great! Just finished a big project at work. How about you?',
        'type': 'text',
        'timestamp': DateTime.now().subtract(Duration(hours: 1, minutes: 45)),
        'isDelivered': true,
        'isRead': true,
        'reactions': [
          {
            'emoji': '👍',
            'count': 1,
            'users': ['contact_1']
          },
        ],
        'isStarred': false,
      },
      {
        'id': 'msg_3',
        'senderId': 'contact_1',
        'senderName': 'Sarah Johnson',
        'senderAvatar':
            'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
        'content':
            'That\'s awesome! Congratulations on finishing your project. I\'ve been working on some new designs for our upcoming campaign.',
        'type': 'text',
        'timestamp': DateTime.now().subtract(Duration(hours: 1, minutes: 30)),
        'isDelivered': true,
        'isRead': true,
        'reactions': [],
        'isStarred': true,
      },
      {
        'id': 'msg_4',
        'senderId': _currentUserId,
        'senderName': 'You',
        'senderAvatar':
            'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
        'imageUrl':
            'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=500&h=300&fit=crop',
        'caption': 'Check out this beautiful sunset I captured yesterday!',
        'type': 'image',
        'timestamp': DateTime.now().subtract(Duration(hours: 1, minutes: 15)),
        'isDelivered': true,
        'isRead': true,
        'reactions': [
          {
            'emoji': '😍',
            'count': 1,
            'users': ['contact_1']
          },
          {
            'emoji': '🔥',
            'count': 1,
            'users': ['contact_1']
          },
        ],
        'isStarred': false,
      },
      {
        'id': 'msg_5',
        'senderId': 'contact_1',
        'senderName': 'Sarah Johnson',
        'senderAvatar':
            'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
        'content':
            'Wow, that\'s absolutely stunning! Where did you take this photo?',
        'type': 'text',
        'timestamp': DateTime.now().subtract(Duration(hours: 1)),
        'isDelivered': true,
        'isRead': true,
        'reactions': [],
        'isStarred': false,
      },
      {
        'id': 'msg_6',
        'senderId': _currentUserId,
        'senderName': 'You',
        'senderAvatar':
            'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
        'fileName': 'Project_Report_Final.pdf',
        'fileSize': '2.4 MB',
        'type': 'document',
        'timestamp': DateTime.now().subtract(Duration(minutes: 45)),
        'isDelivered': true,
        'isRead': false,
        'reactions': [],
        'isStarred': false,
      },
      {
        'id': 'msg_7',
        'senderId': _currentUserId,
        'senderName': 'You',
        'senderAvatar':
            'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
        'duration': 45,
        'isPlaying': false,
        'type': 'voice',
        'timestamp': DateTime.now().subtract(Duration(minutes: 30)),
        'isDelivered': true,
        'isRead': false,
        'reactions': [],
        'isStarred': false,
      },
      {
        'id': 'msg_8',
        'senderId': 'contact_1',
        'senderName': 'Sarah Johnson',
        'senderAvatar':
            'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
        'content':
            'Thanks for sharing the report! I\'ll review it and get back to you with feedback.',
        'type': 'text',
        'timestamp': DateTime.now().subtract(Duration(minutes: 15)),
        'isDelivered': true,
        'isRead': true,
        'reactions': [],
        'isStarred': false,
        'replyTo': {
          'messageId': 'msg_6',
          'senderName': 'You',
          'content': 'Project_Report_Final.pdf',
        },
      },
      {
        'id': 'msg_9',
        'senderId': _currentUserId,
        'senderName': 'You',
        'senderAvatar':
            'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
        'content':
            'Perfect! Take your time. Let me know if you have any questions.',
        'type': 'text',
        'timestamp': DateTime.now().subtract(Duration(minutes: 5)),
        'isDelivered': true,
        'isRead': false,
        'reactions': [],
        'isStarred': false,
      },
    ];

    setState(() {
      _messages.addAll(mockMessages.reversed);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage(String content) {
    if (content.trim().isEmpty) return;

    final newMessage = {
      'id': 'msg_${DateTime.now().millisecondsSinceEpoch}',
      'senderId': _currentUserId,
      'senderName': 'You',
      'senderAvatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
      'content': content,
      'type': 'text',
      'timestamp': DateTime.now(),
      'isDelivered': false,
      'isRead': false,
      'reactions': [],
      'isStarred': false,
    };

    setState(() {
      _messages.add(newMessage);
    });

    _scrollToBottom();

    // Simulate message delivery
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        final messageIndex =
            _messages.indexWhere((msg) => msg['id'] == newMessage['id']);
        if (messageIndex != -1) {
          _messages[messageIndex]['isDelivered'] = true;
        }
      });
    });

    // Simulate read receipt
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        final messageIndex =
            _messages.indexWhere((msg) => msg['id'] == newMessage['id']);
        if (messageIndex != -1) {
          _messages[messageIndex]['isRead'] = true;
        }
      });
    });
  }

  void _sendVoiceMessage(String voicePath) {
    final newMessage = {
      'id': 'msg_${DateTime.now().millisecondsSinceEpoch}',
      'senderId': _currentUserId,
      'senderName': 'You',
      'senderAvatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
      'duration': 30,
      'isPlaying': false,
      'type': 'voice',
      'timestamp': DateTime.now(),
      'isDelivered': false,
      'isRead': false,
      'reactions': [],
      'isStarred': false,
    };

    setState(() {
      _messages.add(newMessage);
    });

    _scrollToBottom();
  }

  void _sendImageMessage(String imagePath) {
    final newMessage = {
      'id': 'msg_${DateTime.now().millisecondsSinceEpoch}',
      'senderId': _currentUserId,
      'senderName': 'You',
      'senderAvatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
      'imageUrl':
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=500&h=300&fit=crop',
      'caption': '',
      'type': 'image',
      'timestamp': DateTime.now(),
      'isDelivered': false,
      'isRead': false,
      'reactions': [],
      'isStarred': false,
    };

    setState(() {
      _messages.add(newMessage);
    });

    _scrollToBottom();
  }

  void _sendDocumentMessage(String documentPath) {
    final newMessage = {
      'id': 'msg_${DateTime.now().millisecondsSinceEpoch}',
      'senderId': _currentUserId,
      'senderName': 'You',
      'senderAvatar':
          'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
      'fileName': 'Document.pdf',
      'fileSize': '1.2 MB',
      'type': 'document',
      'timestamp': DateTime.now(),
      'isDelivered': false,
      'isRead': false,
      'reactions': [],
      'isStarred': false,
    };

    setState(() {
      _messages.add(newMessage);
    });

    _scrollToBottom();
  }

  void _handleMessageLongPress(Map<String, dynamic> message) {
    setState(() {
      _selectedMessage = message;
      _showContextMenu = true;
      _showEmojiPicker = false;
    });
  }

  void _handleMessageReact(Map<String, dynamic> message) {
    setState(() {
      _selectedMessage = message;
      _showEmojiPicker = true;
      _showContextMenu = false;
    });
  }

  void _addReactionToMessage(String emoji) {
    if (_selectedMessage == null) return;

    setState(() {
      final messageIndex =
          _messages.indexWhere((msg) => msg['id'] == _selectedMessage!['id']);
      if (messageIndex != -1) {
        final reactions = _messages[messageIndex]['reactions'] as List<dynamic>;
        final existingReactionIndex =
            reactions.indexWhere((reaction) => reaction['emoji'] == emoji);

        if (existingReactionIndex != -1) {
          reactions[existingReactionIndex]['count'] =
              (reactions[existingReactionIndex]['count'] as int) + 1;
        } else {
          reactions.add({
            'emoji': emoji,
            'count': 1,
            'users': [_currentUserId],
          });
        }
      }
      _showEmojiPicker = false;
      _selectedMessage = null;
    });
  }

  void _replyToMessage() {
    if (_selectedMessage == null) return;

    // Handle reply functionality
    setState(() {
      _showContextMenu = false;
      _selectedMessage = null;
    });
  }

  void _forwardMessage() {
    if (_selectedMessage == null) return;

    // Handle forward functionality
    setState(() {
      _showContextMenu = false;
      _selectedMessage = null;
    });
  }

  void _copyMessage() {
    if (_selectedMessage == null) return;

    // Handle copy functionality
    setState(() {
      _showContextMenu = false;
      _selectedMessage = null;
    });
  }

  void _deleteMessage() {
    if (_selectedMessage == null) return;

    setState(() {
      _messages.removeWhere((msg) => msg['id'] == _selectedMessage!['id']);
      _showContextMenu = false;
      _selectedMessage = null;
    });
  }

  void _starMessage() {
    if (_selectedMessage == null) return;

    setState(() {
      final messageIndex =
          _messages.indexWhere((msg) => msg['id'] == _selectedMessage!['id']);
      if (messageIndex != -1) {
        _messages[messageIndex]['isStarred'] =
            !(_messages[messageIndex]['isStarred'] as bool);
      }
      _showContextMenu = false;
      _selectedMessage = null;
    });
  }

  void _showMessageInfo() {
    if (_selectedMessage == null) return;

    // Handle message info functionality
    setState(() {
      _showContextMenu = false;
      _selectedMessage = null;
    });
  }

  void _handleCall() {
    // Handle voice call
    Navigator.pushNamed(context, '/voice-call-screen');
  }

  void _handleVideoCall() {
    // Handle video call
    Navigator.pushNamed(context, '/video-call-screen');
  }

  void _handleTypingStart() {
    // Handle typing indicator start
  }

  void _handleTypingStop() {
    // Handle typing indicator stop
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: ChatAppBarWidget(
        contact: _contact,
        onCallPressed: _handleCall,
        onVideoCallPressed: _handleVideoCall,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.scaffoldBackgroundColor,
                  ),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final isCurrentUser =
                          message['senderId'] == _currentUserId;

                      return MessageBubbleWidget(
                        message: message,
                        isCurrentUser: isCurrentUser,
                        onReply: () => _handleMessageReact(message),
                        onReact: () => _handleMessageReact(message),
                        onLongPress: () => _handleMessageLongPress(message),
                      );
                    },
                  ),
                ),
              ),
              MessageInputWidget(
                onSendMessage: _sendMessage,
                onSendVoice: _sendVoiceMessage,
                onSendImage: _sendImageMessage,
                onSendDocument: _sendDocumentMessage,
                onTypingStart: _handleTypingStart,
                onTypingStop: _handleTypingStop,
              ),
            ],
          ),
          if (_showContextMenu && _selectedMessage != null)
            Positioned(
              bottom: 20.h,
              left: 4.w,
              right: 4.w,
              child: MessageContextMenuWidget(
                message: _selectedMessage!,
                isCurrentUser: _selectedMessage!['senderId'] == _currentUserId,
                onReply: _replyToMessage,
                onForward: _forwardMessage,
                onCopy: _copyMessage,
                onDelete: _deleteMessage,
                onStar: _starMessage,
                onInfo: _showMessageInfo,
              ),
            ),
          if (_showEmojiPicker && _selectedMessage != null)
            Positioned(
              bottom: 15.h,
              left: 4.w,
              right: 4.w,
              child: EmojiReactionPickerWidget(
                onEmojiSelected: _addReactionToMessage,
                onClose: () {
                  setState(() {
                    _showEmojiPicker = false;
                    _selectedMessage = null;
                  });
                },
              ),
            ),
          if (_showContextMenu || _showEmojiPicker)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _showContextMenu = false;
                    _showEmojiPicker = false;
                    _selectedMessage = null;
                  });
                },
                child: Container(
                  color: Colors.black.withValues(alpha: 0.3),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
