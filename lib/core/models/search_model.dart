enum SearchResultType { post, event }

class SearchResult {
  final SearchResultType type;
  final dynamic data;

  SearchResult({required this.type, required this.data});
}
