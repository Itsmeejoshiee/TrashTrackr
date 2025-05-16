import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class FilterModal extends StatefulWidget {
  final String? initialWasteType;
  final DateTimeRange? initialDateRange;
  final List<String> initialMultiSelect;
  final void Function(String?, DateTimeRange?, List<String>) onApply;
  final VoidCallback onReset;

  const FilterModal({
    super.key,
    required this.initialWasteType,
    required this.initialDateRange,
    required this.initialMultiSelect,
    required this.onApply,
    required this.onReset,
  });

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  String? selectedWasteType;
  DateTimeRange? selectedDateRange;
  List<String> selectedQuickFilters = [];

  final List<String> wasteTypes = [
    'Recycle',
    'Non-biodegradable',
    'Biodegradable',
    'E-Waste',
  ];

  final List<String> quickFilters = ['Today', 'Yesterday', 'Last 7 Days'];

  @override
  void initState() {
    super.initState();
    selectedWasteType = widget.initialWasteType;
    selectedDateRange = widget.initialDateRange;
    selectedQuickFilters = [...widget.initialMultiSelect];
  }

  void _pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime(now.year + 1),
      initialDateRange: selectedDateRange,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: kForestGreen, // Header background and selected dates
              onPrimary: Colors.white, // Text color on header
              onSurface: kForestGreen, // Text color on surface
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: kForestGreen, // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedDateRange = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white, // Light green background
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filters',
                style: kHeadlineSmall.copyWith(
                  color: kForestGreen,
                  fontWeight: FontWeight.w600,
                ), // Urbanist font
              ),
              TextButton(
                onPressed: widget.onReset,
                child: Text(
                  'Reset',
                  style: kTitleSmall.copyWith(
                    color: kForestGreen,
                  ), // Urbanist font
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Waste Type Dropdown
          DropdownButtonFormField<String>(
            value: selectedWasteType,
            decoration: InputDecoration(
              labelText: 'Waste Type',
              labelStyle: kTitleMedium.copyWith(
                color: kForestGreen,
              ), // Urbanist font
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 89, 119, 91),
                ), // Green border
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: kForestGreen,
                ), // Dark green border
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items:
                wasteTypes
                    .map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(
                          type,
                          style: kTitleSmall.copyWith(
                            color: kForestGreen,
                          ), // Urbanist font
                        ),
                      ),
                    )
                    .toList(),
            onChanged: (value) => setState(() => selectedWasteType = value),
          ),

          const SizedBox(height: 16),

          // Date Range Picker
          ListTile(
            title: Text(
              'Date Range',
              style: kTitleMedium.copyWith(
                color: kForestGreen,
              ), // Urbanist font
            ),
            subtitle: Text(
              selectedDateRange == null
                  ? 'Select a range'
                  : '${DateFormat.yMMMd().format(selectedDateRange!.start)} - ${DateFormat.yMMMd().format(selectedDateRange!.end)}',
              style: kTitleSmall.copyWith(color: kForestGreen), // Urbanist font
            ),
            trailing: const Icon(
              Icons.calendar_today,
              color: kForestGreen,
            ), // Green icon
            onTap: _pickDateRange,
          ),

          const SizedBox(height: 16),

          // Quick Filters as chips
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8,
              children:
                  quickFilters.map((filter) {
                    final isSelected = selectedQuickFilters.contains(filter);
                    return FilterChip(
                      label: Text(
                        filter,
                        style: kTitleSmall.copyWith(
                          color:
                              isSelected
                                  ? Colors.white
                                  : kForestGreen, // Urbanist font
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: kAvocado, // Light green when selected
                      backgroundColor: Colors.white, // White background
                      checkmarkColor: Colors.white, // White checkmark
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedQuickFilters.add(filter);
                          } else {
                            selectedQuickFilters.remove(filter);
                          }
                        });
                      },
                    );
                  }).toList(),
            ),
          ),

          const SizedBox(height: 24),

          // Apply button
          ElevatedButton(
            onPressed:
                () => widget.onApply(
                  selectedWasteType,
                  selectedDateRange,
                  selectedQuickFilters,
                ),
            style: ElevatedButton.styleFrom(
              backgroundColor: kAvocado, // Dark green button
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Apply',
              style: kTitleMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ), // Urbanist font
            ),
          ),
        ],
      ),
    );
  }
}
