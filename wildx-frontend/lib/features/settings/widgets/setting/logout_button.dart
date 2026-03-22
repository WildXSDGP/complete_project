// lib/widgets/settings/logout_button.dart

import 'package:flutter/material.dart';

/// A customized button for the logout action.
/// Features a soft red background and high-contrast text to warn the user 
/// about the destructive nature of the action.
class LogoutButton extends StatelessWidget {
  final VoidCallback onTap; // Function that runs when the button is clicked

  const LogoutButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Material(
        color: const Color(0xFFFFF0F0), // Very light red background
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          splashColor: const Color(0xFFFFD5D5), // Visual feedback when tapped
          child: Container(
            width: double.infinity, // Makes the button take the full available width
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center, // Centers the icon and text
              children: [
                // ── Logout Icon ──────────────────────────────────────────
                Icon(
                  Icons.logout_rounded, 
                  color: Color(0xFFFF3B30), // Standard iOS-style danger red
                  size: 19,
                ),
                SizedBox(width: 8),
                
                // ── Logout Text ──────────────────────────────────────────
                Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFF3B30),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}