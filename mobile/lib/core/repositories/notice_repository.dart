import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notice_model.dart';

class NoticeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createNotice(NoticeModel notice) async {
    await _firestore.collection('notices').doc(notice.id).set(notice.toMap());
  }

  Stream<List<NoticeModel>> getNoticesStream() {
    return _firestore.collection('notices').orderBy('createdAt', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => NoticeModel.fromMap(doc.data(), doc.id)).toList();
    });
  }
  
  Future<void> updateNotice(NoticeModel notice) async {
    await _firestore.collection('notices').doc(notice.id).update(notice.toMap());
  }
  
  Future<void> deleteNotice(String id) async {
    await _firestore.collection('notices').doc(id).delete();
  }
}
