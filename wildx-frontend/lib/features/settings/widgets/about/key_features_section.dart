import 'package:flutter/material.dart';
import '../../data/about_data.dart';
import '../../models/key_feature_item.dart';
import 'section_card.dart';

class KeyFeaturesSection extends StatelessWidget {
  const KeyFeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Key Features',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 14),
          // Efficiently rendering the list of features using the spread operator
          ...keyFeatures.map((feature) => _FeatureTile(feature: feature)),
        ],
      ),
    );
  }
}

/// A private component to display individual feature highlights.
/// This promotes modularity within the section.
class _FeatureTile extends StatelessWidget {
  final KeyFeatureItem feature;

  const _FeatureTile({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon container with specific branding colors from the data model
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: feature.iconBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(feature.icon, color: feature.iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 2),
                // Subtitle with optimized line height for clarity in small text
                Text(
                  feature.subtitle,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.grey[500],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}