//post_screen.dart for control and logic
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trashtrackr/core/models/user_model.dart';
import 'package:trashtrackr/core/services/activity_service.dart';
import 'package:trashtrackr/core/services/post_service.dart';
import 'package:trashtrackr/core/services/user_service.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/utils/emotion.dart';
import 'package:trashtrackr/core/utils/event_type.dart';
import 'package:trashtrackr/core/utils/string_utils.dart';
import 'package:trashtrackr/core/models/event_model.dart';
import 'package:trashtrackr/core/models/post_model.dart';
import 'package:trashtrackr/features/post/widgets/forms/event_form.dart'; // <-- Import event form here
import 'package:trashtrackr/features/post/widgets/forms/post_form.dart'; // new import
import 'package:flutter/services.dart';

// --- kForest theme colors ---
const kForestGreen = Color(0xFF819D39);
const kNeoShadow = [
  BoxShadow(color: Color(0x1A819D39), blurRadius: 12, offset: Offset(0, 4)),
];

class PostScreen extends StatefulWidget {
  final PostModel? postEntry;
  final EventModel? eventEntry;

  const PostScreen({super.key, this.postEntry, this.eventEntry});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final UserService _userService = UserService();
  UserModel? _user;

  final ActivityService _activityService = ActivityService();

  final PostService _postService = PostService();
  bool _isPost = true;

  String? _postBody;
  Emotion _postEmotion = Emotion.joyful;
  Uint8List? _postImage;

  Uint8List? _eventImage;
  String? _eventTitle;
  EventType? _eventType;
  String? _eventAddress;
  DateTimeRange? _eventDateRange;
  TimeOfDay? _eventStartTime;
  TimeOfDay? _eventEndTime;
  String? _eventDesc;

  @override
  void initState() {
    super.initState();
    _getUser();
    // If an event entry is passed, show event form by default
    if (widget.eventEntry != null) _isPost = false;
  }

  Future<void> _getUser() async {
    final currentUser = await _userService.getUser();
    setState(() {
      _user = currentUser;
    });
  }

  // Post or Event Toggle Box
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
          _neoTab("New Post", _isPost, () => setState(() => _isPost = true)),
          _neoTab("New Event", !_isPost, () => setState(() => _isPost = false)),
        ],
      ),
    );
  }

  // Post or Event Toggle Bar
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
          style: kLabelLarge.copyWith(
            color: selected ? Colors.white : kForestGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Check if required post fields are met
  bool _isPostComplete() {
    if (_postBody == null || _postBody!.isEmpty) return false;
    return true;
  }

  // Check if required event fields are met
  bool _isEventComplete() {
    if (_eventTitle == null || _eventTitle!.isEmpty) return false;
    if (_eventType == null) return false;
    if (_eventDateRange == null) return false;
    if (_eventStartTime == null) return false;
    if (_eventEndTime == null) return false;
    if (_eventDesc == null || _eventDesc!.isEmpty) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    print(_user);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            color: Colors.white,
            width: double.infinity,
            height: double.infinity,
            child:
                (_user != null)
                    ? Padding(
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
                                  if (_isPost) {
                                    if (_isPostComplete()) {
                                      showDialog(
                                        context: context,
                                        builder:
                                            (context) => Center(
                                              child: CircularProgressIndicator(
                                                color: kAppleGreen,
                                              ),
                                            ),
                                      );
                                      await _postService.createPost(
                                        user: _user!,
                                        body: _postBody!,
                                        emotion: _postEmotion,
                                        image: _postImage,
                                      );
                                      // Log post activity
                                      _activityService.logActivity('post');
                                      // Pop loading indicator
                                      Navigator.pop(context);
                                      // Pop post screen
                                      Navigator.pop(context);
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Include post caption.',
                                          ),
                                          backgroundColor: kRed,
                                        ),
                                      );
                                    }
                                  } else {
                                    if (_isEventComplete()) {
                                      showDialog(
                                        context: context,
                                        builder:
                                            (context) => Center(
                                              child: CircularProgressIndicator(
                                                color: kAppleGreen,
                                              ),
                                            ),
                                      );
                                      await _postService.createEvent(
                                        user: _user!,
                                        image: _eventImage,
                                        title: _eventTitle!,
                                        type: _eventType!,
                                        address: _eventAddress!,
                                        dateRange: _eventDateRange!,
                                        startTime: _eventStartTime!.format(
                                          context,
                                        ),
                                        endTime: _eventEndTime!.format(context),
                                        desc: _eventDesc!,
                                      );
                                      // Log post activity
                                      _activityService.logActivity('event');
                                      // Pop loading indicator
                                      Navigator.pop(context);
                                      // Pop post screen
                                      Navigator.pop(context);
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text('Incomplete Fields'),
                                          backgroundColor: kRed,
                                        ),
                                      );
                                    }
                                  }
                                },
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                        kForestGreen,
                                      ),
                                  shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder
                                  >(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  _isPost ? 'Post' : 'Create',
                                  style: kLabelLarge.copyWith(
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
                                  _isPost
                                      ? PostForm(
                                        user: _user!,
                                        postEntry: widget.postEntry,
                                        onChange: (body) {
                                          setState(() {
                                            _postBody = body;
                                          });
                                          print('POST BODY: $_postBody');
                                        },
                                        onEmotionSelect: (emotion) {
                                          setState(() {
                                            _postEmotion = emotion!;
                                          });
                                          print('POST EMOTION: $_postEmotion');
                                        },
                                        onImageSelect: (image) {
                                          setState(() {
                                            _postImage = image;
                                          });
                                          print('POST IMAGE: $_postImage');
                                        },
                                      )
                                      : EventForm(
                                        eventEntry: widget.eventEntry,
                                        onImageSelect: (image) {
                                          setState(() {
                                            _eventImage = image;
                                          });
                                          print('POST IMAGE: $_eventImage');
                                        },
                                        onTitleChanged: (name) {
                                          setState(() {
                                            _eventTitle = name;
                                          });
                                          print('EVENT NAME: $_eventTitle');
                                        },
                                        onTypeSelect: (type) {
                                          setState(() {
                                            _eventType = type;
                                          });
                                          print('EVENT TYPE: $_eventType');
                                        },
                                        onAddressChanged: (address) {
                                          setState(() {
                                            _eventAddress = address;
                                          });
                                          print('EVENT ADDRESS: $_eventAddress');
                                        },
                                        onDateTimeRangeSelect: (range) {
                                          setState(() {
                                            _eventDateRange = range;
                                          });
                                          print(
                                            'EVENT DATE RANGE: $_eventDateRange',
                                          );
                                        },
                                        onTimeSelect: (start, end) {
                                          setState(() {
                                            _eventStartTime = start;
                                            _eventEndTime = end;
                                          });
                                          print(
                                            'EVENT START TIME: $_eventStartTime',
                                          );
                                          print(
                                            'EVENT ENDd TIME: $_eventEndTime',
                                          );
                                        },
                                        onDescChanged: (desc) {
                                          setState(() {
                                            _eventDesc = desc;
                                          });
                                          print('EVENT DESC: $_eventDesc');
                                        },
                                      ),
                            ),
                          ),
                        ],
                      ),
                    )
                    : Center(child: CircularProgressIndicator(color: kAvocado)),
          ),
        ),
      ),
    );
  }
}
