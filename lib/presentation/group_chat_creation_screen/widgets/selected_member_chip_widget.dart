import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectedMemberChipWidget extends StatefulWidget {
  final String name;
  final String? avatarUrl;
  final VoidCallback? onRemove;
  final bool isAdmin;

  const SelectedMemberChipWidget({
    super.key,
    required this.name,
    this.avatarUrl,
    this.onRemove,
    this.isAdmin = false,
  });

  @override
  State<SelectedMemberChipWidget> createState() =>
      _SelectedMemberChipWidgetState();
}

class _SelectedMemberChipWidgetState extends State<SelectedMemberChipWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleRemove() {
    _animationController.reverse().then((_) {
      widget.onRemove?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              margin: const EdgeInsets.only(right: 8, bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: widget.isAdmin
                    ? theme.primaryColor.withValues(alpha: 0.1)
                    : (isDark
                        ? const Color(0xFF2D2D2D)
                        : const Color(0xFFF8F9FA)),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: widget.isAdmin
                      ? theme.primaryColor.withValues(alpha: 0.3)
                      : theme.dividerColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Avatar
                  _buildAvatar(theme),
                  const SizedBox(width: 8),

                  // Name
                  Flexible(
                    child: Text(
                      widget.name,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: widget.isAdmin
                            ? theme.primaryColor
                            : theme.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Admin badge
                  if (widget.isAdmin) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Admin',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],

                  // Remove button
                  if (widget.onRemove != null && !widget.isAdmin) ...[
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: _handleRemove,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          size: 14,
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatar(ThemeData theme) {
    return Container(
      width: 24,
      height: 24,
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
                width: 24,
                height: 24,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildDefaultAvatar(theme);
                },
              ),
            )
          : _buildDefaultAvatar(theme),
    );
  }

  Widget _buildDefaultAvatar(ThemeData theme) {
    return Center(
      child: Text(
        widget.name.isNotEmpty ? widget.name[0].toUpperCase() : '?',
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: theme.primaryColor,
        ),
      ),
    );
  }
}
