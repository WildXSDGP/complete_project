import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/data_service.dart';
import '../widgets/common_widgets.dart';
import '../widgets/feature_grid.dart';
import '../widgets/bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 1;

  void _snack(String msg, {Color color = AppColors.primary}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: color,
      duration: const Duration(seconds: 1),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  List<FeatureItem> get _features => [
        FeatureItem(
          label: 'Parks',
          icon: Icons.park_rounded,
          color: AppColors.green,
          bgColor: const Color(0xFFDCFCE7),
          onTap: () => _snack('Parks'),
        ),
        FeatureItem(
          label: 'Accommodation',
          icon: Icons.hotel_rounded,
          color: AppColors.blue,
          bgColor: const Color(0xFFDBEAFE),
          onTap: () => _snack('Accommodation'),
        ),
        FeatureItem(
          label: 'Sighting',
          icon: Icons.visibility_rounded,
          color: AppColors.teal,
          bgColor: const Color(0xFFCCFBF1),
          onTap: () => _snack('Sighting'),
        ),
        FeatureItem(
          label: 'SOS',
          icon: Icons.warning_amber_rounded,
          color: AppColors.red,
          bgColor: const Color(0xFFFEE2E2),
          onTap: () => _snack('SOS', color: AppColors.red),
        ),
        FeatureItem(
          label: 'Wildlife\nGallery',
          icon: Icons.photo_library_rounded,
          color: AppColors.purple,
          bgColor: const Color(0xFFEDE9FE),
          onTap: () => _snack('Wildlife Gallery'),
        ),
        FeatureItem(
          label: 'Dashboard',
          icon: Icons.dashboard_rounded,
          color: AppColors.orange,
          bgColor: const Color(0xFFFFEDD5),
          onTap: () => _snack('Dashboard'),
        ),
      ];

  Widget _homeBody() {
    final data = WildXData();
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        FeaturedParkCard(
          park: data.featuredPark,
          onExplore: () => _snack('Exploring ${data.featuredPark.name}…'),
        ),
        const SizedBox(height: 14),
        StatsRow(stats: data.stats),
        const SizedBox(height: 22),
        const Text('Features',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        const SizedBox(height: 12),
        FeatureGrid(items: _features),
        const SizedBox(height: 22),
        SectionHeader(
          title: 'Recent Sightings',
          actionLabel: 'View All',
          onAction: () => _snack('Viewing all sightings…'),
        ),
        const SizedBox(height: 12),
        ...data.recentSightings.map((s) => SightingCard(
              sighting: s,
              onTap: () => _snack('${s.animalName} at ${s.parkName}'),
            )),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _homeBody(),
      bottomNavigationBar: WildXBottomNav(
        selectedIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }
}
