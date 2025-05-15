import 'package:flutter/material.dart';

class TypesButton extends StatelessWidget {
  final String selectedType;
  final Function(String) onTypeSelected;

  const TypesButton({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  final List<String> types = const [
    'Type',
    'Recyclable',
    'Biodegradable',
    'Non-biodegradable',
  ];

  @override
  Widget build(BuildContext context) {
    final isDefault = selectedType == "Type";
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
          value: selectedType,
          onChanged: (String? newValue) {
            if (newValue != null) {
              onTypeSelected(newValue);
            }
          },
          items: types.map((type) {
            return DropdownMenuItem<String>(
              value: type,
              child: Text(
                type,
                style: TextStyle(
                  color: type == 'Type' ? Colors.black38 : const Color(0xff558B2F),
                ),
              ),
            );
          }).toList(),
          isExpanded: true,
          iconEnabledColor: color,
          underline: Container(),
          style: TextStyle(
            color: color,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
