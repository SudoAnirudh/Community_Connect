import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/family_model.dart';
import '../models/join_request_model.dart';

class FamilyRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> createFamily(FamilyModel family) async {
    await _supabase.from('families').upsert({
      'id': family.id,
      'name': family.name,
      'house_name': family.houseName,
      'ward_number': family.wardNumber,
      'admin_uid': family.adminUid,
      'member_uids': family.memberUids,
      'verification_status': family.verificationStatus,
    });
  }

  Future<FamilyModel?> getFamily(String id) async {
    final response = await _supabase
        .from('families')
        .select()
        .eq('id', id)
        .maybeSingle();
    if (response != null) {
      return FamilyModel(
        id: response['id'],
        name: response['name'] ?? '',
        houseName: response['house_name'] ?? '',
        wardNumber: response['ward_number'] ?? '',
        adminUid: response['admin_uid'] ?? '',
        memberUids: List<String>.from(response['member_uids'] ?? []),
        verificationStatus: response['verification_status'] ?? 'pending',
      );
    }
    return null;
  }

  Stream<List<FamilyModel>> getFamiliesStream() {
    return _supabase.from('families').stream(primaryKey: ['id']).map((data) {
      return data.map((map) {
        return FamilyModel(
          id: map['id'],
          name: map['name'] ?? '',
          houseName: map['house_name'] ?? '',
          wardNumber: map['ward_number'] ?? '',
          adminUid: map['admin_uid'] ?? '',
          memberUids: List<String>.from(map['member_uids'] ?? []),
          verificationStatus: map['verification_status'] ?? 'pending',
        );
      }).toList();
    });
  }

  Future<void> updateFamily(FamilyModel family) async {
    await _supabase.from('families').update({
      'name': family.name,
      'house_name': family.houseName,
      'ward_number': family.wardNumber,
      'admin_uid': family.adminUid,
      'member_uids': family.memberUids,
      'verification_status': family.verificationStatus,
    }).eq('id', family.id);
  }

  Future<void> createJoinRequest(String familyId, JoinRequestModel request) async {
    await _supabase.from('join_requests').upsert({
      'id': request.id,
      'family_id': familyId,
      'user_id': request.userId,
      'user_name': request.userName,
      'user_phone': request.userPhone,
      'status': request.status,
      'created_at': request.createdAt.toIso8601String(),
    });
  }

  Stream<List<JoinRequestModel>> getJoinRequestsStream(String familyId) {
    return _supabase
        .from('join_requests')
        .stream(primaryKey: ['id'])
        .eq('family_id', familyId)
        .map((data) {
          return data
              .where((map) => map['status'] == 'pending')
              .map((map) {
                return JoinRequestModel(
                  id: map['id'],
                  familyId: map['family_id'] ?? '',
                  userId: map['user_id'] ?? '',
                  userName: map['user_name'] ?? '',
                  userPhone: map['user_phone'] ?? '',
                  status: map['status'] ?? 'pending',
                  createdAt: map['created_at'] != null
                      ? DateTime.parse(map['created_at'])
                      : DateTime.now(),
                );
              })
              .toList();
        });
  }

  Future<void> updateJoinRequestStatus(String familyId, String requestId, String status) async {
    await _supabase.from('join_requests').update({
      'status': status,
    }).eq('id', requestId);
  }
}
