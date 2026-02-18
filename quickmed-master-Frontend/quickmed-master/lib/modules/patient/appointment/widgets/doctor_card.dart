import 'package:flutter/material.dart';
import '../../../../utils/app_text_style.dart';
import '../../../../utils/theme/colors/q_color.dart';

class DoctorCard extends StatelessWidget {
  final String name;
  final String speciality;
  final String miles;
  final VoidCallback onDirectionTap;
  final IconData icon; // custom icon support

  const DoctorCard({
    super.key,
    required this.name,
    required this.speciality,
    required this.miles,
    required this.onDirectionTap,
    this.icon = Icons.location_pin, // default icon
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: QColors.newPrimary500.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Doctor Name
          Text(
            "$name - $speciality",
            textAlign: TextAlign.center,
            style: TAppTextStyle.inter(
              fontSize: 15,
              weight: FontWeight.w600,
              color: QColors.newPrimary500,
            ),
          ),

          const SizedBox(height: 14),

          /// Location Row (with gray background)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Custom Icon (now changeable)
                Icon(icon, size: 20, color: Colors.redAccent),
                const SizedBox(width: 6),

                /// CLICKABLE GET DIRECTION
                GestureDetector(
                  onTap: onDirectionTap,
                  child: Text(
                    "Get direction",
                    overflow: TextOverflow.ellipsis,

                    style: TAppTextStyle.inter(
                      fontSize: 10,
                      weight: FontWeight.w300,
                      color: Colors.blue,
                    ),
                  ),
                ),

                const SizedBox(width: 8),
                const Text("|"),
                const SizedBox(width: 8),

                /// Miles text
                Text(
                  miles,
                  overflow: TextOverflow.ellipsis,
                  style: TAppTextStyle.inter(
                    color: Colors.black87,
                    fontSize: 10,
                    weight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
