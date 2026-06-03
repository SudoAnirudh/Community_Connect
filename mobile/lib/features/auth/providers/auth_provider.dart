import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/repositories/user_repository.dart';

enum AuthState { initial, loading, otpSent, authenticated, needsOnboarding, needsFamily, error }

class AuthStateData {
  final AuthState status;
  final String? phoneNumber;
  final String? errorMessage;
  final String? verificationId;

  const AuthStateData({
    required this.status,
    this.phoneNumber,
    this.errorMessage,
    this.verificationId,
  });

  AuthStateData copyWith({
    AuthState? status,
    String? phoneNumber,
    String? errorMessage,
    String? verificationId,
  }) {
    return AuthStateData(
      status: status ?? this.status,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      errorMessage: errorMessage ?? this.errorMessage,
      verificationId: verificationId ?? this.verificationId,
    );
  }
}

class AuthNotifier extends Notifier<AuthStateData> {
  final SupabaseClient _supabase = Supabase.instance.client;
  final UserRepository _userRepo = UserRepository();

  @override
  AuthStateData build() {
    // Check if the user is already signed in on app start
    if (_supabase.auth.currentUser != null) {
      Future.microtask(() => _checkUserExists());
      return const AuthStateData(status: AuthState.loading);
    }
    return const AuthStateData(status: AuthState.initial);
  }

  Future<void> _checkUserExists() async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      try {
        final userModel = await _userRepo.getUser(user.id);
        if (userModel == null) {
          state = state.copyWith(status: AuthState.needsOnboarding);
        } else if (userModel.familyId == null || userModel.familyId!.isEmpty) {
          state = state.copyWith(status: AuthState.needsFamily);
        } else {
          state = state.copyWith(status: AuthState.authenticated);
        }
      } catch (e) {
        state = state.copyWith(
          status: AuthState.error,
          errorMessage: 'Failed to fetch user data: ${e.toString()}',
        );
      }
    }
  }

  Future<void> sendOtp(String phoneNumber) async {
    state = state.copyWith(status: AuthState.loading, errorMessage: null);

    try {
      await _supabase.auth.signInWithOtp(
        phone: phoneNumber,
      );
      state = state.copyWith(
        status: AuthState.otpSent,
        phoneNumber: phoneNumber,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthState.error,
        errorMessage: 'Failed to send OTP: ${e.toString()}',
      );
    }
  }

  Future<bool> verifyOtp(String otp) async {
    if (state.phoneNumber == null) {
      state = state.copyWith(
        status: AuthState.error,
        errorMessage: 'Verification session expired. Please request a new OTP.',
      );
      return false;
    }

    state = state.copyWith(status: AuthState.loading, errorMessage: null);

    try {
      await _supabase.auth.verifyOTP(
        phone: state.phoneNumber!,
        token: otp,
        type: OtpType.sms,
      );
      await _checkUserExists();
      return true;
    } on AuthException catch (e) {
      state = state.copyWith(
        status: AuthState.error,
        errorMessage: e.message,
      );
      // Reset to otpSent state after showing error so they can try again
      await Future.delayed(const Duration(seconds: 2));
      state = state.copyWith(status: AuthState.otpSent, errorMessage: null);
      return false;
    } catch (e) {
      state = state.copyWith(
        status: AuthState.error,
        errorMessage: 'An unexpected error occurred.',
      );
      await Future.delayed(const Duration(seconds: 2));
      state = state.copyWith(status: AuthState.otpSent, errorMessage: null);
      return false;
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
    reset();
  }

  void completeOnboarding() {
    state = state.copyWith(status: AuthState.needsFamily);
  }

  void completeFamilyJoin() {
    state = state.copyWith(status: AuthState.authenticated);
  }

  void reset() {
    state = const AuthStateData(status: AuthState.initial);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthStateData>(() {
  return AuthNotifier();
});
