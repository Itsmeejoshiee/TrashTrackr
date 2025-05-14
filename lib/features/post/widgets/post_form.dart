import 'package:flutter/material.dart';
import 'package:trashtrackr/core/services/image_service.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/features/post/models/post_entry.dart';
import 'package:flutter/services.dart';

class PostForm extends StatefulWidget {
  final PostEntry? postEntry;
  final TextEditingController? controller;

  const PostForm({super.key, this.postEntry, this.controller});

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  String? _selectedEmotion;
  Uint8List? _pickedImage;
  final FocusNode _keyboardFocusNode = FocusNode();

  final List<String> _emotions = [
    "💪 Empowered — Feeling capable and motivated to make a change.",
    "🙏 Grateful — Appreciating nature, community, or the chance to help.",
    "🌅 Hopeful — Optimistic about the future and the planet.",
    "💡 Inspired — Motivated by others or your own eco-action.",
    "😊 Joyful — Simply happy doing your part for the Earth",
  ];

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
    final String fullname = widget.postEntry?.fullname ?? "Your Name";
    final String userPfp =
        widget.postEntry?.userPfp ?? "assets/images/placeholder_profile.jpg";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage:
                  userPfp.startsWith('http')
                      ? NetworkImage(userPfp)
                      : AssetImage(userPfp) as ImageProvider,
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fullname, style: kNameTextStyle),
                SizedBox(
                  width: 220,
                  child: DropdownButtonFormField<String>(
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
                        _emotions
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e.split(' ').take(2).join(' '),
                                  style: kDropDownTextStyle,
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: (val) => setState(() => _selectedEmotion = val),
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
          ),
        ),
        if (_pickedImage != null) ...[
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.memory(
              _pickedImage!,
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),
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
