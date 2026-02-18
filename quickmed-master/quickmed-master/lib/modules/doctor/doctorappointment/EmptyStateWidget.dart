import 'package:flutter/material.dart';

import '../../../utils/app_text_style.dart';
import '../../../utils/theme/colors/q_color.dart';

class EmptyStateWidget extends StatelessWidget {
  final String? searchQuery;
  final String? selectedFilter;
  final VoidCallback? onClearFilters;

  const EmptyStateWidget({
    Key? key,
    this.searchQuery,
    this.selectedFilter,
    this.onClearFilters,
  }) : super(key: key);

  String _buildMessage() {
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      return "No appointments found for '$searchQuery'";
    } else if (selectedFilter != null && selectedFilter != 'all') {
      return "No ${_capitalizeFirst(selectedFilter!)} appointments";
    } else {
      return "No appointments available";
    }
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final bool showClearButton =
        (searchQuery != null && searchQuery!.isNotEmpty) ||
            (selectedFilter != null && selectedFilter != 'all');

    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 20),
          Text(
            _buildMessage(),
            textAlign: TextAlign.center,
            style: TAppTextStyle.inter(
              color: Colors.grey.shade600,
              fontSize: 16,
              weight: FontWeight.w500,
            ),
          ),
          if (showClearButton) ...[
            const SizedBox(height: 10),
            TextButton(
              onPressed: onClearFilters,
              child: Text(
                "Clear Filters",
                style: TAppTextStyle.inter(
                  color: QColors.progressLight,
                  fontSize: 14,
                  weight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
