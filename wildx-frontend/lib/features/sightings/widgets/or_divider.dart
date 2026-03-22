import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: Colors.grey[200])),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('OR',
              style: TextStyle(fontSize: 12, color: Colors.grey[400],
                  fontWeight: FontWeight.w600, letterSpacing: 1.5)),
        ),
        Expanded(child: Container(height: 1, color: Colors.grey[200])),
      ],
    );
  }
}
