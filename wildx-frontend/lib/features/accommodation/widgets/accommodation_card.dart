import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../app_colors.dart';
import '../models/accommodation.dart';
import '../routes/app_routes.dart';
import 'app_badge.dart';

class AccommodationCard extends StatelessWidget {
  final Accommodation item;

  const AccommodationCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: kSpaceLG),
      decoration: BoxDecoration(
        color: kCardBackground,
        borderRadius: BorderRadius.circular(kRadiusLG),
        boxShadow: const [
          BoxShadow(color: kShadowColor, blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image + badges
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(kRadiusLG),
                ),
                child: _AccomImage(imageUrl: item.imageUrl, parkName: item.parkName),
              ),
              // Gradient overlay at bottom of image
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 60,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(kRadiusLG),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.3),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: kSpaceMD,
                right: kSpaceMD,
                child: Row(
                  children: [
                    if (item.isEcoFriendly)
                      const AppBadge(label: 'Eco', color: kGreen),
                    if (item.isEcoFriendly) const SizedBox(width: 6),
                    if (item.isFamilyFriendly)
                      const AppBadge(label: 'Family', color: kGreenLight),
                  ],
                ),
              ),
              // Rating chip on image
              Positioned(
                bottom: kSpaceMD,
                left: kSpaceMD,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(kRadiusSM),
                    boxShadow: const [
                      BoxShadow(color: kShadowColor, blurRadius: 6),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded, size: 14, color: kGreen),
                      const SizedBox(width: 3),
                      Text(
                        '${item.rating}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: kTextPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Details
          Padding(
            padding: const EdgeInsets.all(kSpaceLG),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: kTextPrimary,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: kSpaceXS),
                          Row(
                            children: [
                              const Icon(
                                Icons.park_outlined,
                                size: 13,
                                color: kGreen,
                              ),
                              const SizedBox(width: kSpaceXS),
                              Text(
                                item.parkName,
                                style: const TextStyle(
                                  color: kTextSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'LKR ${item.pricePerNight.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: kGreen,
                          ),
                        ),
                        const Text(
                          'per night',
                          style: TextStyle(fontSize: 11, color: kTextHint),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: kSpaceMD),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: kGreen,
                    ),
                    const SizedBox(width: kSpaceXS),
                    Text(
                      '${item.distanceFromGate} km from gate',
                      style: const TextStyle(
                        color: kTextSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: kSpaceSM),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: kGreen),
                    const SizedBox(width: kSpaceXS),
                    Text(
                      item.travelTime,
                      style: const TextStyle(
                        color: kTextSecondary,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: kSpaceMD),
                    const Icon(
                      Icons.local_gas_station,
                      size: 14,
                      color: Color(0xFFFF9800),
                    ),
                    const SizedBox(width: kSpaceXS),
                    Text(
                      '${item.fuelStops} ${item.fuelStops == 1 ? 'stop' : 'stops'}',
                      style: const TextStyle(
                        color: kTextSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                if (item.hasJeepHire) ...[
                  const SizedBox(height: kSpaceMD),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kSpaceMD,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(kRadiusFull),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('ðŸš', style: TextStyle(fontSize: 12)),
                        SizedBox(width: 6),
                        Text(
                          'Jeep Hire Available',
                          style: TextStyle(
                            color: Color(0xFF1565C0),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: kSpaceLG),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.accommodationDetail,
                        arguments: item,
                      );
                    },
                    child: const Text('View Details'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// â”€â”€ Accommodation image widget (CORS-safe) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _AccomImage extends StatelessWidget {
  final String imageUrl;
  final String parkName;
  const _AccomImage({required this.imageUrl, required this.parkName});

  static const _colors = [
    Color(0xFF1B5E20),
    Color(0xFF2E7D32),
    Color(0xFF388E3C),
    Color(0xFF1565C0),
    Color(0xFF4A148C),
    Color(0xFF4E342E),
  ];

  Color get _color => _colors[parkName.length % _colors.length];

  static const _icons = {
    'Yala': Icons.pets_rounded,
    'Wilpattu': Icons.forest_rounded,
    'Minneriya': Icons.water_rounded,
    'Udawalawe': Icons.grass_rounded,
    'Horton': Icons.landscape_rounded,
    'Bundala': Icons.water_rounded,
    'Sinharaja': Icons.park_rounded,
  };

  IconData get _icon {
    for (final key in _icons.keys) {
      if (parkName.contains(key)) return _icons[key]!;
    }
    return Icons.nature_rounded;
  }

  bool get _isAsset => imageUrl.startsWith('assets/');

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) return _placeholder();

    if (_isAsset) {
      return Image.asset(
        imageUrl,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }

    if (kIsWeb) return _placeholder();

    return Image.network(
      imageUrl,
      height: 180,
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (_, child, progress) => progress == null
          ? child
          : Container(
              height: 180,
              color: const Color(0xFFE8F5E9),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF2E7D32),
                  strokeWidth: 2,
                ),
              ),
            ),
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_color, _color.withValues(alpha: 0.7)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_icon, size: 52, color: Colors.white.withValues(alpha: 0.9)),
          const SizedBox(height: 8),
          Text(
            parkName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}


