import 'package:flutter/material.dart';

class SharePhotoButton extends StatelessWidget {
  final VoidCallback onTap;

  const SharePhotoButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Outer padding to provide spacing from the screen edges
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        // Adding a top-oriented shadow to give a "floating" effect over the content
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -3), // Negative Y offset for top shadow
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity, // Ensures the button takes the full available width
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF2ECC71), // Nature-themed green
              borderRadius: BorderRadius.circular(30), // Rounded pill-shaped design
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Using a camera emoji for a friendly, approachable Call-To-Action (CTA)
                Text('📷', style: TextStyle(fontSize: 16)),
                SizedBox(width: 8),
                Text(
                  'Share Your Photo',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}