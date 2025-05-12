import 'package:flutter/material.dart';

class TypesButton extends StatefulWidget {
  final Function(String) onTypeSelected;

  const TypesButton({super.key, required this.onTypeSelected});

  @override
  _TypesButtonState createState() => _TypesButtonState();
}

class _TypesButtonState extends State<TypesButton> {
  String _selectedType = "Type";

  final List<String> types = [
    'Type',
    'Recyclable',
    'Biodegradable',
    'Non-Biodegradable',
  ];

  @override
  Widget build(BuildContext context) {
    final isDefault = _selectedType == "Type";
    final color = isDefault ? Colors.black38 : const Color(0xff558B2F);
    final borderColor = isDefault ? const Color(0xFFadadad) : const Color(0xff558B2F);

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: borderColor),
      ),
      child: SizedBox(
        height: 40,
        child: DropdownButton<String>(
          value: _selectedType,
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedType = newValue;
              });
              widget.onTypeSelected(newValue);
            }
          },
          items: types.map((type) {
            return DropdownMenuItem<String>(
              value: type,
              child: Text(
                type,
                style: TextStyle(color: type == 'Type' ? Colors.black38 : color),
              ),
            );
          }).toList(),
          isExpanded: true,
          style: TextStyle(color: color),
          iconEnabledColor: color,
          underline: Container(),
        ),
      ),
    );
  }
}
