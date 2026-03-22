import 'package:flutter/material.dart';

/// Reusable white card wrapper for input fields
class InputCard extends StatelessWidget {
  final Widget child;
  const InputCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 14, offset: const Offset(0, 4))],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: child,
    );
  }
}

/// Small grey label above an input
class InputLabel extends StatelessWidget {
  final String label;
  const InputLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(label,
        style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w500));
  }
}
