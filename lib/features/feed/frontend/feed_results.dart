import 'package:flutter/material.dart';
import 'package:trashtrackr/core/models/search_model.dart';
import 'package:trashtrackr/core/services/search_service.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/profile/post_card.dart';
import 'package:trashtrackr/core/widgets/profile/event_card.dart';
import 'package:trashtrackr/core/widgets/text_fields/dashboard_search_bar.dart';

import 'package:trashtrackr/core/models/post_model.dart';
import 'package:trashtrackr/features/feed/frontend/widgets/filter_menu.dart';


class FeedResults extends StatefulWidget {
  final String searchKeyword;
  final String initialFilter;
  final bool isNewest;

  const FeedResults({
    super.key,
    required this.searchKeyword,
    this.initialFilter = 'General Content',
    this.isNewest = true,
  });

  @override
  State<FeedResults> createState() => _FeedResultsState();
}

class _FeedResultsState extends State<FeedResults>
    with TickerProviderStateMixin {
  final SearchService _searchService = SearchService();
  final TextEditingController _searchController = TextEditingController();

  late String _searchKeyword;
  late String _selectedFilter;
  late bool _isNewest;

  bool _isLoading = false;
  bool _showFilterMenu = false;
  List<SearchResult> _results = [];

  @override
  void initState() {
    super.initState();
    _searchKeyword = widget.searchKeyword;
    _selectedFilter = widget.initialFilter;
    _isNewest = widget.isNewest;
    _searchController.text = _searchKeyword;
    _performSearch();
  }

  Future<void> _performSearch() async {
    setState(() => _isLoading = true);

    _results = await _searchService.getCombinedResults(
      searchKeyword: _searchKeyword,
      descendingOrder: _isNewest,
      filterVariable: _selectedFilter,
    );

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleFilterMenu() {
    setState(() => _showFilterMenu = !_showFilterMenu);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double titleOffset = screenHeight / 20;
    final double imageSize = (screenWidth / 3) + 60;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          'Feed',
          style: kTitleMedium.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: titleOffset),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/titles/ecofeed_title.png',
                    width: imageSize,
                  ),
                  // Search Bar
                  DashboardSearchBar(
                    controller: _searchController,
                    onFilterTap: _toggleFilterMenu,
                    onSubmit: (value) {
                      setState(() {
                        _searchKeyword = value.trim();
                      });
                      _performSearch();
                    },
                    onSearch: () {
                      setState(() {
                        _searchKeyword = _searchController.text.trim();
                      });
                      _performSearch();
                    },
                    onChanged: (value) {
                      setState(() => _searchKeyword = value.trim());
                    },
                  ),

                  /// 🔄 Animated Filter Menu
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    alignment: Alignment.topCenter,
                    child:
                        _showFilterMenu
                            ? Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: FilterMenu(
                                onFilterChanged: (filter, isNewest) {
                                  setState(() {
                                    _selectedFilter = filter;
                                    _isNewest = isNewest;
                                  });
                                  _performSearch();
                                },
                              ),
                            )
                            : const SizedBox.shrink(),
                  ),

                  const SizedBox(height: 30),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Search results for "$_searchKeyword"',
                      style: kTitleLarge.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Results
                  _isLoading
                      ? const Center(
                        child: CircularProgressIndicator(color: kAvocado),
                      )
                      : _results.isEmpty
                      ? const Center(child: Text('No results found.'))
                      : Column(
                        children:
                            _results.map((result) {
                              if (result.type == SearchResultType.post) {
                                return PostCard(post: result.data);
                              } else {
                                return EventCard(event: result.data);
                              }
                            }).toList(),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
