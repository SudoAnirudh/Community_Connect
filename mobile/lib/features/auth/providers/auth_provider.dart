import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthState { initial, loading, otpSent, authenticated, error }

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
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  AuthStateData build() {
    // Check if the user is already signed in on app start
    if (_auth.currentUser != null) {
      return const AuthStateData(status: AuthState.authenticated);
    }
    return const AuthStateData(status: AuthState.initial);
  }

  Future<void> sendOtp(String phoneNumber) async {
    state = state.copyWith(status: AuthState.loading, errorMessage: null);

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // This callback will be invoked in two situations:
          // 1. Instant verification. In some cases the phone number can be instantly
          //    verified without needing to send or enter a code.
          // 2. Auto-retrieval. On some devices Google Play services can automatically
          //    detect the incoming verification SMS and perform verification without
          //    user action.
          try {
            await _auth.signInWithCredential(credential);
            state = state.copyWith(status: AuthState.authenticated);
          } catch (e) {
            state = state.copyWith(
              status: AuthState.error,
              errorMessage: 'Failed to auto-authenticate: ${e.toString()}',
            );
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          state = state.copyWith(
            status: AuthState.error,
            errorMessage: e.message ?? 'Verification failed. Please try again.',
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          state = state.copyWith(
            status: AuthState.otpSent,
            phoneNumber: phoneNumber,
            verificationId: verificationId,
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-resolution timed out...
          if (state.status != AuthState.authenticated) {
             state = state.copyWith(verificationId: verificationId);
          }
        },
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthState.error,
        errorMessage: 'Failed to send OTP: ${e.toString()}',
      );
    }
  }

  Future<bool> verifyOtp(String otp) async {
    if (state.verificationId == null) {
      state = state.copyWith(
        status: AuthState.error,
        errorMessage: 'Verification session expired. Please request a new OTP.',
      );
      return false;
    }

    state = state.copyWith(status: AuthState.loading, errorMessage: null);

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: state.verificationId!,
        smsCode: otp,
      );

      await _auth.signInWithCredential(credential);
      state = state.copyWith(status: AuthState.authenticated);
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        status: AuthState.error,
        errorMessage: e.message ?? 'Invalid OTP. Please try again.',
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
    await _auth.signOut();
    reset();
  }

  void reset() {
    state = const AuthStateData(status: AuthState.initial);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthStateData>(() {
  return AuthNotifier();
});
