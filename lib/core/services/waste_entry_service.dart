import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trashtrackr/core/models/scan_result_model.dart';

class WasteEntryService {
  final user = FirebaseAuth.instance.currentUser;
  final CollectionReference wasteEntries = FirebaseFirestore.instance.collection("waste_entries");

  Future<void> addWasteEntry(ScanResult entry) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // use uid as the document ID
      final userDoc = FirebaseFirestore.instance.collection('waste_entries').doc(user.uid);

      // et or update email
      await userDoc.set({
        'uid': user.uid,
        'email': user.email,
      }, SetOptions(merge: true));

      // add entry to subcollection
      await userDoc.collection('log_disposal').add(entry.toMap());
    } catch (e) {
      print('Error adding waste entry: $e');
      rethrow;
    }
  }

}
