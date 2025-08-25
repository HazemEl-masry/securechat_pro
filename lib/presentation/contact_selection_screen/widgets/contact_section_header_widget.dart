import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactSectionHeaderWidget extends StatelessWidget {
  final String title;
  final int count;
  final bool isSticky;

  const ContactSectionHeaderWidget({
    super.key,
    required this.title,
    this.count = 0,
    this.isSticky = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: isSticky
            ? (isDark
                ? const Color(0xFF1A1A1A).withValues(alpha: 0.95)
                : const Color(0xFFFFFFFF).withValues(alpha: 0.95))
            : Colors.transparent,
        border: isSticky
            ? Border(
                bottom: BorderSide(
                  color: theme.dividerColor.withValues(alpha: 0.3),
                  width: 0.5,
                ),
              )
            : null,
      ),
      child: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.primaryColor,
              letterSpacing: 0.5,
            ),
          ),
          if (count > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: theme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                count.toString(),
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: theme.primaryColor,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
