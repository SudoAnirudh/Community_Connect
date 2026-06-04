import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SupabaseClient _supabase = Supabase.instance.client;
  final UserRepository _userRepo = UserRepository();

  @override
  AuthStateData build() {
    // Check if the user is already signed in on app start
    if (_auth.currentUser != null) {
      Future.microtask(() => _checkUserExists());
      return const AuthStateData(status: AuthState.loading);
    }
    return const AuthStateData(status: AuthState.initial);
  }

  Future<void> _checkUserExists() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        debugPrint('DEBUG: Force refreshing Firebase ID token to get latest custom claims...');
        final token = await user.getIdToken(true);
        debugPrint('DEBUG: Firebase ID token retrieved successfully: ${token != null && token.length > 15 ? token.substring(0, 15) : token}...');
        
        debugPrint('DEBUG: Querying Supabase user table for uid: ${user.uid}');
        final userModel = await _userRepo.getUser(user.uid);
        debugPrint('DEBUG: User query result: $userModel');
        
        if (userModel == null) {
          state = state.copyWith(status: AuthState.needsOnboarding);
        } else if (userModel.familyId == null || userModel.familyId!.isEmpty) {
          state = state.copyWith(status: AuthState.needsFamily);
        } else {
          state = state.copyWith(status: AuthState.authenticated);
        }
      } catch (e, stackTrace) {
        debugPrint('DEBUG: Error in _checkUserExists: $e');
        debugPrint('DEBUG: StackTrace: $stackTrace');
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
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await _auth.signInWithCredential(credential);
            await _checkUserExists();
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
      await _checkUserExists();
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

  Future<void> signInAnonymously() async {
    state = state.copyWith(status: AuthState.loading, errorMessage: null);
    try {
      await _auth.signInAnonymously();
      await _checkUserExists();
    } catch (e) {
      state = state.copyWith(
        status: AuthState.error,
        errorMessage: 'Failed to sign in anonymously: ${e.toString()}',
      );
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
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
