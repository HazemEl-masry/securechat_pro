import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MessageInputWidget extends StatefulWidget {
  final Function(String) onSendMessage;
  final Function(String) onSendVoice;
  final Function(String) onSendImage;
  final Function(String) onSendDocument;
  final VoidCallback? onTypingStart;
  final VoidCallback? onTypingStop;

  const MessageInputWidget({
    Key? key,
    required this.onSendMessage,
    required this.onSendVoice,
    required this.onSendImage,
    required this.onSendDocument,
    this.onTypingStart,
    this.onTypingStop,
  }) : super(key: key);

  @override
  State<MessageInputWidget> createState() => _MessageInputWidgetState();
}

class _MessageInputWidgetState extends State<MessageInputWidget>
    with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isRecording = false;
  bool _showAttachmentMenu = false;
  bool _showEmojiPicker = false;
  late AnimationController _recordingAnimationController;
  late Animation<double> _recordingAnimation;

  @override
  void initState() {
    super.initState();
    _recordingAnimationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _recordingAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _recordingAnimationController,
      curve: Curves.easeInOut,
    ));

    _textController.addListener(() {
      if (_textController.text.isNotEmpty) {
        widget.onTypingStart?.call();
      } else {
        widget.onTypingStop?.call();
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    _recordingAnimationController.dispose();
    super.dispose();
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
    });
    _recordingAnimationController.repeat(reverse: true);
    // Start voice recording logic here
  }

  void _stopRecording() {
    setState(() {
      _isRecording = false;
    });
    _recordingAnimationController.stop();
    _recordingAnimationController.reset();
    // Stop recording and send voice message
    widget.onSendVoice('voice_message_path');
  }

  void _sendTextMessage() {
    if (_textController.text.trim().isNotEmpty) {
      widget.onSendMessage(_textController.text.trim());
      _textController.clear();
      widget.onTypingStop?.call();
    }
  }

  void _toggleAttachmentMenu() {
    setState(() {
      _showAttachmentMenu = !_showAttachmentMenu;
      if (_showAttachmentMenu) {
        _showEmojiPicker = false;
      }
    });
  }

  void _toggleEmojiPicker() {
    setState(() {
      _showEmojiPicker = !_showEmojiPicker;
      if (_showEmojiPicker) {
        _showAttachmentMenu = false;
        _focusNode.unfocus();
      } else {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_showAttachmentMenu) _buildAttachmentMenu(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.scaffoldBackgroundColor,
            border: Border(
              top: BorderSide(
                color: AppTheme.lightTheme.dividerColor,
                width: 0.5,
              ),
            ),
          ),
          child: SafeArea(
            child: Row(
              children: [
                GestureDetector(
                  onTap: _toggleEmojiPicker,
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    child: CustomIconWidget(
                      iconName:
                          _showEmojiPicker ? 'keyboard' : 'emoji_emotions',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 6.w,
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Container(
                    constraints: BoxConstraints(maxHeight: 20.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(6.w),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            focusNode: _focusNode,
                            maxLines: null,
                            textInputAction: TextInputAction.newline,
                            decoration: InputDecoration(
                              hintText: 'Type a message...',
                              hintStyle: AppTheme
                                  .lightTheme.inputDecorationTheme.hintStyle,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 4.w, vertical: 2.h),
                            ),
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                        ),
                        GestureDetector(
                          onTap: _toggleAttachmentMenu,
                          child: Container(
                            padding: EdgeInsets.all(2.w),
                            child: CustomIconWidget(
                              iconName: 'attach_file',
                              color: AppTheme.textMediumEmphasisLight,
                              size: 5.w,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                _textController.text.trim().isNotEmpty
                    ? GestureDetector(
                        onTap: _sendTextMessage,
                        child: Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: CustomIconWidget(
                            iconName: 'send',
                            color: Colors.white,
                            size: 5.w,
                          ),
                        ),
                      )
                    : GestureDetector(
                        onLongPressStart: (_) => _startRecording(),
                        onLongPressEnd: (_) => _stopRecording(),
                        child: AnimatedBuilder(
                          animation: _recordingAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _isRecording
                                  ? _recordingAnimation.value
                                  : 1.0,
                              child: Container(
                                padding: EdgeInsets.all(3.w),
                                decoration: BoxDecoration(
                                  color: _isRecording
                                      ? AppTheme.errorColor
                                      : AppTheme.lightTheme.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: CustomIconWidget(
                                  iconName: _isRecording ? 'stop' : 'mic',
                                  color: Colors.white,
                                  size: 5.w,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        ),
        if (_showEmojiPicker) _buildEmojiPicker(),
      ],
    );
  }

  Widget _buildAttachmentMenu() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: AppTheme.lightTheme.dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildAttachmentOption(
            icon: 'photo_camera',
            label: 'Camera',
            color: AppTheme.lightTheme.primaryColor,
            onTap: () {
              widget.onSendImage('camera_image_path');
              _toggleAttachmentMenu();
            },
          ),
          _buildAttachmentOption(
            icon: 'photo_library',
            label: 'Gallery',
            color: AppTheme.successColor,
            onTap: () {
              widget.onSendImage('gallery_image_path');
              _toggleAttachmentMenu();
            },
          ),
          _buildAttachmentOption(
            icon: 'description',
            label: 'Document',
            color: AppTheme.warningColor,
            onTap: () {
              widget.onSendDocument('document_path');
              _toggleAttachmentMenu();
            },
          ),
          _buildAttachmentOption(
            icon: 'location_on',
            label: 'Location',
            color: AppTheme.errorColor,
            onTap: () {
              // Handle location sharing
              _toggleAttachmentMenu();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentOption({
    required String icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: icon,
              color: Colors.white,
              size: 6.w,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: AppTheme.textMediumEmphasisLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiPicker() {
    final emojis = [
      '😀',
      '😂',
      '😍',
      '😢',
      '😡',
      '👍',
      '👎',
      '❤️',
      '🔥',
      '💯',
      '🎉',
      '😎'
    ];

    return Container(
      height: 15.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: AppTheme.lightTheme.dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          crossAxisSpacing: 2.w,
          mainAxisSpacing: 1.h,
        ),
        itemCount: emojis.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _textController.text += emojis[index];
              _textController.selection = TextSelection.fromPosition(
                TextPosition(offset: _textController.text.length),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: Center(
                child: Text(
                  emojis[index],
                  style: TextStyle(fontSize: 18.sp),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
