import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import '../models/log_entry.dart';

class LogEditableFields extends StatefulWidget {
  final LogEntry logEntry;
  final void Function(LogEntry updatedEntry) onDetailsUpdated;

  const LogEditableFields({
    Key? key,
    required this.logEntry,
    required this.onDetailsUpdated,
  }) : super(key: key);

  @override
  _LogEditableFieldsState createState() => _LogEditableFieldsState();
}

class _LogEditableFieldsState extends State<LogEditableFields> {
  late TextEditingController titleController;
  late TextEditingController materialsController;
  late TextEditingController productInfoController;
  late TextEditingController notesController;
  late TextEditingController quantityController;
  late TextEditingController proTipController;
  late TextEditingController toDoController;
  late TextEditingController notToDoController;

  String? classificationValue;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.logEntry.title);
    materialsController = TextEditingController(
      text: widget.logEntry.productProperties
          .where((p) => p.startsWith('Material:'))
          .map((p) => p.replaceFirst('Material: ', ''))
          .join(', '),
    );
    productInfoController = TextEditingController(text: widget.logEntry.productInfo);
    notesController = TextEditingController(text: widget.logEntry.notes ?? '');
    quantityController = TextEditingController(text: widget.logEntry.quantity ?? '');
    proTipController = TextEditingController(text: widget.logEntry.disposalGuideProTip);
    toDoController = TextEditingController(text: widget.logEntry.disposalGuideToDo.join('\n'));
    notToDoController = TextEditingController(text: widget.logEntry.disposalGuideNotToDo.join('\n'));
    classificationValue = widget.logEntry.wasteType;
  }

  void _notifyUpdate() {
    final updatedEntry = widget.logEntry.copyWith(
      title: titleController.text,
      productProperties: materialsController.text
          .split(',')
          .map((m) => 'Material: ${m.trim()}')
          .toList(),
      productInfo: productInfoController.text,
      notes: notesController.text,
      quantity: quantityController.text,
      disposalGuideProTip: proTipController.text,
      disposalGuideToDo: toDoController.text.split('\n').map((e) => e.trim()).toList(),
      disposalGuideNotToDo: notToDoController.text.split('\n').map((e) => e.trim()).toList(),
      wasteType: classificationValue ?? widget.logEntry.wasteType,
    );
    widget.onDetailsUpdated(updatedEntry);
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType? type, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        maxLines: maxLines,
        cursorColor: kForestGreen, 
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: kForestGreen), // <-- Set label color
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF228B22), width: 2), 
          ),
        ),
        onChanged: (_) => _notifyUpdate(),
      ),
    );
  }

  Widget _buildClassificationDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: classificationValue,
        dropdownColor: const Color(0xFFF4F4F4),
        decoration: const InputDecoration(
          labelText: 'Classification',
          labelStyle: TextStyle(color: kForestGreen), 
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kForestGreen, width: 2), 
          ),
        ),
        items: [
          DropdownMenuItem(
            value: 'Recyclable',
            child: Row(
              children: [
                Image.asset('assets/images/icons/recycling.png', width: 24, height: 24),
                const SizedBox(width: 8),
                const Text('Recyclable'),
              ],
            ),
          ),
          DropdownMenuItem(
            value: 'Biodegradable',
            child: Row(
              children: [
                Image.asset('assets/images/icons/leaf_brown.png', width: 24, height: 24),
                const SizedBox(width: 8),
                const Text('Biodegradable'),
              ],
            ),
          ),
          DropdownMenuItem(
            value: 'Non-Biodegradable',
            child: Row(
              children: [
                Image.asset('assets/images/icons/trashcan.png', width: 24, height: 24),
                const SizedBox(width: 8),
                const Text('Non-Biodegradable'),
              ],
            ),
          ),
          DropdownMenuItem(
            value: 'E-Waste',
            child: Row(
              children: [
                Image.asset('assets/images/icons/battery-blue.png', width: 24, height: 24),
                const SizedBox(width: 8),
                const Text('E-Waste'),
              ],
            ),
          ),
          DropdownMenuItem(
            value: 'Others',
            child: Row(
              children: [
                Image.asset('assets/images/icons/others.png', width: 24, height: 24),
                const SizedBox(width: 8),
                const Text('Others'),
              ],
            ),
          ),
        ],
        onChanged: (value) {
          setState(() {
            classificationValue = value;
            _notifyUpdate();
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTextField("Title", titleController),
        _buildTextField("Materials", materialsController, maxLines: 2),
        _buildClassificationDropdown(),
        _buildTextField("Product Info", productInfoController, maxLines: 2),
        _buildTextField("To Do", toDoController, maxLines: 3),
        _buildTextField("Not To Do", notToDoController, maxLines: 3),
        _buildTextField("Pro Tip", proTipController, maxLines: 2),
        _buildTextField("Notes", notesController, maxLines: 2),
        _buildTextField("Quantity", quantityController, type: TextInputType.number),
      ],
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    materialsController.dispose();
    productInfoController.dispose();
    notesController.dispose();
    quantityController.dispose();
    proTipController.dispose();
    toDoController.dispose();
    notToDoController.dispose();
    super.dispose();
  }
}

