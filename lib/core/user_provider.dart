// import 'package:flutter/material.dart';
// import 'package:trashtrackr/core/models/user_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class UserProvider extends ChangeNotifier {
//
//   UserModel? _user;
//
//   UserModel? get user => _user;
//
//   void setUser(UserModel user) {
//     _user = user;
//     notifyListeners();
//   }
//
//   Future<void> loadUserFromFirestore(String uid) async {
//     DocumentSnapshot doc =
//         await FirebaseFirestore.instance.collection('users').doc(uid).get();
//
//     if (doc.exists) {
//       _user = UserModel.fromMap(doc.data() as Map<String, dynamic>);
//       notifyListeners();
//     }
//   }
//
// }