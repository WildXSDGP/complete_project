import 'package:flutter/material.dart';
import '../models/ranger_model.dart';
import '../theme/safari_theme.dart';

class SafariParksCard extends StatelessWidget {
  final List<ParkVisit> parks;

  const SafariParksCard({super.key, required this.parks});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: SafariTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.map_rounded, color: SafariTheme.amber, size: 20),
              SizedBox(width: 8),
              Text('Top Parks', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: SafariTheme.textPrimary)),
            ],
          ),
          const SizedBox(height: 16),
          if (parks.isEmpty)
            const Text('No park visits yet.', style: TextStyle(color: SafariTheme.textSecondary))
          else
            Column(
              children: parks.take(5).map((park) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(park.parkName, style: const TextStyle(fontWeight: FontWeight.w600))),
                      Text('${park.visitCount}x', style: const TextStyle(color: SafariTheme.textSecondary)),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
