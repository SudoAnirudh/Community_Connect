import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/mocks/mock_data.dart';
import '../../auth/providers/auth_provider.dart';
import '../widgets/family_info_card.dart';
import '../widgets/member_list_item.dart';
import '../widgets/join_request_card.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  // Local state to manage mock UI interactions
  List<Map<String, dynamic>> _joinRequests = List.from(MockData.joinRequests);

  Future<void> _handleLogout() async {
    await ref.read(authProvider.notifier).signOut();
    if (mounted) {
      context.go('/login');
    }
  }

  void _removeRequest(String requestId) {
    setState(() {
      _joinRequests.removeWhere((req) => req['requestId'] == requestId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FamilyInfoCard(family: MockData.currentFamily),
            const SizedBox(height: 24),
            
            if (_joinRequests.isNotEmpty) ...[
              Text(
                'Join Requests (${_joinRequests.length})',
                style: theme.textTheme.displaySmall,
              ),
              const SizedBox(height: 12),
              ..._joinRequests.map((req) => JoinRequestCard(
                request: req,
                onApprove: () => _removeRequest(req['requestId']),
                onReject: () => _removeRequest(req['requestId']),
              )),
              const SizedBox(height: 24),
            ],

            Text(
              'Verified Members',
              style: theme.textTheme.displaySmall,
            ),
            const SizedBox(height: 12),
            ...MockData.familyMembers.map((member) => MemberListItem(member: member)),
            
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
      ),
    );
  }
}
