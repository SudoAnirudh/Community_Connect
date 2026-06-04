import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../shared/widgets/primary_button.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _handleSendOtp() {
    String phone = _phoneController.text.trim();
    if (phone.length >= 10) {
      // Ensure E.164 format required by Firebase
      if (!phone.startsWith('+')) {
        // Assume India country code if not provided since prefixText is '+91 '
        phone = '+91$phone';
      }
      ref.read(authProvider.notifier).sendOtp(phone);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 10-digit mobile number')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Listen to state changes to navigate to OTP screen
    ref.listen<AuthStateData>(
      authProvider,
      (previous, next) {
        if (next.status == AuthState.otpSent) {
          context.push('/otp');
        } else if (next.status == AuthState.authenticated) {
          context.go('/home');
        } else if (next.status == AuthState.needsOnboarding) {
          context.go('/onboarding');
        } else if (next.status == AuthState.error && next.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.errorMessage!)),
          );
        }
      },
    );

    final isLoading = authState.status == AuthState.loading;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Header illustration
                        Center(
                          child: Image.asset(
                            'assets/images/login_illustration.png',
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                        ).animate().fade(duration: 600.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
                        const SizedBox(height: 24),
                        
                        Text(
                          'Welcome to\nCommunityConnect',
                          style: theme.textTheme.displayLarge?.copyWith(
                            height: 1.2,
                          ),
                        ).animate().fade(delay: 200.ms, duration: 600.ms).slideX(begin: -0.05, end: 0, curve: Curves.easeOutQuad),
                        const SizedBox(height: 12),
                        Text(
                          'Enter your mobile number to securely log in to your local community.',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ).animate().fade(delay: 300.ms, duration: 600.ms).slideX(begin: -0.05, end: 0, curve: Curves.easeOutQuad),
                        const SizedBox(height: 48),

                        // Phone Input Field
                        TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          style: theme.textTheme.bodyLarge,
                          decoration: const InputDecoration(
                            labelText: 'Mobile Number',
                            prefixText: '+91 ',
                            prefixIcon: Icon(PhosphorIconsRegular.phone),
                          ),
                        ).animate().fade(delay: 400.ms, duration: 600.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
                        const SizedBox(height: 32),

                        PrimaryButton(
                          text: 'Send OTP',
                          isLoading: isLoading,
                          onPressed: _handleSendOtp,
                        ).animate().fade(delay: 500.ms, duration: 600.ms).scale(begin: const Offset(0.95, 0.95), curve: Curves.easeOutQuad),
                        const SizedBox(height: 16),
                        Center(
                          child: TextButton(
                            onPressed: isLoading ? null : () {
                              ref.read(authProvider.notifier).signInAnonymously();
                            },
                            child: const Text('Or Sign In Anonymously (For Testing)'),
                          ),
                        ).animate().fade(delay: 600.ms, duration: 600.ms),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
