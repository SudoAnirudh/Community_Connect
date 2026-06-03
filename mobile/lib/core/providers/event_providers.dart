import 'dart:async';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/event_model.dart';
import '../repositories/event_repository.dart';

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepository();
});

final eventsStreamProvider = StreamProvider<List<EventModel>>((ref) {
  final repository = ref.watch(eventRepositoryProvider);
  return repository.getEventsStream();
});

final eventCreationProvider = AsyncNotifierProvider<EventCreationNotifier, void>(() {
  return EventCreationNotifier();
});

class EventCreationNotifier extends AsyncNotifier<void> {
  late EventRepository _repository;
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  FutureOr<void> build() {
    _repository = ref.watch(eventRepositoryProvider);
  }

  Future<void> createEvent(EventModel event) async {
    state = const AsyncValue.loading();
    try {
      List<String> uploadedUrls = [];
      const uuid = Uuid();
      
      // Upload any local attachments to Supabase Storage
      for (String path in event.attachments) {
        if (!path.startsWith('http')) {
          File file = File(path);
          if (await file.exists()) {
            String fileName = uuid.v4();
            String pathInBucket = '${event.id}/$fileName';
            
            // Upload file to 'events' bucket
            await _supabase.storage.from('events').upload(pathInBucket, file);
            
            // Get public download URL
            String downloadUrl = _supabase.storage.from('events').getPublicUrl(pathInBucket);
            uploadedUrls.add(downloadUrl);
          }
        } else {
          uploadedUrls.add(path);
        }
      }
      
      final updatedEvent = event.copyWith(attachments: uploadedUrls);
      await _repository.createEvent(updatedEvent);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
