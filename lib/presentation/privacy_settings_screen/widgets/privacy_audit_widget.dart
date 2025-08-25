import 'package:flutter/material.dart';

class PrivacyAuditWidget extends StatelessWidget {
  final int privacyScore;
  final VoidCallback? onViewDetails;

  const PrivacyAuditWidget({
    super.key,
    required this.privacyScore,
    this.onViewDetails,
  });

  Color _getScoreColor(BuildContext context) {
    if (privacyScore >= 80) {
      return Colors.green;
    } else if (privacyScore >= 60) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  String _getScoreMessage() {
    if (privacyScore >= 80) {
      return 'Excellent Privacy Protection';
    } else if (privacyScore >= 60) {
      return 'Good Privacy Protection';
    } else if (privacyScore >= 40) {
      return 'Moderate Privacy Protection';
    } else {
      return 'Low Privacy Protection';
    }
  }

  IconData _getScoreIcon() {
    if (privacyScore >= 80) {
      return Icons.security;
    } else if (privacyScore >= 60) {
      return Icons.verified_user;
    } else {
      return Icons.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getScoreColor(context).withAlpha(26),
            _getScoreColor(context).withAlpha(13),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getScoreColor(context).withAlpha(77),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getScoreColor(context).withAlpha(51),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getScoreIcon(),
                  color: _getScoreColor(context),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Privacy Score',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getScoreMessage(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: _getScoreColor(context),
                          ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    privacyScore.toString(),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _getScoreColor(context),
                        ),
                  ),
                  Text(
                    '/ 100',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: privacyScore / 100,
              backgroundColor: Colors.grey.withAlpha(51),
              valueColor:
                  AlwaysStoppedAnimation<Color>(_getScoreColor(context)),
              minHeight: 8,
            ),
          ),

          if (onViewDetails != null) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onViewDetails,
                icon: const Icon(Icons.analytics_outlined),
                label: const Text('View Detailed Analysis'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _getScoreColor(context),
                  side: BorderSide(color: _getScoreColor(context)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
