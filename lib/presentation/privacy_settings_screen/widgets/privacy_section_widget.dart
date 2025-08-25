import 'package:flutter/material.dart';

class PrivacySectionWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> items;
  final VoidCallback? onSectionTap;
  final bool isExpanded;

  const PrivacySectionWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.items,
    this.onSectionTap,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha(51),
        ),
      ),
      child: Column(
        children: [
          // Section header
          InkWell(
            onTap: onSectionTap,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).colorScheme.primary.withAlpha(26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  if (onSectionTap != null) ...[
                    Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Section items
          if (isExpanded) ...[
            Divider(
              height: 1,
              thickness: 1,
              color: Theme.of(context).colorScheme.outline.withAlpha(26),
            ),
            ...items.map((item) => Column(
                  children: [
                    item,
                    if (items.indexOf(item) < items.length - 1)
                      Divider(
                        height: 1,
                        thickness: 1,
                        indent: 16,
                        endIndent: 16,
                        color:
                            Theme.of(context).colorScheme.outline.withAlpha(13),
                      ),
                  ],
                )),
          ],
        ],
      ),
    );
  }
}
