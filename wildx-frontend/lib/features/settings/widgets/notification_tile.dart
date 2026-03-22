import 'package:flutter/material.dart';
import 'custom_switch.dart';

class NotificationTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool showDivider;

  const NotificationTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.showDivider = true, // Defaulting to true for visual separation between list items
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center, // Vertically center the text with the switch
            children: [
              // Expanded ensures the text content takes up all available space
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A2E),
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[500],
                        height: 1.4, // Improved line height for multi-line readability
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Integrating the custom-built switch for a unified brand look
              CustomSwitch(value: value, onChanged: onChanged),
            ],
          ),
        ),
        // Conditional rendering of the divider to maintain a clean UI at the end of lists
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey[100],
            indent: 20, // Aligning the divider with the text content
            endIndent: 20,
          ),
      ],
    );
  }
}