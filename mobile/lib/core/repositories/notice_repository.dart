import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/notice_model.dart';

class NoticeRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> createNotice(NoticeModel notice) async {
    await _supabase.from('notices').upsert({
      'id': notice.id,
      'title': notice.title,
      'description': notice.description,
      'icon': notice.icon,
      'color_hex': notice.colorHex,
      'priority': notice.priority,
      'created_at': notice.createdAt.toIso8601String(),
    });
  }

  Stream<List<NoticeModel>> getNoticesStream() {
    return _supabase
        .from('notices')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) {
          return data.map((map) {
            return NoticeModel(
              id: map['id'],
              title: map['title'] ?? '',
              description: map['description'] ?? '',
              icon: map['icon'] ?? 'info',
              colorHex: map['color_hex'] ?? '#000000',
              createdAt: map['created_at'] != null
                  ? DateTime.parse(map['created_at'])
                  : DateTime.now(),
              priority: map['priority'] ?? 'Medium',
            );
          }).toList();
        });
  }
  
  Future<void> updateNotice(NoticeModel notice) async {
    await _supabase.from('notices').update({
      'title': notice.title,
      'description': notice.description,
      'icon': notice.icon,
      'color_hex': notice.colorHex,
      'priority': notice.priority,
    }).eq('id', notice.id);
  }
  
  Future<void> deleteNotice(String id) async {
    await _supabase.from('notices').delete().eq('id', id);
  }
}
