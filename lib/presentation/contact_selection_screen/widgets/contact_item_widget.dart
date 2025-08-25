import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class ContactItemWidget extends StatefulWidget {
  final String name;
  final String phoneNumber;
  final String? username;
  final String? avatarUrl;
  final bool isOnline;
  final String? lastSeen;
  final bool isSecureChatUser;
  final bool isSelected;
  final bool isMultiSelectMode;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onSelectionChanged;

  const ContactItemWidget({
    super.key,
    required this.name,
    required this.phoneNumber,
    this.username,
    this.avatarUrl,
    this.isOnline = false,
    this.lastSeen,
    this.isSecureChatUser = false,
    this.isSelected = false,
    this.isMultiSelectMode = false,
    this.onTap,
    this.onLongPress,
    this.onSelectionChanged,
  });

  @override
  State<ContactItemWidget> createState() => _ContactItemWidgetState();
}

class _ContactItemWidgetState extends State<ContactItemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            onTap: widget.isMultiSelectMode
                ? () => widget.onSelectionChanged?.call(!widget.isSelected)
                : widget.onTap,
            onLongPress: widget.onLongPress,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? theme.primaryColor.withValues(alpha: 0.1)
                    : _isPressed
                        ? (isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.black.withValues(alpha: 0.05))
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Selection checkbox (if in multi-select mode)
                  if (widget.isMultiSelectMode) ...[
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: widget.isSelected
                              ? theme.primaryColor
                              : theme.dividerColor,
                          width: 2,
                        ),
                        color: widget.isSelected
                            ? theme.primaryColor
                            : Colors.transparent,
                      ),
                      child: widget.isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                  ],

                  // Avatar
                  _buildAvatar(theme, isDark),
                  const SizedBox(width: 16),

                  // Contact info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name with SecureChat badge
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.name,
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: theme.colorScheme.onSurface,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (widget.isSecureChatUser) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.primaryColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'SecureChat',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),

                        // Phone number or username
                        Text(
                          widget.username != null
                              ? '@${widget.username}'
                              : widget.phoneNumber,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Online status and last seen
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Online indicator
                      if (widget.isOnline)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: const Color(0xFF00C851),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.scaffoldBackgroundColor,
                              width: 1,
                            ),
                          ),
                        )
                      else if (widget.lastSeen != null)
                        Text(
                          widget.lastSeen!,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: theme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.6),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatar(ThemeData theme, bool isDark) {
    return Stack(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.primaryColor.withValues(alpha: 0.1),
            border: Border.all(
              color: theme.dividerColor.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: widget.avatarUrl != null
              ? ClipOval(
                  child: Image.network(
                    widget.avatarUrl!,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildDefaultAvatar(theme);
                    },
                  ),
                )
              : _buildDefaultAvatar(theme),
        ),

        // Online status indicator
        if (widget.isOnline)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: const Color(0xFF00C851),
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.scaffoldBackgroundColor,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDefaultAvatar(ThemeData theme) {
    return Center(
      child: Text(
        widget.name.isNotEmpty ? widget.name[0].toUpperCase() : '?',
        style: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: theme.primaryColor,
        ),
      ),
    );
  }
}
