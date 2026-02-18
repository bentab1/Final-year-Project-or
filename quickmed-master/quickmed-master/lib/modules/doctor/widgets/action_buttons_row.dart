import 'package:flutter/material.dart';
class ActionButtonsRow extends StatelessWidget {
  final VoidCallback onAccept;
  final VoidCallback onAddNote;
  final VoidCallback onReject;

  const ActionButtonsRow({
    super.key,
    required this.onAccept,
    required this.onAddNote,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Accept Button
        _buildButton(
          text: 'Accept',
          backgroundColor: const Color(0xFF00D1FF),
          textColor: Colors.white,
          onTap: onAccept,
        ),

        // Add Note Button
        _buildButton(
          text: 'Add note',
          backgroundColor: Colors.white,
          textColor: Colors.black,
          borderColor: Colors.grey.shade300,
          onTap: onAddNote,
        ),

        // Reject Button
        _buildButton(
          text: 'Reject',
          backgroundColor: Colors.white,
          textColor: Colors.black,
          borderColor: Colors.grey.shade300,
          onTap: onReject,
        ),
      ],
    );
  }

  Widget _buildButton({
    required String text,
    required Color backgroundColor,
    required Color textColor,
    Color? borderColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: borderColor != null
                ? Border.all(color: borderColor, width: 1)
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}