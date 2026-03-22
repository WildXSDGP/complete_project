// lib/widgets/settings/feedback/star_rating.dart

import 'package:flutter/material.dart';

/// A reusable star rating component.
/// Allows users to tap stars to set a rating from 1 to 5.
class StarRating extends StatelessWidget {
  final int rating;           // Current score (0 to 5)
  final ValueChanged<int> onRatingChanged; // Function to run when a star is tapped
  final double starSize;      // Customizable star diameter

  const StarRating({
    super.key,
    required this.rating,
    required this.onRatingChanged,
    this.starSize = 36, // Default size if not provided
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (i) {
        // 'i' starts from 0, so if rating is 3, stars 0, 1, and 2 will be filled.
        final filled = i < rating;
        
        return GestureDetector(
          onTap: () => onRatingChanged(i + 1), // Returns the actual rating (1-5)
          child: Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Icon(
              // Shows a filled star or an outline based on the current rating
              filled ? Icons.star_rounded : Icons.star_outline_rounded,
              color: filled ? const Color(0xFFFFCC00) : Colors.grey[300],
              size: starSize,
            ),
          ),
        );
      }),
    );
  }
}