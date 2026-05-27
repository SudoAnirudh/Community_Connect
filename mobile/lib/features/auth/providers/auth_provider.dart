import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthState { initial, loading, otpSent, authenticated, error }

class AuthStateData {
  final AuthState status;
  final String? phoneNumber;
  final String? errorMessage;

  const AuthStateData({
    required this.status,
    this.phoneNumber,
    this.errorMessage,
  });

  AuthStateData copyWith({
    AuthState? status,
    String? phoneNumber,
    String? errorMessage,
  }) {
    return AuthStateData(
      status: status ?? this.status,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthStateData> {
  AuthNotifier() : super(const AuthStateData(status: AuthState.initial));

  // Simulates sending an OTP to the provided phone number.
  Future<void> sendOtp(String phoneNumber) async {
    state = state.copyWith(status: AuthState.loading);
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // For mock purposes, just assume it succeeds
    state = state.copyWith(
      status: AuthState.otpSent,
      phoneNumber: phoneNumber,
    );
  }

  // Simulates verifying the OTP.
  Future<bool> verifyOtp(String otp) async {
    state = state.copyWith(status: AuthState.loading);
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock logic: allow any 6 digit OTP. In a real app, this verifies with Firebase.
    if (otp.length == 6) {
      state = state.copyWith(status: AuthState.authenticated);
      return true;
    } else {
      state = state.copyWith(
        status: AuthState.error,
        errorMessage: 'Invalid OTP. Please try again.',
      );
      // Reset to otpSent state after showing error so they can try again
      await Future.delayed(const Duration(seconds: 2));
      state = state.copyWith(status: AuthState.otpSent, errorMessage: null);
      return false;
    }
  }

  void reset() {
    state = const AuthStateData(status: AuthState.initial);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthStateData>((ref) {
  return AuthNotifier();
});
