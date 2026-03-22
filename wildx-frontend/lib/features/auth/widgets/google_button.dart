import 'package:flutter/material.dart';

class GoogleButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const GoogleButton({super.key, this.isLoading = false, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[300]!, width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: isLoading ? null : onPressed,
          child: Center(
            child: isLoading
                ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('G', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF4285F4))),
                      const SizedBox(width: 10),
                      Text('Continue with Google', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey[700])),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
