import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trashtrackr/core/models/scan_result_model.dart';
import 'package:trashtrackr/core/models/scan_result_model.dart';

class WasteEntryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addWasteEntry(String userId, ScanResult entry) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('wasteEntries')
        .add(entry.toMap());
  }

  Stream<List<ScanResult>> getWasteEntries(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('wasteEntries')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ScanResult.fromMap(doc.data()))
          .toList();
    });
  }
}
