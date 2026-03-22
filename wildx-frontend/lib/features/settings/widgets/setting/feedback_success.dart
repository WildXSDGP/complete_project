// lib/widgets/settings/feedback/feedback_success.dart

import 'package:flutter/material.dart';

/// A simple success view that appears after the user submits feedback.
/// It provides a positive confirmation and a "Done" button to close the sheet.
class FeedbackSuccess extends StatelessWidget {
  final VoidCallback onDone;

  const FeedbackSuccess({super.key, required this.onDone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Shrinks the column to fit its contents
        children: [
          // ── Visual Indicator: Green Check Circle ────────────────────
          Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              color: Color(0xFFE8F5E9), // Soft green background
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Color(0xFF2ECC71), // Vibrant green check mark
              size: 36,
            ),
          ),
          const SizedBox(height: 16),

          // ── Header Text ─────────────────────────────────────────────
          const Text(
            'Thank you!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 8),

          // ── Description Text ────────────────────────────────────────
          Text(
            'Your feedback helps us improve WildX for wildlife enthusiasts everywhere.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[500],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),

          // ── Completion Button ───────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onDone, // Triggers the callback to close the sheet
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2ECC71), // Matches the checkmark
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Done',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}