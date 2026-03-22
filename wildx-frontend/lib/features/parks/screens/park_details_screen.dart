import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/national_park_model.dart';
import '../widgets/rule_item.dart';
import 'park_map_screen.dart';

class ParkDetailsScreen extends StatelessWidget {
  final NationalPark park;
  const ParkDetailsScreen({super.key, required this.park});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _ParkSliverAppBar(park: park),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ParkMapScreen(park: park)),
                      ),
                      icon: const Icon(Icons.map_rounded),
                      label: const Text('View on Map'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (park.description != null) ...[
                    const _SectionTitle(title: 'About'),
                    const SizedBox(height: 8),
                    Text(
                      park.description!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF555555),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  const _SectionTitle(title: 'Park Info'),
                  const SizedBox(height: 8),
                  if (park.location != null)
                    _InfoRow(
                      icon: Icons.location_on,
                      label: 'Location',
                      value: park.location!,
                    ),
                  if (park.openingTime != null && park.closingTime != null)
                    _InfoRow(
                      icon: Icons.access_time,
                      label: 'Timing',
                      value: '${park.openingTime} - ${park.closingTime}',
                    ),
                  if (park.entryFee != null)
                    _InfoRow(
                      icon: Icons.monetization_on,
                      label: 'Entry Fee',
                      value: 'LKR ${park.entryFee!.toStringAsFixed(0)}',
                    ),
                  if (park.sizeInHectares != null)
                    _InfoRow(
                      icon: Icons.straighten,
                      label: 'Park Size',
                      value: '${park.sizeInHectares!.toStringAsFixed(0)} hectares',
                    ),
                  if (park.bestVisitingSeason != null)
                    _InfoRow(
                      icon: Icons.wb_sunny,
                      label: 'Best Season',
                      value: park.bestVisitingSeason!,
                    ),
                  if (park.contactNumber != null)
                    GestureDetector(
                      onTap: () => launchUrl(Uri.parse('tel:${park.contactNumber}')),
                      child: _InfoRow(
                        icon: Icons.phone,
                        label: 'Contact',
                        value: park.contactNumber!,
                        isLink: true,
                      ),
                    ),
                  if (park.email != null)
                    GestureDetector(
                      onTap: () => launchUrl(Uri.parse('mailto:${park.email}')),
                      child: _InfoRow(
                        icon: Icons.email,
                        label: 'Email',
                        value: park.email!,
                        isLink: true,
                      ),
                    ),
                  if (park.animalTypes.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const _SectionTitle(title: 'Wildlife'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: park.animalTypes
                          .map(
                            (animal) => Chip(
                              label: Text(
                                animal,
                                style: const TextStyle(fontSize: 12),
                              ),
                              backgroundColor: const Color(0xFFE8F5E9),
                              side: BorderSide.none,
                            ),
                          )
                          .toList(),
                    ),
                  ],
                  if (park.rules.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const _SectionTitle(title: 'Rules & Regulations'),
                    const SizedBox(height: 8),
                    ...park.rulesAndRegulations
                        .map((rule) => RuleItem(rule: rule)),
                  ],
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ParkSliverAppBar extends StatelessWidget {
  final NationalPark park;
  const _ParkSliverAppBar({required this.park});

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

  @override
  Widget build(BuildContext context) {
    final assetPath = _assetForPark(park.name);

    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          park.name,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        background: assetPath != null
            ? Image.asset(
                assetPath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _networkOrFallback(),
              )
            : _networkOrFallback(),
      ),
    );
  }

  Widget _networkOrFallback() {
    if (park.imageUrl != null && park.imageUrl!.isNotEmpty) {
      return Image.network(
        park.imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: const Color(0xFF2E7D32),
          child: const Icon(Icons.park, size: 80, color: Colors.white38),
        ),
      );
    }
    return Container(color: const Color(0xFF2E7D32));
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) => Text(
        title,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
      );
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLink;
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLink = false,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: const Color(0xFF2E7D32)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isLink
                          ? const Color(0xFF1565C0)
                          : const Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}


