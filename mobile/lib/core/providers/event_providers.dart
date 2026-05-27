import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
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

final eventCreationProvider = StateNotifierProvider<EventCreationNotifier, AsyncValue<void>>((ref) {
  return EventCreationNotifier(ref.watch(eventRepositoryProvider));
});

class EventCreationNotifier extends StateNotifier<AsyncValue<void>> {
  final EventRepository _repository;
  final _uuid = const Uuid();

  EventCreationNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> createEvent(EventModel event) async {
    state = const AsyncValue.loading();
    try {
      List<String> uploadedUrls = [];
      
      // Upload any local attachments to Firebase Storage
      for (String path in event.attachments) {
        if (!path.startsWith('http')) {
          File file = File(path);
          if (await file.exists()) {
            String fileName = _uuid.v4();
            Reference storageRef = FirebaseStorage.instance.ref().child('events/${event.id}/$fileName');
            UploadTask uploadTask = storageRef.putFile(file);
            TaskSnapshot snapshot = await uploadTask;
            String downloadUrl = await snapshot.ref.getDownloadURL();
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
