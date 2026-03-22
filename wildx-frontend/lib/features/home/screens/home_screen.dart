import 'package:flutter/material.dart';

import '../../../services/data_service.dart';
import '../../../theme/app_colors.dart';
import '../../accommodation/screens/accommodation_screen.dart';
import '../../gallery/screens/wildlife_gallery_screen.dart';
import '../../parks/screens/park_screen.dart';
import '../../settings/screens/notifications_screen.dart';
import '../../sightings/screens/report_sighting_screen1.dart';
import '../../sos/screens/emergency_sos_screen.dart';
import '../widgets/common_widgets.dart';
import '../widgets/feature_grid.dart';
import 'main_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _snack(String msg, {Color color = AppColors.primary}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  List<FeatureItem> get _features => [
        FeatureItem(
          label: 'Parks',
          icon: Icons.park_rounded,
          color: AppColors.green,
          bgColor: const Color(0xFFDCFCE7),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ParkSearchScreen()),
          ),
        ),
        FeatureItem(
          label: 'Accommodation',
          icon: Icons.hotel_rounded,
          color: AppColors.blue,
          bgColor: const Color(0xFFDBEAFE),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AccommodationScreen()),
          ),
        ),
        FeatureItem(
          label: 'Sighting',
          icon: Icons.visibility_rounded,
          color: AppColors.teal,
          bgColor: const Color(0xFFCCFBF1),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ReportSightingScreen()),
          ),
        ),
        FeatureItem(
          label: 'SOS',
          icon: Icons.warning_amber_rounded,
          color: AppColors.red,
          bgColor: const Color(0xFFFEE2E2),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EmergencySOSScreen()),
          ),
        ),
        FeatureItem(
          label: 'Wildlife\nGallery',
          icon: Icons.photo_library_rounded,
          color: AppColors.purple,
          bgColor: const Color(0xFFEDE9FE),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const WildlifeGalleryScreen()),
          ),
        ),
        FeatureItem(
          label: 'Dashboard',
          icon: Icons.dashboard_rounded,
          color: AppColors.amber,
          bgColor: const Color(0xFFFEF3C7),
          onTap: () => MainScreen.jumpTo(context, 0),
        ),
      ];

  Widget _homeBody() {
    final data = WildXData();
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FeaturedParkCard(
            park: data.featuredPark,
            onExplore: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ParkSearchScreen()),
            ),
          ),
          const SizedBox(height: 14),
          StatsRow(stats: data.stats),
          const SizedBox(height: 22),
          const Text(
            'Features',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          FeatureGrid(items: _features),
          const SizedBox(height: 22),
          SectionHeader(
            title: 'Recent Sightings',
            actionLabel: 'View All',
            onAction: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ReportSightingScreen()),
            ),
          ),
          const SizedBox(height: 12),
          ...data.recentSightings.map(
            (sighting) => SightingCard(
              sighting: sighting,
              onTap: () => _snack(
                '${sighting.animalName} at ${sighting.parkName}',
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'WildX',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(
                  Icons.notifications_rounded,
                  color: Colors.white,
                  size: 26,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const NotificationsScreen(),
              ),
            ),
          ),
        ],
      ),
      body: _homeBody(),
    );
  }
}
