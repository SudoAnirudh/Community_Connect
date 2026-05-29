import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/family_model.dart';
import '../../../../core/models/join_request_model.dart';
import '../../../../core/providers/family_providers.dart';

class JoinRequestsWidget extends ConsumerWidget {
  final FamilyModel family;

  const JoinRequestsWidget({super.key, required this.family});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final repo = ref.read(familyRepositoryProvider);
    final userRepo = ref.read(userRepositoryProvider);

    return StreamBuilder<List<JoinRequestModel>>(
      stream: repo.getJoinRequestsStream(family.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final requests = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Join Requests', style: theme.textTheme.displaySmall),
            const SizedBox(height: 12),
            ...requests.map((request) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(request.userName),
                subtitle: Text(request.userPhone),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () async {
                        await repo.updateJoinRequestStatus(family.id, request.id, 'rejected');
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: () async {
                        // Update status to approved
                        await repo.updateJoinRequestStatus(family.id, request.id, 'approved');
                        
                        // Add user to family
                        final updatedFamily = family.copyWith(
                          memberUids: [...family.memberUids, request.userId],
                        );
                        await repo.updateFamily(updatedFamily);
                        
                        // Update user model to set familyId
                        final user = await userRepo.getUser(request.userId);
                        if (user != null) {
                          await userRepo.updateUser(user.copyWith(familyId: family.id));
                        }
                      },
                    ),
                  ],
                ),
              ),
            )).toList(),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}
