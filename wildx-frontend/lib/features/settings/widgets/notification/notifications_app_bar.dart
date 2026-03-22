import 'package:flutter/material.dart';

class NotificationsAppBar extends StatelessWidget {
  const NotificationsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Adding padding to ensure the app bar content doesn't touch the screen edges
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        children: [
          // Custom back button to navigate to the previous screen
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            color: const Color(0xFF1A1A2E),
            iconSize: 20,
          ),
          const SizedBox(width: 4),
          // Clean, bold title for the screen
          const Text(
            'Notifications',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
              letterSpacing: -0.3, // Slight tightening for a premium look
            ),
          ),
        ],
      ),
    );
  }
}