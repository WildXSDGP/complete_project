import 'package:flutter/material.dart';

/// A reusable custom AppBar tailored for the "About" section.
/// Implements PreferredSizeWidget to integrate seamlessly with the Scaffold's appBar property.
class AboutAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AboutAppBar({super.key});

  @override
  // Standard toolbar height used to maintain material design consistency
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF2ECC71), // WildX primary green for brand identity
      elevation: 0, // Flat design for a modern, clean look
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white, 
          size: 20,
        ),
        onPressed: () => Navigator.pop(context), // Simple navigation to go back
      ),
      title: const Text(
        'About WildX',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
      ),
      centerTitle: false, // Left-aligned title for a professional, hierarchy-focused layout
    );
  }
}