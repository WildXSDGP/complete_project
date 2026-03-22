import 'package:flutter/material.dart';

class RuleItem extends StatelessWidget {
  final String rule;
  const RuleItem({super.key, required this.rule});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, size: 20, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(child: Text(rule)),
        ],
      ),
    );
  }
}
