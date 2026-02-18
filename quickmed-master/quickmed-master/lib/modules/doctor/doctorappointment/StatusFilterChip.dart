import 'package:flutter/material.dart';
import '../../../utils/app_text_style.dart';
import 'StatusColorHelper.dart'; // Make sure this path is correct

class StatusFilterChip extends StatelessWidget {
  final String value;
  final String label;
  final int count;
  final String selectedValue;
  final ValueChanged<String> onSelected;

  const StatusFilterChip({
    Key? key,
    required this.value,
    required this.label,
    required this.count,
    required this.selectedValue,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedValue == value;
    final statusColor = StatusColorHelper.getStatusColor(value);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FilterChip(

        label: Text('$label ($count)'),
        selected: isSelected,
        onSelected: (selected) {
          onSelected(value);
        },
        selectedColor: statusColor.withOpacity(0.2),
        checkmarkColor: statusColor,
        backgroundColor: Colors.grey.shade200,
        labelStyle: TAppTextStyle.inter(
          fontSize: 13,
          weight: isSelected ? FontWeight.w600 : FontWeight.w500,
          color: isSelected ? statusColor : Colors.grey.shade700,
        ),
      ),
    );
  }
}
