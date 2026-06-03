import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class UserRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> createUser(UserModel user) async {
    await _supabase.from('users').upsert({
      'uid': user.uid,
      'phone': user.phone,
      'name': user.name,
      'family_id': user.familyId,
      'role': user.role,
      'fcm_token': user.fcmToken,
      'created_at': user.createdAt.toIso8601String(),
    });
  }

  Future<UserModel?> getUser(String uid) async {
    final response = await _supabase
        .from('users')
        .select()
        .eq('uid', uid)
        .maybeSingle();
    if (response != null) {
      return UserModel(
        uid: response['uid'],
        phone: response['phone'] ?? '',
        name: response['name'] ?? '',
        familyId: response['family_id'],
        role: response['role'] ?? 'member',
        fcmToken: response['fcm_token'],
        createdAt: response['created_at'] != null
            ? DateTime.parse(response['created_at'])
            : DateTime.now(),
      );
    }
    return null;
  }

  Future<void> updateUser(UserModel user) async {
    await _supabase.from('users').update({
      'phone': user.phone,
      'name': user.name,
      'family_id': user.familyId,
      'role': user.role,
      'fcm_token': user.fcmToken,
    }).eq('uid', user.uid);
  }
}
