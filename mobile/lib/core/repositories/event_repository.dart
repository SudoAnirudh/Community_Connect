import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_model.dart';

class EventRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createEvent(EventModel event) async {
    await _firestore.collection('events').doc(event.id).set(event.toMap());
  }

  Stream<List<EventModel>> getEventsStream() {
    return _firestore.collection('events').orderBy('date').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => EventModel.fromMap(doc.data(), doc.id)).toList();
    });
  }
  
  Future<void> updateEvent(EventModel event) async {
    await _firestore.collection('events').doc(event.id).update(event.toMap());
  }
}
