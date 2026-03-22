import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/national_park_model.dart';
import '../screens/park_details_screen.dart';
import '../screens/park_map_screen.dart';

class ParkCard extends StatelessWidget {
  final NationalPark park;
  const ParkCard({super.key, required this.park});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ParkDetailsScreen(park: park)),
          ),
          child: _ParkImage(imageUrl: park.imageUrl, parkName: park.name),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ParkDetailsScreen(park: park)),
              ),
              child: Text(
                park.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (park.location != null)
              _InfoRow(
                icon: Icons.location_on_rounded,
                color: Colors.grey,
                text: park.location!,
              ),
            if (park.openingTime != null && park.closingTime != null) ...[
              const SizedBox(height: 4),
              _InfoRow(
                icon: Icons.access_time_rounded,
                color: Colors.grey,
                text: '${park.openingTime} - ${park.closingTime}',
              ),
            ],
            if (park.entryFee != null) ...[
              const SizedBox(height: 4),
              _InfoRow(
                icon: Icons.monetization_on_rounded,
                color: Colors.grey,
                text: 'LKR ${park.entryFee!.toStringAsFixed(2)}',
              ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ParkMapScreen(park: park)),
                ),
                icon: const Icon(Icons.map_outlined, size: 18),
                label: const Text(
                  'View Map',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ]),
        ),
      ]),
    );
  }
}

class _ParkImage extends StatelessWidget {
  final String? imageUrl;
  final String parkName;
  const _ParkImage({required this.imageUrl, required this.parkName});

  static const _parkColors = {
    'Yala': Color(0xFF1B5E20),
    'Wilpattu': Color(0xFF2E7D32),
    'Minneriya': Color(0xFF1565C0),
    'Udawalawe': Color(0xFF33691E),
    'Horton': Color(0xFF4A148C),
    'Bundala': Color(0xFF006064),
    'Sinharaja': Color(0xFF1A237E),
  };

  static String? _assetForPark(String parkName) {
    final normalized = parkName.toLowerCase();
    if (normalized.contains('yala')) {
      return 'assets/images/park_yala.webp';
    }
    if (normalized.contains('wilpattu')) {
      return 'assets/images/park_wilpattu.jpg';
    }
    if (normalized.contains('udawalawe')) {
      return 'assets/images/park_udawalawe.jpg';
    }
    return null;
  }

  Color get _bgColor {
    for (final key in _parkColors.keys) {
      if (parkName.contains(key)) return _parkColors[key]!;
    }
    return const Color(0xFF2E7D32);
  }

  @override
  Widget build(BuildContext context) {
    final assetPath = _assetForPark(parkName);

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: assetPath != null
          ? Image.asset(
              assetPath,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _networkOrPlaceholder(),
            )
          : _networkOrPlaceholder(),
    );
  }

  Widget _networkOrPlaceholder() {
    if (!kIsWeb && imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() => Container(
        height: 200,
        width: double.infinity,
        color: _bgColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.park_rounded, size: 60, color: Colors.white54),
            const SizedBox(height: 8),
            Text(
              parkName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  const _InfoRow({required this.icon, required this.color, required this.text});

  @override
  Widget build(BuildContext context) => Row(children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey[700], fontSize: 13),
          ),
        ),
      ]);
}


