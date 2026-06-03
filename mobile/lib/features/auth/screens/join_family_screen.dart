import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  final TextEditingController _familyNameController = TextEditingController();
  final TextEditingController _houseNameController = TextEditingController();
  final TextEditingController _wardNumberController = TextEditingController();
  
  bool _isLoading = false;
  FamilyModel? _foundFamily;
  String? _error;
  bool _requestSent = false;

  @override
  void dispose() {
    _searchController.dispose();
    _familyNameController.dispose();
    _houseNameController.dispose();
    _wardNumberController.dispose();
    super.dispose();
  }

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

  void _createFamily() async {
    final familyName = _familyNameController.text.trim();
    final houseName = _houseNameController.text.trim();
    final wardNumber = _wardNumberController.text.trim();

    if (familyName.isEmpty || houseName.isEmpty || wardNumber.isEmpty) {
      setState(() => _error = 'Please fill all fields');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final userModel = await ref.read(currentUserModelProvider.future);
      if (userModel == null) throw Exception("User not found");

      // Generate a Family ID
      final cleanFamily = familyName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').toLowerCase();
      final cleanHouse = houseName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').toLowerCase();
      final randomSuffix = (1000 + DateTime.now().millisecondsSinceEpoch % 9000).toString();
      final generatedId = '${cleanFamily}_${cleanHouse}_$randomSuffix';

      final newFamily = FamilyModel(
        id: generatedId,
        name: familyName,
        houseName: houseName,
        wardNumber: wardNumber,
        adminUid: userModel.uid,
        memberUids: [userModel.uid],
        verificationStatus: 'pending',
      );

      // Save to Firestore
      final familyRepo = ref.read(familyRepositoryProvider);
      await familyRepo.createFamily(newFamily);

      // Update User Model
      final updatedUser = userModel.copyWith(
        familyId: generatedId,
        role: 'admin',
      );
      final userRepo = ref.read(userRepositoryProvider);
      await userRepo.updateUser(updatedUser);

      // Invalidate current user provider so it refreshes
      ref.invalidate(currentUserModelProvider);
      
      // Proceed to the app
      ref.read(authProvider.notifier).completeFamilyJoin();

    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Family Setup'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Join Family'),
              Tab(text: 'Create Family'),
            ],
          ),
        ),
        body: SafeArea(
          child: _requestSent 
            ? Padding(padding: const EdgeInsets.all(24.0), child: _buildRequestSentState(theme))
            : TabBarView(
                children: [
                  Padding(padding: const EdgeInsets.all(24.0), child: _buildSearchState(theme)),
                  Padding(padding: const EdgeInsets.all(24.0), child: _buildCreateState(theme)),
                ],
              ),
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

  Widget _buildCreateState(ThemeData theme) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Start a new family',
            style: theme.textTheme.displayMedium,
          ),
          const SizedBox(height: 12),
          Text(
            'Create a new household space for your family members to join.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _familyNameController,
            decoration: const InputDecoration(
              labelText: 'Family Name',
              hintText: 'e.g. The Smiths',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _houseNameController,
            decoration: const InputDecoration(
              labelText: 'House Name',
              hintText: 'e.g. White House',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _wardNumberController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Ward Number',
              hintText: 'e.g. 12',
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 16),
            Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
          ],
          const SizedBox(height: 32),
          PrimaryButton(
            text: 'Create Family',
            isLoading: _isLoading,
            onPressed: _createFamily,
          ),
        ],
      ),
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
