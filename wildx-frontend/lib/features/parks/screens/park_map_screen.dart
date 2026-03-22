import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/national_park_model.dart';

class ParkMapScreen extends StatefulWidget {
  final NationalPark park;
  const ParkMapScreen({super.key, required this.park});

  @override
  State<ParkMapScreen> createState() => _ParkMapScreenState();
}

class _ParkMapScreenState extends State<ParkMapScreen> {
  static const _coords = {
    'Yala National Park':       [6.3728, 81.5212],
    'Udawalawe National Park':  [6.4739, 80.8997],
    'Wilpattu National Park':   [8.4567, 80.0167],
    'Minneriya National Park':  [8.0333, 80.9000],
    'Horton Plains':            [6.8020, 80.8038],
    'Bundala National Park':    [6.2000, 81.2500],
    'Sinharaja Forest Reserve': [6.4000, 80.4833],
    'Kaudulla National Park':   [8.1500, 80.9167],
  };

  List<double> get _latLng {
    final coords = _coords[widget.park.name];
    return coords ?? [7.8731, 80.7718];
  }

  double get _lat => _latLng[0];
  double get _lng => _latLng[1];

  // Open in Google Maps
  Future<void> _openGoogleMaps() async {
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$_lat,$_lng');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open Google Maps')),
        );
      }
    }
  }

  // Open in Google Maps Navigation
  Future<void> _openNavigation() async {
    final url = Uri.parse('google.navigation:q=$_lat,$_lng&mode=d');
    final fallback = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$_lat,$_lng');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else if (await canLaunchUrl(fallback)) {
      await launchUrl(fallback, mode: LaunchMode.externalApplication);
    }
  }

  void _copyCoords() {
    Clipboard.setData(ClipboardData(text: '$_lat, $_lng'));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(children: [
          Icon(Icons.check_circle, color: Colors.white, size: 16),
          SizedBox(width: 8),
          Text('Coordinates copied!'),
        ]),
        backgroundColor: const Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final park = widget.park;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        title: Text(park.name,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
        actions: [
          IconButton(
            icon: const Icon(Icons.map_rounded),
            tooltip: 'Open in Google Maps',
            onPressed: _openGoogleMaps,
          ),
        ],
      ),
      body: Column(children: [
        // ── Map Preview ──────────────────────────────────────
        GestureDetector(
          onTap: _openGoogleMaps,
          child: Container(
            height: 280,
            width: double.infinity,
            color: const Color(0xFFE8F5E9),
            child: Stack(children: [
              // Grid background
              CustomPaint(size: const Size(double.infinity, 280), painter: _GridPainter()),

              // Tap to open hint
              Positioned(
                top: 12, left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                  ),
                  child: const Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.touch_app_rounded, size: 13, color: Color(0xFF2E7D32)),
                    SizedBox(width: 4),
                    Text('Tap to open Google Maps',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF2E7D32))),
                  ]),
                ),
              ),

              // Center pin
              Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 8, offset: const Offset(0, 3))],
                    ),
                    child: Text(park.name,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                  ),
                  const SizedBox(height: 2),
                  const Icon(Icons.location_on_rounded, color: Color(0xFF2E7D32), size: 52),
                  Container(
                    width: 10, height: 4,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ]),
              ),

              // Coordinates badge
              Positioned(
                bottom: 10, right: 10,
                child: GestureDetector(
                  onTap: _copyCoords,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.copy_rounded, size: 11, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('$_lat, $_lng',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                    ]),
                  ),
                ),
              ),
            ]),
          ),
        ),

        // ── Action Buttons ───────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          child: Row(children: [
            Expanded(
              child: _ActionBtn(
                icon: Icons.map_rounded,
                label: 'Open Maps',
                color: const Color(0xFF2E7D32),
                onTap: _openGoogleMaps,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ActionBtn(
                icon: Icons.navigation_rounded,
                label: 'Navigate',
                color: const Color(0xFF1565C0),
                onTap: _openNavigation,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ActionBtn(
                icon: Icons.copy_rounded,
                label: 'Copy GPS',
                color: const Color(0xFF6A1B9A),
                onTap: _copyCoords,
              ),
            ),
          ]),
        ),

        // ── Park Info ────────────────────────────────────────
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(park.name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1A))),
              const SizedBox(height: 4),
              if (park.location != null)
                Row(children: [
                  const Icon(Icons.location_on_rounded, color: Colors.grey, size: 14),
                  const SizedBox(width: 4),
                  Text(park.location!, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                ]),
              const SizedBox(height: 14),

              // Info chips
              Wrap(spacing: 8, runSpacing: 8, children: [
                if (park.openingTime != null && park.closingTime != null)
                  _InfoChip(Icons.access_time_rounded,
                      '${park.openingTime!} – ${park.closingTime!}', Colors.teal),
                if (park.entryFee != null)
                  _InfoChip(Icons.payments_rounded,
                      'LKR ${park.entryFee!.toStringAsFixed(0)}', Colors.orange),
                if (park.bestVisitingSeason != null)
                  _InfoChip(Icons.wb_sunny_rounded,
                      park.bestVisitingSeason!, Colors.amber),
                if (park.sizeInHectares != null)
                  _InfoChip(Icons.straighten_rounded,
                      '${(park.sizeInHectares! / 100).toStringAsFixed(0)} km²', Colors.blue),
              ]),

              if (park.description != null) ...[
                const SizedBox(height: 16),
                Text(park.description!,
                    style: const TextStyle(fontSize: 14, color: Color(0xFF555555), height: 1.5)),
              ],

              // Animals
              if (park.animalTypes.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text('Wildlife', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 6, children: park.animalTypes
                    .map((a) => Chip(
                          label: Text(a, style: const TextStyle(fontSize: 12)),
                          backgroundColor: const Color(0xFFE8F5E9),
                          side: BorderSide.none,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ))
                    .toList()),
              ],

              // Rules
              if (park.rules.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text('Park Rules', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                ...park.rules.map((r) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Icon(Icons.info_outline_rounded, size: 14, color: Color(0xFF2E7D32)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(r.rule, style: const TextStyle(fontSize: 13, color: Color(0xFF444444)))),
                  ]),
                )),
              ],

              if (park.contactNumber != null) ...[
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => launchUrl(Uri.parse('tel:${park.contactNumber}')),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(children: [
                      const Icon(Icons.phone_rounded, color: Color(0xFF2E7D32), size: 20),
                      const SizedBox(width: 10),
                      Text(park.contactNumber!,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2E7D32))),
                    ]),
                  ),
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ]),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionBtn({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
      ]),
    ),
  );
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _InfoChip(this.icon, this.label, this.color);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 12, color: color),
      const SizedBox(width: 4),
      Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
    ]),
  );
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = const Color(0xFFB2DFDB)..strokeWidth = 0.5;
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
    final rp = Paint()..color = Colors.white..strokeWidth = 2;
    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), rp);
    canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height), rp);
  }
  @override bool shouldRepaint(_) => false;
}
