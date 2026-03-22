// lib/widgets/settings/settings_footer.dart

import 'package:flutter/material.dart';

/// A simple footer widget for the bottom of the Settings screen.
/// Displays the current app version and copyright information.
class SettingsFooter extends StatelessWidget {
  final String version;
  final String copyright;

  const SettingsFooter({
    super.key,
    // Default values so you don't have to pass them every time
    this.version = 'WildX v1.0.0',
    this.copyright = '© 2026 WildX. All rights reserved.',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── App Version ──────────────────────────────────────────────
        Text(
          version,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFFAEAEB2), // Light grey color
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        
        // ── Copyright Info ───────────────────────────────────────────
        Text(
          copyright,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFFC7C7CC), // Even lighter grey for secondary info
          ),
        ),
      ],
    );
  }
}