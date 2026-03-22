import 'package:flutter/material.dart';

/// A universal wrapper for UI segments to ensure visual consistency.
/// It provides a standardized look with soft shadows and rounded corners.
class SectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;

  const SectionCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // Uses custom padding if provided, otherwise falls back to a comfortable default
      padding: padding ??
          const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        // Customizable background color (useful for highlighted sections)
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          // Subtle shadow to give the card a slight "lift" from the background
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}