import 'package:flutter/material.dart';

class ProfilePic extends StatelessWidget {
  final String imagePath;
  final VoidCallback onTap;

  const ProfilePic({super.key, required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(image: AssetImage(imagePath)),
          ),
        ),
      ),
    );
  }
}
