import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:trashtrackr/core/services/user_service.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/features/post/backend/post_bloc.dart';
import 'package:trashtrackr/features/post/frontend/widgets/post_function_buttons.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  XFile? _imageFile;
  final PostBloc _postBloc = PostBloc();

  Future<void> _getImage() async {
    try {
      final image =
          await _postBloc.getImage() ?? await _postBloc.getCameraImage();
      setState(() {
        _imageFile = image;
      });
    } catch (e) {
      print("Error getting image: $e");
    }
  }

  // Text controller
  final TextEditingController _postController = TextEditingController();

  void _createPost() {
    Alert(
      context: context,
      style: AlertStyle(
        animationType: AnimationType.grow,
        isCloseButton: false,
        titleStyle: kHeadlineSmall.copyWith(fontWeight: FontWeight.bold),
        descStyle: kTitleMedium,
      ),
      title: "Post Successful",
      desc:
          "Congrats! You’ve successfully posted your post. Let’s see it now! 🌿👏",
      image: Image.asset("assets/images/post-successful.png", width: 110),
      buttons: [
        DialogButton(
          margin: EdgeInsets.symmetric(horizontal: 20),
          color: Color(0xFF819D39),
          radius: BorderRadius.circular(10),
          onPressed: () async {
            final userService = UserService(context);
            await userService.createPost(
              _postController.text,
              _imageFile?.path,
            );
            Navigator.pop(context);
          },
          child: Text(
            'See My Post',
            style: kTitleSmall.copyWith(color: Colors.white),
          ),
        ),
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Exit
                IconButton(
                  icon: Icon(Icons.cancel, color: Color(0xFF819D39), size: 35),
                  onPressed: () => Navigator.pop(context),
                ),

                // Post Button
                ElevatedButton(
                  onPressed: () {
                    _createPost();
                  },
                  child: Text('Post', style: TextStyle(color: Colors.white)),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color(0xFF819D39),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Profile and Name
            Row(
              children: [
                CircleAvatar(
                  foregroundImage: AssetImage(
                    "assets/images/placeholder_profile.jpg",
                  ),
                ),

                SizedBox(width: 15),

                Text(
                  "Ella Green",
                  style: kTitleLarge.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Write post
            TextField(
              controller: _postController,
              decoration: InputDecoration(
                hintText: "What's on your mind?",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              maxLines: 10,
            ),
            SizedBox(height: 20),
            if (_imageFile != null && File(_imageFile!.path).existsSync())
              Image.file(File(_imageFile!.path), height: 200),

            SizedBox(height: 16),

            // Post Functions
            PostFunctionButtons(
              postController: _postController,
              onAddImage: _getImage,
            ),
          ],
        ),
      ),
    );
  }
}
