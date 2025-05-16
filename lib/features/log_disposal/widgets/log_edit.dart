// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/models/scan_result_model.dart';
import '../../../core/services/waste_entry_service.dart';
import '../../../core/utils/constants.dart';
import '../../waste_scanner/frontend/widgets/log_button.dart';

class LogEdit extends StatefulWidget {
  final ScanResult scanResult;

  // FIXME: make this required
  //final Function(ScanResult)? onDetailsUpdated;

  const LogEdit({
    super.key,
    required this.scanResult,
    //this.onDetailsUpdated
  });

  @override
  State<LogEdit> createState() => _LogEditState();
}

class _LogEditState extends State<LogEdit> {
  // text controllers
  late TextEditingController _productNameController;
  late TextEditingController _prodInfoController;
  late TextEditingController _proTipController;
  late TextEditingController _noteController;
  late TextEditingController _quantityController;

  late List<TextEditingController> _materialControllers;
  late List<TextEditingController> _toDoControllers;
  late List<TextEditingController> _notToDoControllers;

  String? _classificationValue;

  @override
  void initState() {
    super.initState();

    _productNameController = TextEditingController(
      text: widget.scanResult.productName,
    );
    _prodInfoController = TextEditingController(
      text: widget.scanResult.prodInfo,
    );
    _proTipController = TextEditingController(text: widget.scanResult.proTip);
    _noteController = TextEditingController(text: widget.scanResult.notes);
    _quantityController = TextEditingController(
      text: widget.scanResult.qty.toString(),
    );
    _classificationValue = widget.scanResult.classification;

    _materialControllers =
        widget.scanResult.materials
            .map((material) => TextEditingController(text: material))
            .toList();
    _toDoControllers =
        widget.scanResult.toDo
            .map((todo) => TextEditingController(text: todo))
            .toList();
    _notToDoControllers =
        widget.scanResult.notToDo
            .map((notToDo) => TextEditingController(text: notToDo))
            .toList();
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _prodInfoController.dispose();
    _noteController.dispose();
    _quantityController.dispose();

    for (var controller in _materialControllers) {
      controller.dispose();
    }
    for (var controller in _toDoControllers) {
      controller.dispose();
    }
    for (var controller in _notToDoControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  void _onSave() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not logged in')));
      return;
    }

    final updated = ScanResult(
      id: widget.scanResult.id,
      productName: _productNameController.text.trim(),
      materials:
          _materialControllers
              .map((c) => c.text.trim())
              .where((e) => e.isNotEmpty)
              .toList(),
      prodInfo: _prodInfoController.text.trim(),
      classification: _classificationValue ?? widget.scanResult.classification,
      toDo:
          _toDoControllers
              .map((c) => c.text.trim())
              .where((e) => e.isNotEmpty)
              .toList(),
      notToDo:
          _notToDoControllers
              .map((c) => c.text.trim())
              .where((e) => e.isNotEmpty)
              .toList(),
      proTip: widget.scanResult.proTip,
      notes: _noteController.text.trim(),
      qty:
          int.tryParse(_quantityController.text.trim()) ??
          widget.scanResult.qty,
      timestamp: widget.scanResult.timestamp,
    );

    final service = WasteEntryService();

    try {
      await service.updateWasteEntries(user, updated);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entry updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to update entry')));
    }
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType? type,
    int maxLines = 1,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        maxLines: maxLines,
        cursorColor: kForestGreen,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF228B22), width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildTextListField(
    String label,
    List<TextEditingController> controllers, {
    TextInputType? type,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: kForestGreen,
          ),
        ),
        const SizedBox(height: 8),

        ...controllers.map(
          (controller) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: TextFormField(
              controller: controller,
              keyboardType: type,
              maxLines: maxLines,
              cursorColor: kForestGreen,
              decoration: InputDecoration(
                hintText: 'Enter value...',
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF228B22), width: 2),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClassificationDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: _classificationValue,
        dropdownColor: const Color(0xFFF4F4F4),
        decoration: const InputDecoration(
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
                Image.asset(
                  'assets/images/icons/recycling.png',
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 8),
                const Text('Recyclable'),
              ],
            ),
          ),
          DropdownMenuItem(
            value: 'Biodegradable',
            child: Row(
              children: [
                Image.asset(
                  'assets/images/icons/leaf_brown.png',
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 8),
                const Text('Biodegradable'),
              ],
            ),
          ),
          DropdownMenuItem(
            value: 'Non-biodegradable',
            child: Row(
              children: [
                Image.asset(
                  'assets/images/icons/trashcan.png',
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 8),
                const Text('Non-Biodegradable'),
              ],
            ),
          ),
        ],
        onChanged: (value) {
          setState(() {
            _classificationValue = value;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Title",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: kForestGreen,
          ),
        ),
        _buildTextField("Title", _productNameController),

        SizedBox(height: 20),

        _buildTextListField("Materials", _materialControllers),

        SizedBox(height: 20),

        Text(
          "Waste Type",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: kForestGreen,
          ),
        ),
        _buildClassificationDropdown(),

        SizedBox(height: 20),

        _buildTextListField("What To Do", _toDoControllers),

        SizedBox(height: 20),

        _buildTextListField("What To NOT Do", _notToDoControllers),

        SizedBox(height: 20),

        Text(
          "Pro Tip",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: kForestGreen,
          ),
        ),
        _buildTextField("Pro Tip", _proTipController, maxLines: 2),

        SizedBox(height: 20),

        Text(
          "Notes (Optional)",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: kForestGreen,
          ),
        ),
        _buildTextField("Notes", _noteController),

        SizedBox(height: 20),

        Text(
          "Quantity (Optional)",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: kForestGreen,
          ),
        ),
        _buildTextField(
          "Quantity",
          _quantityController,
          type: TextInputType.number,
        ),

        SizedBox(height: 20),

        Align(
          alignment: Alignment.centerRight,
          child: LogButton(
            title: 'Save',
            onPressed: () async {
              _onSave();
              //Navigator.pop(context);
            },
          ),
        ),

        SizedBox(height: 50),
      ],
    );
  }
}
