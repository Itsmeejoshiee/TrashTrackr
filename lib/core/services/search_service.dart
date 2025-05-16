import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trashtrackr/core/models/post_model.dart';
import 'package:trashtrackr/core/models/search_model.dart';
import 'package:trashtrackr/features/post/models/event_model.dart';

class SearchService {
  Future<List<PostModel>> getPostResults({
    required String searchKeyword,
    required bool descendingOrder,
    required String filterVariable,
  }) async {
    final keywordLower = searchKeyword.toLowerCase();

    final snapshot =
        await FirebaseFirestore.instance
            .collection('posts')
            .orderBy('timestamp', descending: descendingOrder)
            .get();

    return snapshot.docs.map((doc) => PostModel.fromMap(doc.data())).where((
      post,
    ) {
      switch (filterVariable) {
        case 'Users':
          return post.fullName.toLowerCase().contains(keywordLower);
        case 'General Content':
        case 'Posts':
          return post.body.toLowerCase().contains(keywordLower);
        default:
          return false;
      }
    }).toList();
  }

  Future<List<EventModel>> getEventResults({
    required String searchKeyword,
    required bool descendingOrder,
    required String filterVariable,
  }) async {
    final keywordLower = searchKeyword.toLowerCase();

    final snapshot =
        await FirebaseFirestore.instance
            .collection('events')
            .orderBy('timestamp', descending: descendingOrder)
            .get();

    return snapshot.docs.map((doc) => EventModel.fromMap(doc.data())).where((
      event,
    ) {
      switch (filterVariable) {
        case 'Users':
          return event.fullName.toLowerCase().contains(keywordLower);
        case 'General Content':
        case 'Events':
          return event.title.toLowerCase().contains(keywordLower);
        default:
          return false;
      }
    }).toList();
  }

  Future<List<SearchResult>> getCombinedResults({
    required String searchKeyword,
    required bool descendingOrder,
    required String filterVariable,
  }) async {
    final List<SearchResult> results = [];

    // Fetch posts if the filter includes them
    if (filterVariable == 'General Content' ||
        filterVariable == 'Posts' ||
        filterVariable == 'Users') {
      final postResults = await getPostResults(
        searchKeyword: searchKeyword,
        descendingOrder: descendingOrder,
        filterVariable: filterVariable,
      );

      results.addAll(
        postResults.map(
          (post) => SearchResult(type: SearchResultType.post, data: post),
        ),
      );
    }

    // Fetch events if the filter includes them
    if (filterVariable == 'General Content' ||
        filterVariable == 'Events' ||
        filterVariable == 'Users') {
      final eventResults = await getEventResults(
        searchKeyword: searchKeyword,
        descendingOrder: descendingOrder,
        filterVariable: filterVariable,
      );

      results.addAll(
        eventResults.map(
          (event) => SearchResult(type: SearchResultType.event, data: event),
        ),
      );
    }

    results.sort((firstResult, secondResult) {
      final Timestamp firstTimestamp =
          firstResult.type == SearchResultType.post
              ? (firstResult.data as PostModel).timestamp
              : (firstResult.data as EventModel).timestamp;

      final Timestamp secondTimestamp =
          secondResult.type == SearchResultType.post
              ? (secondResult.data as PostModel).timestamp
              : (secondResult.data as EventModel).timestamp;

      return descendingOrder
          ? secondTimestamp.compareTo(firstTimestamp)
          : firstTimestamp.compareTo(secondTimestamp);
    });

    return results;
  }
}
