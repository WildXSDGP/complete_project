import 'package:flutter/material.dart';

class EmailSentCard extends StatelessWidget {
  final String email;
  final VoidCallback onBack;

  const EmailSentCard({super.key, required this.email, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Column(
        children: [
          Container(
            width: 60, height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1), shape: BoxShape.circle,
            ),
            child: const Icon(Icons.mark_email_read_rounded, color: Color(0xFF4CAF50), size: 30),
          ),
          const SizedBox(height: 16),
          const Text('Check your email!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A))),
          const SizedBox(height: 10),
          Text('We sent a sign-in link to\n$email',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[500], height: 1.6)),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: onBack,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_back_rounded, size: 15, color: Colors.grey[400]),
                const SizedBox(width: 6),
                Text('Try different method',
                    style: TextStyle(fontSize: 13, color: Colors.grey[400])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
