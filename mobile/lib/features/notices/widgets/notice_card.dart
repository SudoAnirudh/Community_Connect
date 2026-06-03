import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import '../../../../shared/widgets/modern_card.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../../../core/models/notice_model.dart';

class NoticeCard extends StatelessWidget {
  final NoticeModel notice;

  const NoticeCard({super.key, required this.notice});

  Color _parseColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.tryParse(hex, radix: 16) ?? 0xFF000000);
  }
  
  IconData _parseIcon(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'info': return PhosphorIconsRegular.info;
      case 'warning': return PhosphorIconsRegular.warning;
      case 'check': return PhosphorIconsRegular.checkCircle;
      case 'drop': return PhosphorIconsRegular.drop;
      case 'calendar': return PhosphorIconsRegular.calendar;
      case 'megaphone': return PhosphorIconsRegular.megaphone;
      default: return PhosphorIconsRegular.bell;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _parseColor(notice.colorHex);
    final icon = _parseIcon(notice.icon);
    
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
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
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
                          notice.title,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ),
                      const SizedBox(width: 8),
                      StatusBadge(
                        text: notice.priority,
                        priority: notice.priority,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notice.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        // Just a simple time format
                        '${notice.createdAt.hour}:${notice.createdAt.minute.toString().padLeft(2, '0')}',
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
