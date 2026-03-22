import 'package:flutter/material.dart';

/// Blueprint for a feature highlight card.
/// Defines the visual identity and content for key application capabilities.
class KeyFeatureItem {
  final String title;       // Headline of the feature (e.g., "Real-time Tracking")
  final String subtitle;    // Short description explaining the feature's value
  final IconData icon;      // Visual representation of the feature
  final Color iconColor;    // Color of the icon for brand consistency
  final Color iconBgColor;  // Background tint for the icon to create a soft look

  const KeyFeatureItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
  });
}