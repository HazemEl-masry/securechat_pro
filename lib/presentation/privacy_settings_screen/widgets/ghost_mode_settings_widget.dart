import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class GhostModeSettingsWidget extends StatefulWidget {
  final bool isEnabled;
  final Function(bool) onToggle;
  final List<String> exceptions;

  const GhostModeSettingsWidget({
    super.key,
    required this.isEnabled,
    required this.onToggle,
    required this.exceptions,
  });

  @override
  State<GhostModeSettingsWidget> createState() =>
      _GhostModeSettingsWidgetState();
}

class _GhostModeSettingsWidgetState extends State<GhostModeSettingsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _colorAnimation = ColorTween(
      begin: Colors.grey.withAlpha(26),
      end: Colors.deepPurple.withAlpha(51),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.isEnabled) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(GhostModeSettingsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isEnabled != oldWidget.isEnabled) {
      if (widget.isEnabled) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: widget.isEnabled
                  ? Colors.deepPurple.withAlpha(26)
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.isEnabled
                    ? Colors.deepPurple.withAlpha(77)
                    : Theme.of(context).colorScheme.outline.withAlpha(51),
                width: 2,
              ),
              boxShadow: widget.isEnabled
                  ? [
                      BoxShadow(
                        color: Colors.deepPurple.withAlpha(26),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: widget.isEnabled
                                  ? Colors.deepPurple.withAlpha(51)
                                  : Colors.grey.withAlpha(26),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.visibility_off,
                              color: widget.isEnabled
                                  ? Colors.deepPurple
                                  : Colors.grey,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Ghost Mode',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: widget.isEnabled
                                                ? Colors.deepPurple
                                                : null,
                                          ),
                                    ),
                                    if (widget.isEnabled) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.deepPurple,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          'ACTIVE',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.isEnabled
                                      ? 'You are invisible to all contacts'
                                      : 'Stay completely invisible while using the app',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: widget.isEnabled
                                            ? Colors.deepPurple.withAlpha(204)
                                            : Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: widget.isEnabled,
                            onChanged: (value) {
                              widget.onToggle(value);
                              HapticFeedback.mediumImpact();
                            },
                            activeColor: Colors.deepPurple,
                            activeTrackColor: Colors.deepPurple.withAlpha(77),
                          ),
                        ],
                      ),
                      if (widget.isEnabled) ...[
                        const SizedBox(height: 20),
                        // Features list
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.withAlpha(13),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              _buildFeatureItem(
                                'Hide online status',
                                'Others won\'t see when you\'re online',
                                Icons.circle,
                              ),
                              const SizedBox(height: 12),
                              _buildFeatureItem(
                                'Hide typing indicators',
                                'Others won\'t see when you\'re typing',
                                Icons.keyboard,
                              ),
                              const SizedBox(height: 12),
                              _buildFeatureItem(
                                'Hide read receipts',
                                'Others won\'t see if you\'ve read their messages',
                                Icons.done_all,
                              ),
                              const SizedBox(height: 12),
                              _buildFeatureItem(
                                'Hide last seen time',
                                'Others won\'t see when you were last active',
                                Icons.access_time,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                if (widget.isEnabled) ...[
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.deepPurple.withAlpha(51),
                  ),

                  // Exceptions section
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.person_add_alt,
                              color: Colors.deepPurple,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Exceptions',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const Spacer(),
                            TextButton.icon(
                              onPressed: () => _showAddExceptionDialog(),
                              icon: const Icon(Icons.add, size: 16),
                              label: const Text('Add'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.deepPurple,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'These contacts will still see your activity',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.deepPurple.withAlpha(179),
                                  ),
                        ),
                        const SizedBox(height: 12),
                        if (widget.exceptions.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.withAlpha(26),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.grey.withAlpha(51),
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.grey[600],
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'No exceptions added. You are invisible to everyone.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          ...widget.exceptions.map((contact) => Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple.withAlpha(13),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.deepPurple.withAlpha(51),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor:
                                          Colors.deepPurple.withAlpha(51),
                                      child: Text(
                                        contact[0].toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.deepPurple,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        contact,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () =>
                                          _removeException(contact),
                                      icon: const Icon(
                                        Icons.close,
                                        size: 16,
                                      ),
                                      iconSize: 16,
                                      constraints: const BoxConstraints(
                                        minWidth: 32,
                                        minHeight: 32,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeatureItem(String title, String subtitle, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.deepPurple.withAlpha(179),
          size: 16,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.deepPurple,
                    ),
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.deepPurple.withAlpha(179),
                    ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.check_circle,
          color: Colors.deepPurple,
          size: 16,
        ),
      ],
    );
  }

  void _showAddExceptionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Exception'),
        content: const Text(
            'Select contacts who can still see your activity even in Ghost Mode.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // In a real app, this would open a contact picker
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Contact picker would open here'),
                ),
              );
            },
            child: const Text('Select Contacts'),
          ),
        ],
      ),
    );
  }

  void _removeException(String contact) {
    // In a real app, this would remove the contact from the exceptions list
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$contact removed from exceptions'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Restore the exception
          },
        ),
      ),
    );
  }
}
