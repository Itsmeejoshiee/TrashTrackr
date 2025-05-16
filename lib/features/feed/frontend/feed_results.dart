import 'package:flutter/material.dart';
import 'package:trashtrackr/core/services/post_service.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/profile/post_card.dart';
import 'package:trashtrackr/core/widgets/text_fields/dashboard_search_bar.dart';
import 'package:trashtrackr/features/post/models/post_model.dart';

class FeedResults extends StatefulWidget {
  final dynamic searchKeyword;

  const FeedResults({super.key, required this.searchKeyword});

  @override
  State<FeedResults> createState() => _FeedResultsState();
}

class _FeedResultsState extends State<FeedResults> {
  final TextEditingController _searchController = TextEditingController();
  final PostService _postService = PostService();

  late String _searchKeyword;

  @override
  void initState() {
    super.initState();
    _searchKeyword = widget.searchKeyword.toString();
    _searchController.text = _searchKeyword;
  }

  List<Widget> _postBuilder(List<PostModel> posts) {
    return posts.map((post) => PostCard(post: post)).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                  DashboardSearchBar(
                    controller: _searchController,
                    onFilterTap: () {},
                    onSubmit: (value) {
                      setState(() {
                        _searchKeyword = value.trim();
                      });
                    },
                    onSearch: () {
                      setState(() {
                        _searchKeyword = _searchController.text.trim();
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        _searchKeyword = value.trim();
                      });
                    },
                  ),
                  const SizedBox(height: 17),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Text(
                    'Search results for "$_searchKeyword"',
                    style: kTitleLarge.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 13),
                  StreamBuilder<List<PostModel>>(
                    stream: _postService.getPostResultStream(
                      searchKeyword: _searchKeyword,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(color: kAvocado),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No posts found.'));
                      }
                      return Column(children: _postBuilder(snapshot.data!));
                    },
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
