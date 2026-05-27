import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  EventCreationNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> createEvent(EventModel event) async {
    state = const AsyncValue.loading();
    try {
      await _repository.createEvent(event);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
