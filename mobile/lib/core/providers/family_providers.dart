import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/family_model.dart';
import '../models/user_model.dart';
import '../repositories/family_repository.dart';
import '../repositories/user_repository.dart';

final familyRepositoryProvider = Provider<FamilyRepository>((ref) {
  return FamilyRepository();
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

final currentUserModelProvider = FutureProvider<UserModel?>((ref) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return null;
  
  final repo = ref.watch(userRepositoryProvider);
  return repo.getUser(user.uid);
});

final currentFamilyProvider = StreamProvider<FamilyModel?>((ref) async* {
  final userModel = await ref.watch(currentUserModelProvider.future);
  if (userModel == null || userModel.familyId == null) {
    yield null;
    return;
  }
  
  final repo = ref.watch(familyRepositoryProvider);
  // Ideally, FamilyRepository should have a getFamilyStream.
  // For now, we'll yield the future result. To be reactive, one would use firestore snapshots.
  yield await repo.getFamily(userModel.familyId!);
});
