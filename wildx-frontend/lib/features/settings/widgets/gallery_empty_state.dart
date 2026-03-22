import 'package:flutter/material.dart';

class GalleryEmptyState extends StatelessWidget {
  const GalleryEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Vertically center the empty state
        children: [
          // Using an emoji as a simple, lightweight visual placeholder
          const Text('🔍', style: TextStyle(fontSize: 52)),
          const SizedBox(height: 16),
          
          // Clear feedback to the user
          const Text(
            'No animals found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 6),
          
          // Guidance for the user on how to fix the current state
          Text(
            'Try a different search or category',
            style: TextStyle(
              fontSize: 13, 
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}