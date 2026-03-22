import 'package:flutter/material.dart';
import '../data/about_data.dart';

class AboutFooter extends StatelessWidget {
  const AboutFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Interactive links for legal compliance and user trust
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {}, // Placeholder for Terms navigation
              child: const Text(
                'Terms of Service',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF2ECC71),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '•',
                style: TextStyle(color: Colors.grey[400], fontSize: 13),
              ),
            ),
            GestureDetector(
              onTap: () {}, // Placeholder for Privacy navigation
              child: const Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF2ECC71),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Copyright notice with a subtle grey to keep it unobtrusive
        Text(
          '© 2025 WildX. All rights reserved.',
          style: TextStyle(fontSize: 12, color: Colors.grey[400]),
        ),
        const SizedBox(height: 20),

        // "Made with Love" card to emphasize the app's local roots and passion
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Made with ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  Icon(Icons.favorite, color: Colors.red, size: 16),
                  Text(
                    ' in Sri Lanka',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Motivational closing text from central data
              Text(
                madeWithLoveText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[500],
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}