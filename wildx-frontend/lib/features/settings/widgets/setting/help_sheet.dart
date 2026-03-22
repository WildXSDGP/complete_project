import 'package:flutter/material.dart';
import '../../data/settings_data.dart';
import 'faq_tile.dart';

/// A bottom sheet containing frequently asked questions (FAQs) to assist users.
/// It's accessed from the Settings screen via the 'Help & Support' tile.
class HelpSheet extends StatelessWidget {
  const HelpSheet({super.key});

  // Helper method to display the sheet from the parent Settings screen.
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Let Container handle the look
      builder: (_) => const HelpSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Standard spacing for modern iOS-style bottom sheets
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 60),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header Handle ──────────────────────────────────────────────
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E5EA),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // ── Sheet Title ────────────────────────────────────────────────
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.help_outline_rounded, color: Color(0xFF00C7BE), size: 24),
                SizedBox(width: 12),
                Text(
                  'Help & Support',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E)),
                ),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 0.5, color: Color(0xFFE5E5EA)),

          // ── FAQ List ──────────────────────────────────────────────────
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: faqItems.length,
              itemBuilder: (context, index) {
                final item = faqItems[index];
                return FaqTile(
                  question: item.question,
                  answer: item.answer,
                );
              },
            ),
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}