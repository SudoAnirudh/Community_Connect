import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/models/user_model.dart';
import '../../../../core/repositories/user_repository.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../providers/auth_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;

  void _handleSave() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your full name')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authData = ref.read(authProvider);
      final user = FirebaseAuth.instance.currentUser;
      
      if (user != null) {
        final newUser = UserModel(
          uid: user.uid,
          phone: authData.phoneNumber ?? user.phoneNumber ?? '',
          name: name,
          createdAt: DateTime.now(),
        );

        final repo = UserRepository();
        await repo.createUser(newUser);

        if (mounted) {
          // Tell authProvider we're good now. But since we just saved the user,
          // we can just navigate to home.
          ref.read(authProvider.notifier).completeOnboarding();
          context.go('/home');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save profile: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Let\'s get to know you!',
                style: theme.textTheme.displayMedium,
              ),
              const SizedBox(height: 12),
              Text(
                'Enter your full name so your neighbors can recognize you.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'e.g. John Doe',
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const Spacer(),
              PrimaryButton(
                text: 'Save and Continue',
                isLoading: _isLoading,
                onPressed: _handleSave,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
