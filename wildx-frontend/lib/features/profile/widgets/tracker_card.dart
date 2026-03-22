import 'package:flutter/material.dart';
import '../models/ranger_model.dart';
import '../theme/safari_theme.dart';

class TrackerCardRow extends StatelessWidget {
  final RangerModel ranger;

  const TrackerCardRow({super.key, required this.ranger});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: SafariTheme.cardDecoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _StatTile(label: 'Sightings', value: ranger.sightingsCount.toString(), icon: Icons.visibility_rounded),
          _StatTile(label: 'Parks', value: ranger.parksVisited.toString(), icon: Icons.park_rounded),
          _StatTile(label: 'Photos', value: ranger.photosCount.toString(), icon: Icons.photo_camera_rounded),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatTile({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 22, color: SafariTheme.forestGreen),
        const SizedBox(height: 8),
        Text(value, style: SafariTheme.displayFont.copyWith(fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: SafariTheme.textSecondary)),
      ],
    );
  }
}
