import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupPhotoPickerWidget extends StatefulWidget {
  final String? imageUrl;
  final ValueChanged<String?>? onImageSelected;
  final double size;

  const GroupPhotoPickerWidget({
    super.key,
    this.imageUrl,
    this.onImageSelected,
    this.size = 80,
  });

  @override
  State<GroupPhotoPickerWidget> createState() => _GroupPhotoPickerWidgetState();
}

class _GroupPhotoPickerWidgetState extends State<GroupPhotoPickerWidget>
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

  void _showPhotoOptions() {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'Group Photo',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),

            // Photo options
            _buildPhotoOption(
              context: context,
              icon: Icons.camera_alt,
              title: 'Take Photo',
              onTap: () {
                Navigator.pop(context);
                _selectFromCamera();
              },
            ),
            const SizedBox(height: 8),

            _buildPhotoOption(
              context: context,
              icon: Icons.photo_library,
              title: 'Choose from Gallery',
              onTap: () {
                Navigator.pop(context);
                _selectFromGallery();
              },
            ),

            if (widget.imageUrl != null) ...[
              const SizedBox(height: 8),
              _buildPhotoOption(
                context: context,
                icon: Icons.delete_outline,
                title: 'Remove Photo',
                isDestructive: true,
                onTap: () {
                  Navigator.pop(context);
                  widget.onImageSelected?.call(null);
                },
              ),
            ],

            const SizedBox(height: 20),

            // Cancel button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),

            // Bottom padding for safe area
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.dividerColor.withValues(alpha: 0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive
                  ? theme.colorScheme.error
                  : theme.colorScheme.onSurface,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDestructive
                    ? theme.colorScheme.error
                    : theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectFromCamera() {
    // Simulate camera selection
    final mockImageUrl =
        'https://images.unsplash.com/photo-1522075469751-3847de29be54?w=200&h=200&fit=crop&crop=face';
    widget.onImageSelected?.call(mockImageUrl);
  }

  void _selectFromGallery() {
    // Simulate gallery selection
    final mockImageUrls = [
      'https://images.unsplash.com/photo-1522075469751-3847de29be54?w=200&h=200&fit=crop&crop=face',
      'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=200&h=200&fit=crop&crop=face',
      'https://images.unsplash.com/photo-1521146764736-56c929d59c83?w=200&h=200&fit=crop&crop=face',
    ];
    final selectedImage = (mockImageUrls..shuffle()).first;
    widget.onImageSelected?.call(selectedImage);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            onTap: _showPhotoOptions,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.primaryColor.withValues(alpha: 0.1),
                border: Border.all(
                  color: theme.primaryColor.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: widget.imageUrl != null
                  ? Stack(
                      children: [
                        ClipOval(
                          child: Image.network(
                            widget.imageUrl!,
                            width: widget.size,
                            height: widget.size,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildDefaultContent(theme);
                            },
                          ),
                        ),

                        // Edit overlay
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withValues(alpha: 0.3),
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: widget.size * 0.3,
                            ),
                          ),
                        ),
                      ],
                    )
                  : _buildDefaultContent(theme),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDefaultContent(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.camera_alt,
          size: widget.size * 0.3,
          color: theme.primaryColor,
        ),
        const SizedBox(height: 4),
        Text(
          'Add Photo',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: theme.primaryColor,
          ),
        ),
      ],
    );
  }
}
