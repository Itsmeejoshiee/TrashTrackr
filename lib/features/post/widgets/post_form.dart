import 'package:flutter/material.dart';
import 'package:trashtrackr/core/models/user_model.dart';
import 'package:trashtrackr/core/services/image_service.dart';
import 'package:trashtrackr/core/services/user_service.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/utils/emotion.dart';
import 'package:trashtrackr/core/utils/string_utils.dart';
import 'package:trashtrackr/features/post/models/post_model.dart';
import 'package:flutter/services.dart';

class PostForm extends StatefulWidget {
  final UserModel user;
  final PostModel? postEntry;
  final TextEditingController? controller;
  final Function(String?)? onChange;
  final Function(Emotion?)? onEmotionSelect;
  final Function(Uint8List?)? onImageSelect;

  const PostForm({
    super.key,
    required this.user,
    this.postEntry,
    this.controller,
    this.onChange,
    this.onImageSelect,
    this.onEmotionSelect,
  });

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {

  final UserService _userService = UserService();

  late TextEditingController _controller;
  late FocusNode _focusNode;
  Emotion? _selectedEmotion;
  Uint8List? _pickedImage;
  final FocusNode _keyboardFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ??
        TextEditingController(text: widget.postEntry?.body ?? '');
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  Future<void> _getImage() async {
    try {
      final image = await ImageService().getImage();
      setState(() {
        _pickedImage = image;
      });
      widget.onImageSelect!(_pickedImage);
    } catch (e) {
      print("Error getting image: $e");
    }
  }

  Future<void> _getCameraImage() async {
    try {
      final image = await ImageService().getCameraImage();
      setState(() {
        _pickedImage = image;
      });
      widget.onImageSelect!(_pickedImage);
    } catch (e) {
      print("Error getting camera image: $e");
    }
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.enter) {
      final text = _controller.text;
      final selection = _controller.selection;
      final lines = text.substring(0, selection.start).split('\n');
      final currentLine = lines.isNotEmpty ? lines.last : '';
      // If the current line starts with a bullet, insert a new bullet and prevent default newline
      if (currentLine.trim().startsWith('◾')) {
        final newText = text.replaceRange(
          selection.start,
          selection.end,
          '\n◾  ',
        );
        final newSelectionIndex = selection.start + 4;
        setState(() {
          _controller.text = newText;
          _controller.selection = TextSelection.collapsed(
            offset: newSelectionIndex,
          );
        });
        // Prevent default behavior by unfocusing and refocusing
        FocusScope.of(context).requestFocus(_focusNode);
        // Optionally, return here to avoid double newlines
        return;
      }
    }
  }

  void _insertBullet() {
    final text = _controller.text;
    final selection = _controller.selection;
    // Always insert a new bullet on a new line
    String prefix = '';
    if (selection.start != 0 && text[selection.start - 1] != '\n') {
      prefix = '\n';
    }
    final newText = text.replaceRange(
      selection.start,
      selection.end,
      '$prefix◾  ',
    );
    final newSelectionIndex = selection.start + prefix.length + 3;
    setState(() {
      _controller.text = newText;
      _controller.selection = TextSelection.collapsed(
        offset: newSelectionIndex,
      );
    });
    widget.onChange!(_controller.text);
  }

  Widget _iconNeoButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: kForestGreenLight.withOpacity(0.13),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: kForestGreenLight, size: 24),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String fullName = '${widget.user.firstName} ${widget.user.lastName}';
    final String profilePicture = widget.user.profilePicture;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage:
              (profilePicture.isNotEmpty)
                      ? NetworkImage(profilePicture)
                      : AssetImage('assets/images/placeholder_profile.jpg'),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fullName, style: kNameTextStyle),
                SizedBox(
                  width: 220,
                  child: DropdownButtonFormField<Emotion>(
                    value: _selectedEmotion,
                    hint: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Choose type', style: kSmallGreenBoldText),
                        Icon(
                          Icons.arrow_drop_down,
                          color: kForestGreenLight,
                          size: 18,
                        ),
                      ],
                    ),
                    icon: const SizedBox.shrink(),
                    style: kSmallGreenBoldText,
                    isDense: true,
                    items:
                        Emotion.values
                            .map(
                              (emotion) => DropdownMenuItem(
                                value: emotion,
                                child: Row(
                                  spacing: 8,
                                  children: [
                                    Image.asset(
                                      'assets/images/emotions/${emotion.name}.png',
                                      width: 24,
                                    ),
                                    Text(
                                      emotion.name.capitalize(),
                                      style: kDropDownTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: (val) {
                      setState(() => _selectedEmotion = val);
                      widget.onEmotionSelect!(_selectedEmotion!);
                    },
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 0,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                    ),
                    dropdownColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        RawKeyboardListener(
          focusNode: _keyboardFocusNode,
          onKey: _handleKeyEvent,
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            maxLines: 10,
            cursorColor: kForestGreenLight,
            style: kPostInputTextStyle,
            decoration: const InputDecoration(border: InputBorder.none),
            onChanged: (value) {
              widget.onChange!(_controller.text);
            },
          ),
        ),
        if (_pickedImage != null) ...[
          const SizedBox(height: 12),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(
                  _pickedImage!,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: kLightGray,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _pickedImage = null;
                      });
                      widget.onImageSelect!(_pickedImage);
                    },
                    child: Icon(Icons.close, color: Colors.black, size: 30),
                  ),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 20),
        Row(
          children: [
            _iconNeoButton(Icons.camera_alt, _getCameraImage),
            const SizedBox(width: 12),
            _iconNeoButton(Icons.image, _getImage),
            const SizedBox(width: 12),
            _iconNeoButton(Icons.list, _insertBullet),
          ],
        ),
      ],
    );
  }
}
