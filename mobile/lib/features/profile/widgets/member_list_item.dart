import 'package:flutter/material.dart';
import '../../../../shared/widgets/modern_card.dart';
import '../../../../core/models/user_model.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

class MemberListItem extends StatelessWidget {
  final UserModel member;

  const MemberListItem({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ModernCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              child: Icon(PhosphorIconsRegular.user, color: theme.colorScheme.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    member.role,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: member.role.toLowerCase() == 'admin' 
                        ? theme.colorScheme.primary 
                        : theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
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
