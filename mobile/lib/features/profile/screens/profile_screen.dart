import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../auth/providers/auth_provider.dart';
import '../../../../core/providers/family_providers.dart';
import '../widgets/family_info_card.dart';
import '../widgets/member_list_item.dart';
import '../widgets/join_requests_widget.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {

  Future<void> _handleLogout() async {
    await ref.read(authProvider.notifier).signOut();
    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final familyAsync = ref.watch(currentFamilyProvider);
    final currentUserAsync = ref.watch(currentUserModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Family Profile',
          style: theme.textTheme.displayMedium,
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(PhosphorIconsRegular.gear),
            onPressed: () {},
          ),
        ],
      ),
      body: familyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (family) {
          if (family == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(PhosphorIconsRegular.houseLine, size: 64),
                  const SizedBox(height: 16),
                  Text('Not part of any family.', style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 16),
                  // Logout Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _handleLogout,
                        icon: const Icon(PhosphorIconsRegular.signOut),
                        label: const Text('Log Out'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: theme.colorScheme.error,
                          side: BorderSide(color: theme.colorScheme.error.withOpacity(0.5)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FamilyInfoCard(family: family),
                const SizedBox(height: 24),
                
                currentUserAsync.when(
                  data: (user) {
                    if (user != null && user.uid == family.adminUid) {
                      return JoinRequestsWidget(family: family);
                    }
                    return const SizedBox.shrink();
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),

                Text(
                  'Verified Members',
                  style: theme.textTheme.displaySmall,
                ),
                const SizedBox(height: 12),
                
                // Show current user as a member for now
                currentUserAsync.when(
                  data: (user) => user != null ? MemberListItem(member: user) : const SizedBox(),
                  loading: () => const CircularProgressIndicator(),
                  error: (_, __) => const SizedBox(),
                ),
                
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 16),
                
                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _handleLogout,
                    icon: const Icon(PhosphorIconsRegular.signOut),
                    label: const Text('Log Out'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                      side: BorderSide(color: theme.colorScheme.error.withOpacity(0.5)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
