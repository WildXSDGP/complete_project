// lib/widgets/settings/feedback/feedback_sheet.dart

import 'package:flutter/material.dart';
import 'star_rating.dart';
import 'feedback_type_chips.dart';
import 'feedback_success.dart';

/// A interactive bottom sheet that allows users to send feedback.
/// It handles star ratings, feedback categories, and text messages.
class FeedbackSheet extends StatefulWidget {
  const FeedbackSheet({super.key});

  // Static helper method to trigger the bottom sheet from anywhere
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the sheet to resize when keyboard opens
      backgroundColor: Colors.transparent,
      builder: (_) => const FeedbackSheet(),
    );
  }

  @override
  State<FeedbackSheet> createState() => _FeedbackSheetState();
}

class _FeedbackSheetState extends State<FeedbackSheet> {
  int _rating = 0;
  String _selectedType = 'General';
  final TextEditingController _controller = TextEditingController();
  bool _submitted = false; // Tracks if the success view should be shown

  @override
  void dispose() {
    _controller.dispose(); // Always clean up controllers to save memory
    super.dispose();
  }

  // Validation logic before "submitting" the feedback
  void _submit() {
    if (_rating == 0 || _controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please add a rating and message'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: const Color(0xFF1A1A2E),
        ),
      );
      return;
    }
    // Switch to success view
    setState(() => _submitted = true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Important: Adjusts padding so the keyboard doesn't hide the text field
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: _submitted
            ? FeedbackSuccess(onDone: () => Navigator.pop(context))
            : _buildForm(),
      ),
    );
  }

  // ── Feedback Form UI ───────────────────────────────────────────────
  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Visual handle at the top of the sheet
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E5EA),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header with Icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF2D55).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.rate_review_outlined, color: Color(0xFFFF2D55), size: 22),
              ),
              const SizedBox(width: 12),
              const Text('Send Feedback', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 20),

          // 1. Star Rating Section
          const Text('How would you rate WildX?', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          StarRating(
            rating: _rating,
            onRatingChanged: (r) => setState(() => _rating = r),
          ),
          const SizedBox(height: 18),

          // 2. Feedback Type Section (Chips)
          const Text('Feedback type', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          FeedbackTypeChips(
            selected: _selectedType,
            onSelected: (t) => setState(() => _selectedType = t),
          ),
          const SizedBox(height: 18),

          // 3. Message Input Section
          const Text('Your message', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _controller,
              maxLines: 5,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: 'Tell us what you love or what bugs you found...',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(14),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 4. Final Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF2D55),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Submit Feedback', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}