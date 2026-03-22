import 'package:flutter/material.dart';

class GalleryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GalleryAppBar({super.key});

  // Defining the standard height for the AppBar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF2E7D32), // WildX Nature Green theme
      elevation: 0, // Flat design for a modern look
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded, // Modern iOS-style back icon
          color: Colors.white, 
          size: 20
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Wildlife Gallery',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2, // Slight tracking adjustment for better readability
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white, size: 24),
          onPressed: () {
            // Placeholder for search functionality
          },
        ),
        const SizedBox(width: 4), // Padding at the end of actions
      ],
    );
  }
}