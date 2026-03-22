import 'package:flutter/material.dart';
import '../data/about_data.dart';
import 'section_card.dart';

class ConservationPartnerSection extends StatelessWidget {
  const ConservationPartnerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      // A subtle background tint to visually differentiate the partnership status
      color: const Color(0xFFFFFDE7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            conservationPartnerTitle,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 6),
          // Subtitle highlighting the specific authority partnership
          const Text(
            conservationPartnerSubtitle,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF555555),
            ),
          ),
          const SizedBox(height: 10),
          // Body text with increased line height for better legal/informational readability
          Text(
            conservationPartnerBody,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              height: 1.55, 
            ),
          ),
        ],
      ),
    );
  }
}