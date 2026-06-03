import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import '../../../../shared/widgets/modern_card.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../../../core/models/family_model.dart';

class FamilyInfoCard extends StatelessWidget {
  final FamilyModel family;

  const FamilyInfoCard({super.key, required this.family});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return ModernCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  PhosphorIconsRegular.house,
                  color: theme.colorScheme.primary,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            family.name,
                            style: theme.textTheme.displayMedium,
                          ),
                        ),
                        if (family.verificationStatus.toLowerCase() == 'approved')
                          Icon(
                            PhosphorIconsFill.sealCheck,
                            color: theme.colorScheme.primary,
                            size: 24,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      family.houseName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    StatusBadge(
                      text: 'Ward ${family.wardNumber}',
                      priority: 'low',
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Family ID: ${family.id.length > 8 ? family.id.substring(0, 8) : family.id}',
                style: theme.textTheme.bodySmall,
              ),
              InkWell(
                onTap: () {},
                child: Text(
                  'Edit Details',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
