import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trashtrackr/core/models/scan_result_model.dart';

class WasteEntryService {
  final CollectionReference wasteEntries = FirebaseFirestore.instance.collection("waste_entries");

  // Add a new waste entry
  Future<void> addWasteEntry(ScanResult entry) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final userDoc = wasteEntries.doc(user.uid);

      await userDoc.set({
        'uid': user.uid,
        'email': user.email,
      }, SetOptions(merge: true));

      final logRef = userDoc.collection('log_disposal').doc();
      entry.id = logRef.id;

      await logRef.set(entry.toMap());

      print('Waste entry added with ID: ${entry.id}');
    } catch (e) {
      print('Error adding waste entry: $e');
      rethrow;
    }
  }

  // Fetch all waste entries
  Stream<List<ScanResult>> fetchWasteEntries() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    try {
      final userDoc = wasteEntries.doc(user.uid);
      final stream = userDoc.collection('log_disposal').snapshots();

      return stream.map((snapshot) {
        return snapshot.docs.map((doc) {
          print('Fetched document ID: ${doc.id}');
          final data = doc.data();
          return ScanResult.fromMap(data, id: doc.id);
        }).toList();
      });
    } catch (e) {
      print('Error fetching waste entries: $e');
      return Stream.error(e);
    }
  }


  // Update an existing entry
  Future<List<ScanResult>> updateWasteEntries(User user, ScanResult entry) async {
    if (entry.id == null) {
      throw Exception('Entry ID is required for update');
    }

    try {
      final userDoc = wasteEntries.doc(user.uid);
      await userDoc.collection('log_disposal').doc(entry.id).update(entry.toMap());

      final snapshot = await userDoc.collection('log_disposal').get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ScanResult.fromMap(data, id: doc.id);
      }).toList();
    } catch (e) {
      print('Failed to update and fetch disposal entries: $e');
      rethrow;
    }
  }
}
