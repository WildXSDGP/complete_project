import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool isLoading;
  final VoidCallback? onPressed;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.isActive,
    this.isLoading = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool tappable = isActive && !isLoading;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity, height: 52,
      decoration: BoxDecoration(
        color: tappable ? const Color(0xFF4CAF50) : const Color(0xFFE8E8E8),
        borderRadius: BorderRadius.circular(14),
        boxShadow: tappable
            ? [BoxShadow(color: const Color(0xFF4CAF50).withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 6))]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: tappable ? onPressed : null,
          child: Center(
            child: isLoading
                ? const SizedBox(width: 22, height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                : Text(label,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                        color: tappable ? Colors.white : Colors.grey[400])),
          ),
        ),
      ),
    );
  }
}
