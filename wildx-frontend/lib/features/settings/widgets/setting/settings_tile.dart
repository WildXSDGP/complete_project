// lib/widgets/settings/settings_tile.dart

import 'package:flutter/material.dart';

/// A reusable row for the Settings screen.
/// It displays an icon with a background color, a label, and an optional 
/// trailing widget (like a toggle or an arrow).
class SettingsTile extends StatelessWidget {
  final IconData icon;       // The symbol to show on the left
  final Color iconColor;     // The color for the icon and its background glow
  final String label;        // The title of the setting item
  final VoidCallback onTap;  // Action to perform when clicked
  final Widget? trailing;    // Optional widget for the right side (defaults to an arrow)

  const SettingsTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        // Visual feedback when the user touches the tile
        splashColor: const Color(0xFFF2F2F7),
        highlightColor: const Color(0xFFF2F2F7),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              // ── Icon Container ──────────────────────────────────────────
              // Creates a small rounded square with a faint version of the icon color
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 14),

              // ── Setting Label ───────────────────────────────────────────
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ),

              // ── Trailing Widget ─────────────────────────────────────────
              // If no trailing widget is provided, show a default grey arrow
              trailing ??
                  Icon(Icons.chevron_right_rounded,
                      color: Colors.grey[350], size: 20),
            ],
          ),
        ),
      ),
    );
  }
}