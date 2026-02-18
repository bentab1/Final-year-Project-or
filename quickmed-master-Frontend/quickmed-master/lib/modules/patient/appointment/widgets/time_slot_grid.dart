import 'package:flutter/material.dart';
import '../../../../utils/app_text_style.dart';
import '../../../../utils/theme/colors/q_color.dart';
class TimeSlotGrid extends StatelessWidget {
  final List<String> slots;
  final int? selectedSlotIndex;
  final void Function(int)? onSlotSelected; // Make it nullable with ?

  const TimeSlotGrid({
    super.key,
    required this.slots,
    this.selectedSlotIndex,
    this.onSlotSelected, // Remove required
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final isSelected = selectedSlotIndex == index;
        final isEnabled = onSlotSelected != null; // Check if callback exists

        return GestureDetector(
          onTap: isEnabled ? () => onSlotSelected!(index) : null,
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? QColors.newPrimary500
                  : (isEnabled ? Colors.grey[200] : Colors.grey[100]),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? QColors.newPrimary500 : Colors.grey[300]!,
              ),
            ),
            child: Center(
              child: Text(
                slots[index],
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : (isEnabled ? Colors.black : Colors.grey),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
// class TimeSlotGrid extends StatelessWidget {
//   final List<String> slots;
//   final int? selectedSlotIndex;
//   final Function(int) onSlotSelected;
//
//   const TimeSlotGrid({
//     super.key,
//     required this.slots,
//     required this.selectedSlotIndex,
//     required this.onSlotSelected,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final bool isDark = Theme.of(context).brightness == Brightness.dark;
//
//     return Column(
//       children: [
//         Divider(color: isDark ? Colors.white24 : Colors.grey.shade400),
//
//         /// Build rows with 2 items per row
//         for (int i = 0; i < slots.length; i += 2)
//           Column(
//             children: [
//               Row(
//                 children: [
//                   /// LEFT SLOT
//                   Expanded(
//                     child: _slotBox(
//                       context,
//                       index: i,
//                       text: slots[i],
//                     ),
//                   ),
//
//                   /// VERTICAL BAR
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 10),
//                     child: Text(
//                       "|",
//                       style: TextStyle(
//                         fontSize: 20,
//                         color: isDark ? Colors.white54 : Colors.grey.shade600,
//                       ),
//                     ),
//                   ),
//
//                   /// RIGHT SLOT IF EXISTS
//                   Expanded(
//                     child: (i + 1 < slots.length)
//                         ? _slotBox(
//                       context,
//                       index: i + 1,
//                       text: slots[i + 1],
//                     )
//                         : Container(),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 10),
//
//               /// ALWAYS SHOW DASHED DIVIDER
//               _dashedDivider(isDark),
//
//               const SizedBox(height: 10),
//             ],
//           )
//       ],
//     );
//   }
//
//   /// --- Dashed Divider ---
//   Widget _dashedDivider(bool isDark) {
//     return Row(
//       children: List.generate(
//         40,
//             (_) => Expanded(
//           child: Container(
//             margin: const EdgeInsets.symmetric(horizontal: 2),
//             height: 1,
//             color: isDark ? Colors.white24 : Colors.grey.shade400,
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// --- Slot Box ---
//   Widget _slotBox(BuildContext context, {required int index, required String text}) {
//     final bool selected = selectedSlotIndex == index;
//     final bool isDark = Theme.of(context).brightness == Brightness.dark;
//
//     return GestureDetector(
//       onTap: () => onSlotSelected(index),
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 12),
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(6),
//           color: selected
//               ? QColors.newPrimary500.withOpacity(0.15)
//               : Colors.transparent,
//         ),
//         child: Text(
//           text,
//           textAlign: TextAlign.center,
//           style: TAppTextStyle.inter(
//             fontSize: 14,
//             weight: FontWeight.w500,
//             color: isDark ? Colors.white : Colors.black87,
//           ),
//         ),
//       ),
//     );
//   }
// }
