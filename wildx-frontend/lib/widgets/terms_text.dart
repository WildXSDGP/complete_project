import 'package:flutter/material.dart';

class TermsText extends StatelessWidget {
  const TermsText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(fontSize: 11, color: Colors.grey[500], height: 1.6),
        children: const [
          TextSpan(text: "By continuing, you agree to WildX's "),
          TextSpan(text: 'Terms of Service',
              style: TextStyle(color: Color(0xFF4CAF50), fontWeight: FontWeight.w600)),
          TextSpan(text: '\nand '),
          TextSpan(text: 'Privacy Policy',
              style: TextStyle(color: Color(0xFF4CAF50), fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
