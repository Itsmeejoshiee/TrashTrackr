import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';
import 'package:trashtrackr/core/widgets/box/neo_box.dart';

class FilterMenu extends StatefulWidget {
  final Function(String filter, bool isNewest) onFilterChanged;

  const FilterMenu({super.key, required this.onFilterChanged});

  @override
  State<FilterMenu> createState() => _FilterMenuState();
}

class _FilterMenuState extends State<FilterMenu> {
  String currentOrderBy = 'Newest';
  String? selectedFilter;
  bool _isOldest = true;

  void _notifyParent() {
    final filterToUse = selectedFilter ?? 'General Content';
    widget.onFilterChanged(filterToUse, _isOldest);
  }

  @override
  Widget build(BuildContext context) {
    return NeoBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order by', style: kTitleSmall),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isOldest = true;
                    });
                    _notifyParent();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: _isOldest ? kForestGreen : Colors.white,
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Newest',
                      style: kLabelLarge.copyWith(
                        color: _isOldest ? Colors.white : kGray,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isOldest = false;
                    });
                    _notifyParent();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: !_isOldest ? kForestGreen : Colors.white,
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Oldest',
                      style: kLabelLarge.copyWith(
                        color: _isOldest ? kGray : Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('Filter by', style: kTitleSmall),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8.0,
            children: [
              FilterChip(
                backgroundColor: Colors.white,
                checkmarkColor: Colors.white,
                label: Text(
                  'User',
                  style: kLabelLarge.copyWith(
                    color: selectedFilter == 'User' ? Colors.white : kGray,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                selected: selectedFilter == 'User',
                selectedColor: kForestGreen,
                onSelected: (bool selected) {
                  setState(() {
                    selectedFilter = selected ? 'User' : null;
                  });
                  _notifyParent();
                },
              ),
              FilterChip(
                backgroundColor: Colors.white,
                checkmarkColor: Colors.white,
                label: Text(
                  'General Content',
                  style: kLabelLarge.copyWith(
                    color:
                        selectedFilter == 'General Content'
                            ? Colors.white
                            : kGray,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                selected: selectedFilter == 'General Content',
                selectedColor: kForestGreen,
                onSelected: (bool selected) {
                  setState(() {
                    selectedFilter = selected ? 'General Content' : null;
                  });
                  _notifyParent();
                },
              ),
              FilterChip(
                backgroundColor: Colors.white,
                checkmarkColor: Colors.white,
                label: Text(
                  'Posts',
                  style: kLabelLarge.copyWith(
                    color: selectedFilter == 'Posts' ? Colors.white : kGray,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                selected: selectedFilter == 'Posts',
                selectedColor: kForestGreen,
                onSelected: (bool selected) {
                  setState(() {
                    selectedFilter = selected ? 'Posts' : null;
                  });
                  _notifyParent();
                },
              ),
              FilterChip(
                backgroundColor: Colors.white,
                checkmarkColor: Colors.white,
                label: Text(
                  'Events',
                  style: kLabelLarge.copyWith(
                    color: selectedFilter == 'Events' ? Colors.white : kGray,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                selected: selectedFilter == 'Events',
                selectedColor: kForestGreen,
                onSelected: (bool selected) {
                  setState(() {
                    selectedFilter = selected ? 'Events' : null;
                  });
                  _notifyParent();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
