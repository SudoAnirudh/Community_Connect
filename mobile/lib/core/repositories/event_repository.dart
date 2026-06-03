import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/event_model.dart';

class EventRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> createEvent(EventModel event) async {
    await _supabase.from('events').upsert({
      'id': event.id,
      'title': event.title,
      'description': event.description,
      'date': event.date.toIso8601String().split('T')[0],
      'time': event.time,
      'venue': event.venue,
      'latitude': event.latitude,
      'longitude': event.longitude,
      'host': event.host,
      'image_url': event.imageUrl,
      'attachments': event.attachments,
      'created_by': event.createdBy,
      'status': event.status,
    });
  }

  Stream<List<EventModel>> getEventsStream() {
    return _supabase
        .from('events')
        .stream(primaryKey: ['id'])
        .order('date')
        .map((data) {
          return data.map((map) {
            return EventModel(
              id: map['id'],
              title: map['title'] ?? '',
              description: map['description'] ?? '',
              date: map['date'] != null
                  ? DateTime.parse(map['date'])
                  : DateTime.now(),
              time: map['time'] ?? '',
              venue: map['venue'] ?? '',
              latitude: map['latitude']?.toDouble(),
              longitude: map['longitude']?.toDouble(),
              host: map['host'] ?? '',
              imageUrl: map['image_url'],
              attachments: List<String>.from(map['attachments'] ?? []),
              createdBy: map['created_by'] ?? '',
              status: map['status'] ?? 'upcoming',
            );
          }).toList();
        });
  }
  
  Future<void> updateEvent(EventModel event) async {
    await _supabase.from('events').update({
      'title': event.title,
      'description': event.description,
      'date': event.date.toIso8601String().split('T')[0],
      'time': event.time,
      'venue': event.venue,
      'latitude': event.latitude,
      'longitude': event.longitude,
      'host': event.host,
      'image_url': event.imageUrl,
      'attachments': event.attachments,
      'created_by': event.createdBy,
      'status': event.status,
    }).eq('id', event.id);
  }
}
