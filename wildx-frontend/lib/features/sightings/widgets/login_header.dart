import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFA8D5A2), Color(0xFFE8A04A)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE8A04A).withOpacity(0.35),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Center(
            child: Text('🦁', style: TextStyle(fontSize: 36)),
          ),
        ),
        const SizedBox(height: 20),
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 26, fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A), letterSpacing: -0.5,
            ),
            children: [
              TextSpan(text: 'Welcome to Wild'),
              TextSpan(text: 'X', style: TextStyle(color: Color(0xFFE05A2B))),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Login to explore wildlife',
          style: TextStyle(fontSize: 14, color: Colors.grey[500]),
        ),
      ],
    );
  }
}
