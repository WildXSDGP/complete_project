// lib/widgets/settings/feedback/feedback_type_chips.dart

import 'package:flutter/material.dart';
import '../../data/settings_data.dart';

/// A custom chip selector widget that displays feedback categories.
/// Users can tap a chip to select the type of feedback they are sending.
class FeedbackTypeChips extends StatelessWidget {
  final String selected; // Currently active selection
  final ValueChanged<String> onSelected; // Callback when a new chip is tapped

  const FeedbackTypeChips({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8, // Horizontal space between chips
      runSpacing: 8, // Vertical space between lines of chips
      children: feedbackTypes.map((type) {
        final isSelected = selected == type;
        
        return GestureDetector(
          onTap: () => onSelected(type),
          child: AnimatedContainer(
            // Smoothly transitions the color change when a chip is selected
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFFF2D55) // WildX Red for active
                  : const Color(0xFFF2F2F7), // Light grey for inactive
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              type,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
            ),
          ),
        );
      }).toList(), // Converts the map operation into a list of widgets
    );
  }
}