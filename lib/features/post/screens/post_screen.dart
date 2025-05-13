import 'package:flutter/material.dart';
import 'package:trashtrackr/core/services/user_service.dart';
import 'package:trashtrackr/features/post/models/post_entry.dart';
import 'package:trashtrackr/features/post/widgets/event_form.dart';
import 'package:trashtrackr/features/post/widgets/post_form.dart';

// --- kForest theme colors ---
const kForestGreen = Color(0xFF819D39);
const kNeoShadow = [
  BoxShadow(color: Color(0x1A819D39), blurRadius: 12, offset: Offset(0, 4)),
];

const String kFontUrbanist = 'Urbanist';
const String kFontPoppins = 'Poppins';

class PostScreen extends StatefulWidget {
  final PostEntry? postEntry;
  final EventEntry? eventEntry;

  const PostScreen({super.key, this.postEntry, this.eventEntry});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  bool isPost = true;

  final GlobalKey<PostFormState> _postKey = GlobalKey();
  final GlobalKey<EventFormState> _eventKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.eventEntry != null) isPost = false;
  }

  Widget _neoBoxToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: kNeoShadow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _neoTab("New Post", isPost, () => setState(() => isPost = true)),
          _neoTab("New Events", !isPost, () => setState(() => isPost = false)),
        ],
      ),
    );
  }

  Widget _neoTab(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? kForestGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: kFontUrbanist,
            color: selected ? Colors.white : kForestGreen,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            color: Colors.white,
            width: double.infinity,
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Black line at the top, centered
                  Center(
                    child: Container(
                      width: 150,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Top bar with cancel, toggle, and submit button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.cancel,
                          color: kForestGreen,
                          size: 35,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      _neoBoxToggle(),
                      ElevatedButton(
                        onPressed: () async {
                          if (isPost) {
                            final post = _postKey.currentState?.getPostEntry();
                            if (post != null) {
                              await UserService().createPost(post);
                              Navigator.pop(context);
                            }
                          } else {
                            final event =
                                _eventKey.currentState?.getEventEntry();
                            if (event != null) {
                              await UserService().createEvent(event);
                              Navigator.pop(context);
                            }
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            kForestGreen,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                        ),
                        child: Text(
                          isPost ? 'Post' : 'Create',
                          style: const TextStyle(
                            fontFamily: kFontUrbanist,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Main form area
                  Expanded(
                    child: SingleChildScrollView(
                      child:
                          isPost
                              ? PostForm(
                                key: _postKey,
                                postEntry: widget.postEntry,
                              )
                              : EventForm(
                                key: _eventKey,
                                eventEntry: widget.eventEntry,
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
