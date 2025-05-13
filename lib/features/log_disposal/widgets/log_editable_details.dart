import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/features/log_disposal/models/log_entry.dart';


class EditableLogDetails extends StatefulWidget {
  final LogEntry entry;
  final Function(String imageUrl) onImageUpdated;

  const EditableLogDetails({
    super.key,
    required this.entry,
    required this.onImageUpdated,
  });

  @override
  State<EditableLogDetails> createState() => _EditableLogDetailsState();
}

class _EditableLogDetailsState extends State<EditableLogDetails> {
  late TextEditingController _titleController;
  late TextEditingController _productInfoController;
  late TextEditingController _toDoController;
  late TextEditingController _notToDoController;
  late TextEditingController _proTipController;
  late TextEditingController _notesController;
  late TextEditingController _quantityController;

  bool _isEditing = false;
  String? _updatedImageUrl;

  @override
  void initState() {
    super.initState();
    final entry = widget.entry;

    _titleController = TextEditingController(text: entry.title);
    _productInfoController = TextEditingController(text: entry.productInfo);
    _toDoController = TextEditingController(text: entry.disposalGuideToDo.join('\n'));
    _notToDoController = TextEditingController(text: entry.disposalGuideNotToDo.join('\n'));
    _proTipController = TextEditingController(text: entry.disposalGuideProTip ?? '');
    _notesController = TextEditingController(text: entry.notes ?? '');
    _quantityController = TextEditingController(text: entry.quantity ?? '');
  }

  void _updateDetails() {
    setState(() {
      widget.entry.title = _titleController.text;
      widget.entry.productInfo = _productInfoController.text;
      widget.entry.disposalGuideToDo = _toDoController.text.split('\n');
      widget.entry.disposalGuideNotToDo = _notToDoController.text.split('\n');
      widget.entry.disposalGuideProTip = _proTipController.text;
      widget.entry.notes = _notesController.text;
      widget.entry.quantity = _quantityController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _isEditing
                  ? Expanded(
                      child: TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    )
                  : Text(
                      entry.title ?? 'Unknown Title',
                      style: kTitleLarge.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (_isEditing) _updateDetails();
                    _isEditing = !_isEditing;
                  });
                },
                child: Image.asset(
                  _isEditing
                      ? 'assets/images/icons/edit_active.png'
                      : 'assets/images/icons/edit_default.png',
                  width: 64,
                  height: 64,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildEditableField('Product Info', _productInfoController),
          _buildEditableField('To Do', _toDoController, maxLines: 3),
          _buildEditableField('Not To Do', _notToDoController, maxLines: 3),
          _buildEditableField('Pro Tip', _proTipController),
          _buildEditableField('Notes', _notesController, optional: true),
          _buildEditableField('Quantity', _quantityController, optional: true),
        ],
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller,
      {int maxLines = 1, bool optional = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label${optional ? ' (optional)' : ''}',
          style: kBodyLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _isEditing
            ? TextField(
                controller: controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                maxLines: maxLines,
              )
            : Text(
                controller.text.isEmpty && optional
                    ? 'No $label provided'
                    : controller.text,
                style: kTitleSmall.copyWith(color: Colors.black54),
              ),
        const SizedBox(height: 16),
      ],
    );
  }
}
