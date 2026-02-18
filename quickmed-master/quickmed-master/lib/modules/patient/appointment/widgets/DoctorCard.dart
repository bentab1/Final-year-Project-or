import 'package:flutter/material.dart';

import '../../../../data/models/models/DoctorModel.dart';
import '../../../../utils/app_text_style.dart';
import '../../../../utils/theme/colors/q_color.dart';

class DoctorCard extends StatelessWidget {
  final DoctorModel doctor;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const DoctorCard({
    super.key,
    required this.doctor,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? QColors.newPrimary500.withOpacity(0.1)
              : (isDark ? Colors.grey[850] : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? QColors.newPrimary500
                : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Doctor Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: QColors.newPrimary500.withOpacity(0.2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: doctor.imageUrl.isNotEmpty
                    ? Image.network(
                  doctor.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.person,
                      size: 40,
                      color: QColors.newPrimary500,
                    );
                  },
                )
                    : Icon(
                  Icons.person,
                  size: 40,
                  color: QColors.newPrimary500,
                ),
              ),
            ),

            const SizedBox(width: 16),

            /// Doctor Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Name
                  Text(
                    doctor.fullName,
                    style: TAppTextStyle.inter(
                      fontSize: 16,
                      weight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),

                  const SizedBox(height: 4),

                  /// Specialization
                  Text(
                    doctor.specialization,
                    style: TAppTextStyle.inter(
                      fontSize: 14,
                      weight: FontWeight.w500,
                      color: QColors.newPrimary500,
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          doctor.location,
                          style: TAppTextStyle.inter(
                            fontSize: 12,
                            weight: FontWeight.w400,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  /// Match Score
                  if (doctor.matchScore > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getMatchScoreColor(doctor.matchScore).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified,
                            size: 12,
                            color: _getMatchScoreColor(doctor.matchScore),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${doctor.matchScore}% Match",
                            style: TAppTextStyle.inter(
                              fontSize: 11,
                              weight: FontWeight.w600,
                              color: _getMatchScoreColor(doctor.matchScore),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 8),

                  /// Symptoms covered
                  if (doctor.symptomsList.isNotEmpty)
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: doctor.symptomsList.take(3).map((symptom) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.grey[800]
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            symptom,
                            style: TAppTextStyle.inter(
                              fontSize: 10,
                              weight: FontWeight.w400,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),

            /// Selection Indicator
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: QColors.newPrimary500,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Color _getMatchScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }
}