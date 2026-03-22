import 'package:flutter/material.dart';

class InfoBanner extends StatelessWidget {
  const InfoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBE6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFE58F)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('💡', style: TextStyle(fontSize: 18)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Your sighting helps researchers track wildlife populations and movements. '
              'All reports are verified by park rangers.',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF5A4500),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}