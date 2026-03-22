import 'package:flutter/material.dart';

class GallerySearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const GallerySearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        // Adding a subtle shadow to give the search bar depth
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E)),
        decoration: InputDecoration(
          hintText: 'Search animals...',
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          // Search icon at the beginning of the field
          prefixIcon: Icon(Icons.search, color: Colors.grey[400], size: 20),
          
          // Clear button appears only when there is text, improving UX efficiency
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[400], size: 18),
                  onPressed: () {
                    controller.clear(); // Clears the input field
                    onChanged('');      // Triggers the filter to reset
                  },
                )
              : null,
          border: InputBorder.none, // Removing the default line for a cleaner look
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}