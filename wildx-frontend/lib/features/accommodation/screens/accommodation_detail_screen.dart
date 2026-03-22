import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../app_colors.dart';
import '../models/accommodation.dart';
import '../routes/app_routes.dart';
import '../widgets/app_badge.dart';

class AccommodationDetailScreen extends StatefulWidget {
  const AccommodationDetailScreen({super.key});

  @override
  State<AccommodationDetailScreen> createState() =>
      _AccommodationDetailScreenState();
}

class _AccommodationDetailScreenState extends State<AccommodationDetailScreen> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item =
        ModalRoute.of(context)!.settings.arguments as Accommodation;

    return Scaffold(
      backgroundColor: kBackground,
      bottomNavigationBar: _buildStickyBookBar(context, item),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageGallery(context, item),
            _buildContentCard(item),
          ],
        ),
      ),
    );
  }

  // â”€â”€ Image gallery with PageView, dots, back button, badges â”€â”€
  Widget _buildImageGallery(BuildContext context, Accommodation item) {
    final colors = [
      const Color(0xFF1B5E20),
      const Color(0xFF2E7D32),
      const Color(0xFF1565C0),
      const Color(0xFF4A148C),
    ];
    final bgColor = colors[item.parkName.length % colors.length];

    return Stack(
      children: [
        SizedBox(
          height: 300,
          child: item.imageUrls.isEmpty
              ? _buildImagePlaceholder(bgColor, item.parkName)
              : PageView.builder(
                  controller: _pageController,
                  itemCount: item.imageUrls.length,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemBuilder: (context, index) => _buildGalleryImage(
                    item.imageUrls[index],
                    bgColor,
                    item.parkName,
                  ),
                ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.65),
                ],
                stops: const [0.4, 1.0],
              ),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + kSpaceSM,
          left: kSpaceLG,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(kRadiusMD),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + kSpaceSM,
          right: kSpaceLG,
          child: Row(
            children: [
              if (item.isEcoFriendly)
                const AppBadge(label: 'Eco', color: kGreen),
              if (item.isEcoFriendly && item.isFamilyFriendly)
                const SizedBox(width: 6),
              if (item.isFamilyFriendly)
                const AppBadge(label: 'Family', color: kGreenLight),
            ],
          ),
        ),
        Positioned(
          bottom: kSpaceHuge,
          left: kSpaceXL,
          right: kSpaceXL,
          child: Text(
            item.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
              shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
            ),
          ),
        ),
        Positioned(
          bottom: kSpaceMD,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              item.imageUrls.isEmpty ? 1 : item.imageUrls.length,
              (index) {
                final isActive = index == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: isActive ? 22 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGalleryImage(String imageUrl, Color bgColor, String parkName) {
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, __, ___) => _buildImagePlaceholder(bgColor, parkName),
      );
    }

    if (kIsWeb) {
      return _buildImagePlaceholder(bgColor, parkName);
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: (_, __, ___) => _buildImagePlaceholder(bgColor, parkName),
    );
  }

  Widget _buildImagePlaceholder(Color bgColor, String parkName) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [bgColor, bgColor.withValues(alpha: 0.7)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.landscape_rounded, size: 80, color: Colors.white70),
          const SizedBox(height: 12),
          Text(
            parkName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
  // â”€â”€ Main content card â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildContentCard(Accommodation item) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(kSpaceLG),
      padding: const EdgeInsets.all(kSpaceXL),
      decoration: BoxDecoration(
        color: kCardBackground,
        borderRadius: BorderRadius.circular(kRadiusXL),
        boxShadow: const [
          BoxShadow(
            color: kShadowColor,
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPriceRatingRow(item),
          const SizedBox(height: kSpaceLG),
          _buildParkRow(item),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: kSpaceXL),
            child: Divider(color: kDividerColor),
          ),
          _buildDescriptionSection(item),
          const SizedBox(height: kSpaceSM),
        ],
      ),
    );
  }

  // â”€â”€ Price + Rating row â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildPriceRatingRow(Accommodation item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'LKR ${item.pricePerNight.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: kGreen,
                letterSpacing: -0.3,
              ),
            ),
            const Text(
              'per night',
              style: TextStyle(fontSize: 12, color: kTextHint),
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: kAmberSoft,
            borderRadius: BorderRadius.circular(kRadiusMD),
            border: Border.all(color: kAmber.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.star_rounded, color: kAmber, size: 18),
              const SizedBox(width: kSpaceXS),
              Text(
                item.rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: kTextPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // â”€â”€ Park name row â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildParkRow(Accommodation item) {
    return Row(
      children: [
        const Icon(Icons.park_outlined, size: 16, color: kGreenLight),
        const SizedBox(width: kSpaceSM),
        Text(
          item.parkName,
          style: const TextStyle(
            fontSize: 14,
            color: kTextSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: kSpaceLG),
        const Icon(Icons.location_on_outlined, size: 16, color: kEarthLight),
        const SizedBox(width: kSpaceXS),
        Text(
          '${item.distanceFromGate} km from gate',
          style: const TextStyle(fontSize: 14, color: kTextSecondary),
        ),
      ],
    );
  }

  // â”€â”€ Description section â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildDescriptionSection(Accommodation item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: kGreen,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: kSpaceMD),
        Text(
          item.description,
          style: const TextStyle(
            fontSize: 14,
            color: kTextSecondary,
            height: 1.7,
          ),
        ),
      ],
    );
  }

  // â”€â”€ Sticky bottom booking bar â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildStickyBookBar(BuildContext context, Accommodation item) {
    return Container(
      decoration: const BoxDecoration(
        color: kCardBackground,
        boxShadow: [
          BoxShadow(
            color: kShadowColor,
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: kSpaceXL, vertical: kSpaceLG),
          child: Row(
            children: [
              // Price summary
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LKR ${item.pricePerNight.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kGreen,
                    ),
                  ),
                  const Text(
                    'per night',
                    style: TextStyle(fontSize: 11, color: kTextHint),
                  ),
                ],
              ),
              const SizedBox(width: kSpaceLG),
              // Book Now button
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.booking,
                      arguments: item,
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_month_outlined, size: 18),
                      SizedBox(width: kSpaceSM),
                      Text('Book Now'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}


