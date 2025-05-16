import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trashtrackr/features/post/models/post_model.dart';

class SearchService {
  Future<List<PostModel>> getPostResults({
    required String searchKeyword,
    required bool descendingOrder,
    String? filterVariable,
  }) async {
    final keywordLower = searchKeyword.toLowerCase();
    final bool descendingOrder;
    final String filterVariable = 'body';

    return FirebaseFirestore.instance
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .get()
        .then((snapshot) {
          return snapshot.docs
              .map((doc) => PostModel.fromMap(doc.data()))
              .where((post) {
                // Choose which field to search based on filterVariable value
                final fieldValue =
                    (filterVariable == 'body')
                        ? post.body
                        : (filterVariable == 'user')
                        ? post.fullName
                        : '';
                return fieldValue.toLowerCase().contains(keywordLower);
              })
              .toList();
        });
  }
}
