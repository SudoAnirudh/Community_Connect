import 'package:flutter/material.dart';
import '../../../../shared/widgets/modern_card.dart';
import '../../../../shared/widgets/status_badge.dart';

class NoticeCard extends StatelessWidget {
  final Map<String, dynamic> notice;

  const NoticeCard({super.key, required this.notice});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ModernCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: notice['color'].withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                notice['icon'],
                color: notice['color'],
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notice['title'],
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ),
                      if (notice.containsKey('priority')) ...[
                        const SizedBox(width: 8),
                        StatusBadge(
                          text: notice['priority'],
                          priority: notice['priority'],
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notice['description'],
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        notice['time'],
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
