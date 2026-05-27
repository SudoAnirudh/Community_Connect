import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/family_model.dart';

class FamilyRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createFamily(FamilyModel family) async {
    await _firestore.collection('families').doc(family.id).set(family.toMap());
  }

  Future<FamilyModel?> getFamily(String id) async {
    final doc = await _firestore.collection('families').doc(id).get();
    if (doc.exists && doc.data() != null) {
      return FamilyModel.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  Stream<List<FamilyModel>> getFamiliesStream() {
    return _firestore.collection('families').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => FamilyModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  Future<void> updateFamily(FamilyModel family) async {
    await _firestore.collection('families').doc(family.id).update(family.toMap());
  }
}
