import 'package:flutter/material.dart';
import '../data/about_data.dart';
import 'section_card.dart';

class MissionSection extends StatelessWidget {
  const MissionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Combining a heart icon with the section title to show passion for wildlife
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE4EC), // Soft pink background for the heart icon
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.favorite,
                  color: Color(0xFFE91E63),
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Our Mission',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Mission statement with optimized line height for easy reading
          Text(
            missionText,
            style: TextStyle(
              fontSize: 13.5,
              color: Colors.grey[600],
              height: 1.6, // Adding breathing room between lines
            ),
          ),
        ],
      ),
    );
  }
}