import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/models/family_model.dart';
import '../../../../core/models/join_request_model.dart';
import '../../../../core/providers/family_providers.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../providers/auth_provider.dart';

class JoinFamilyScreen extends ConsumerStatefulWidget {
  const JoinFamilyScreen({super.key});

  @override
  ConsumerState<JoinFamilyScreen> createState() => _JoinFamilyScreenState();
}

class _JoinFamilyScreenState extends ConsumerState<JoinFamilyScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  FamilyModel? _foundFamily;
  String? _error;
  bool _requestSent = false;

  void _searchFamily() async {
    final familyId = _searchController.text.trim();
    if (familyId.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repo = ref.read(familyRepositoryProvider);
      final family = await repo.getFamily(familyId);
      
      setState(() {
        _foundFamily = family;
        if (family == null) {
          _error = 'No family found with this ID.';
        }
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _requestToJoin() async {
    if (_foundFamily == null) return;
    
    setState(() => _isLoading = true);

    try {
      final userModel = await ref.read(currentUserModelProvider.future);
      if (userModel == null) throw Exception("User not found");

      final request = JoinRequestModel(
        id: userModel.uid,
        familyId: _foundFamily!.id,
        userId: userModel.uid,
        userName: userModel.name,
        userPhone: userModel.phone,
        createdAt: DateTime.now(),
      );

      final repo = ref.read(familyRepositoryProvider);
      await repo.createJoinRequest(_foundFamily!.id, request);
      
      setState(() {
        _requestSent = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Join a Family'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: _requestSent 
            ? _buildRequestSentState(theme)
            : _buildSearchState(theme),
        ),
      ),
    );
  }

  Widget _buildSearchState(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Connect with your household',
          style: theme.textTheme.displayMedium,
        ),
        const SizedBox(height: 12),
        Text(
          'Enter your Family ID to request access.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Family ID',
                  hintText: 'e.g. fam_12345',
                ),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _searchFamily,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
              child: _isLoading && _foundFamily == null
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Search'),
            ),
          ],
        ),
        if (_error != null) ...[
          const SizedBox(height: 16),
          Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
        ],
        if (_foundFamily != null) ...[
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Found Family:', style: theme.textTheme.labelMedium),
                const SizedBox(height: 8),
                Text(_foundFamily!.name, style: theme.textTheme.titleLarge),
                Text('${_foundFamily!.houseName}, Ward ${_foundFamily!.wardNumber}'),
                const SizedBox(height: 16),
                PrimaryButton(
                  text: 'Request to Join',
                  isLoading: _isLoading,
                  onPressed: _requestToJoin,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRequestSentState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, size: 64, color: theme.colorScheme.primary),
          const SizedBox(height: 24),
          Text('Request Sent!', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 16),
          Text(
            'Your family admin will need to approve your request before you can enter the community.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            text: 'Check Status',
            onPressed: () {
              // Check again if we're authenticated
              ref.read(authProvider.notifier).build();
            },
          ),
        ],
      ),
    );
  }
}
