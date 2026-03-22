// lib/widgets/settings/section_card.dart

import 'package:flutter/material.dart';
import 'settings_tile.dart';

/// A wrapper widget that groups multiple SettingsTiles into a single visual block.
/// It automatically adds thin dividers between items for a clean, organized look.
class SectionCard extends StatelessWidget {
  final List<SettingsTile> items;

  const SectionCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Standard background for settings groups
      child: Column(
        children: [
          // We loop through the items list to build the column dynamically
          for (int i = 0; i < items.length; i++) ...[
            items[i],
            
            // Logic: Add a divider ONLY if it's NOT the last item in the list.
            if (i < items.length - 1)
              const Divider(
                height: 0,
                thickness: 0.5,
                color: Color(0xFFE5E5EA), // Very light grey divider
                indent: 56, // Starts after the icon to align with the text labels
              ),
          ],
        ],
      ),
    );
  }
}