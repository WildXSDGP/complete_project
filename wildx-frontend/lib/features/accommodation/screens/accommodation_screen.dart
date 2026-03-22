import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../services/accommodation_service.dart';
import '../models/accommodation.dart';
import '../widgets/accommodation_card.dart';
import '../widgets/bar_button.dart';

class AccommodationScreen extends StatefulWidget {
  const AccommodationScreen({super.key});

  @override
  State<AccommodationScreen> createState() => _AccommodationScreenState();
}

class _AccommodationScreenState extends State<AccommodationScreen> {
  SortOption _selectedSort = SortOption.topRated;

  double _maxPrice = 15000;
  double _maxDistance = 20;
  bool _ecoOnly = false;
  bool _familyOnly = false;

  List<Accommodation> _accommodations = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAccommodations();
  }

  Future<void> _loadAccommodations() async {
    setState(() => _isLoading = true);
    // Always use local data first (instant, no network needed)
    final localData = _hardcodedAccommodations();
    setState(() { _accommodations = localData; _isLoading = false; _errorMessage = null; });

    // Try backend in background
    try {
      final data = await AccommodationService.getAccommodations()
          .timeout(const Duration(seconds: 5));
      if (data.isNotEmpty) {
        final list = data
            .map((e) => Accommodation.fromJson(e as Map<String, dynamic>))
            .toList();
        if (mounted) setState(() => _accommodations = list);
      }
    } catch (_) {}
  }

  List<Accommodation> _hardcodedAccommodations() => [
    const Accommodation(
      id: 'acc_001', name: 'Green Valley Eco-Lodge',
      parkName: 'Yala National Park',
      pricePerNight: 9500, distanceFromGate: 4.0,
      travelTime: '20 mins', fuelStops: 1, rating: 4.9,
      isEcoFriendly: true, isFamilyFriendly: true, hasJeepHire: true,
      imageUrls: ['assets/images/acc_green_valley.jpg'],
      description: 'Serene eco-lodge with panoramic wilderness views.',
    ),
    const Accommodation(
      id: 'acc_002', name: 'Yala Safari Lodge',
      parkName: 'Yala National Park',
      pricePerNight: 8500, distanceFromGate: 2.5,
      travelTime: '12 mins', fuelStops: 1, rating: 4.7,
      isEcoFriendly: true, isFamilyFriendly: false, hasJeepHire: false,
      imageUrls: ['assets/images/acc_yala.jpg'],
      description: 'Intimate safari camp near the main gate.',
    ),
    const Accommodation(
      id: 'acc_003', name: 'Wilpattu Forest Camp',
      parkName: 'Wilpattu National Park',
      pricePerNight: 6200, distanceFromGate: 1.2,
      travelTime: '10 mins', fuelStops: 0, rating: 4.5,
      isEcoFriendly: false, isFamilyFriendly: false, hasJeepHire: false,
      imageUrls: ['assets/images/acc_wilpattu.jpg'],
      description: 'Rustic camp deep inside Wilpattu.',
    ),
    const Accommodation(
      id: 'acc_004', name: 'Minneriya Elephant Lodge',
      parkName: 'Minneriya National Park',
      pricePerNight: 7800, distanceFromGate: 3.5,
      travelTime: '15 mins', fuelStops: 1, rating: 4.6,
      isEcoFriendly: true, isFamilyFriendly: true, hasJeepHire: true,
      imageUrls: ['assets/images/park_minneriya.jpg'],
      description: 'Experience The Gathering up close.',
    ),
    const Accommodation(
      id: 'acc_005', name: 'Udawalawe River Camp',
      parkName: 'Udawalawe National Park',
      pricePerNight: 5900, distanceFromGate: 2.0,
      travelTime: '10 mins', fuelStops: 0, rating: 4.4,
      isEcoFriendly: true, isFamilyFriendly: true, hasJeepHire: false,
      imageUrls: ['assets/images/acc_udawalawe.jfif'],
      description: 'Riverside camp with elephant herds nearby.',
    ),
    const Accommodation(
      id: 'acc_006', name: 'Horton Mist Retreat',
      parkName: 'Horton Plains',
      pricePerNight: 12000, distanceFromGate: 5.0,
      travelTime: '25 mins', fuelStops: 2, rating: 4.8,
      isEcoFriendly: true, isFamilyFriendly: false, hasJeepHire: false,
      imageUrls: ['assets/images/acc_green_valley.jpg'],
      description: 'Cozy highland retreat with misty mornings.',
    ),
  ];
  List<Accommodation> get _filtered {
    var list = _accommodations
        .where(_matchesPrice)
        .where(_matchesDistance)
        .where(_matchesEco)
        .where(_matchesFamily)
        .toList();

    switch (_selectedSort) {
      case SortOption.topRated:
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortOption.closest:
        list.sort((a, b) => a.distanceFromGate.compareTo(b.distanceFromGate));
        break;
      case SortOption.budget:
        list.sort((a, b) => a.pricePerNight.compareTo(b.pricePerNight));
        break;
      case SortOption.familyFriendly:
        list.sort(
          (a, b) => (b.isFamilyFriendly ? 1 : 0).compareTo(
            a.isFamilyFriendly ? 1 : 0,
          ),
        );
        break;
    }
    return list;
  }

  bool _matchesPrice(Accommodation a) => a.pricePerNight <= _maxPrice;
  bool _matchesDistance(Accommodation a) => a.distanceFromGate <= _maxDistance;
  bool _matchesEco(Accommodation a) => !_ecoOnly || a.isEcoFriendly;
  bool _matchesFamily(Accommodation a) => !_familyOnly || a.isFamilyFriendly;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: Column(
        children: [
          _buildHeader(context),
          _buildFilterSortBar(),
          _buildSortTabs(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: kGreen))
                : _errorMessage != null && _accommodations.isEmpty
                ? Center(child: ElevatedButton.icon(
                    onPressed: _loadAccommodations,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ))
                : _filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 48,
                          color: kGreen.withValues(alpha: 0.4),
                        ),
                        const SizedBox(height: kSpaceMD),
                        const Text(
                          'No accommodations found',
                          style: TextStyle(color: kTextSecondary, fontSize: 15),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      kSpaceLG,
                      kSpaceSM,
                      kSpaceLG,
                      kSpaceXXL,
                    ),
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) =>
                        AccommodationCard(item: _filtered[index]),
                  ),
          ),
        ],
      ),
    );
  }

  // â”€â”€ Green gradient header â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [kGreenDark, kGreen, kGreenLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + kSpaceMD,
        left: kSpaceXL,
        right: kSpaceXL,
        bottom: kSpaceXL,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(kRadiusMD),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: kSpaceLG),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Accommodation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: kSpaceXS),
              Text(
                'Find your perfect stay near the parks',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // â”€â”€ Filter + Sort bar â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildFilterSortBar() {
    return Container(
      color: kCardBackground,
      padding: const EdgeInsets.symmetric(
        horizontal: kSpaceLG,
        vertical: kSpaceMD,
      ),
      child: Row(
        children: [
          BarButton(
            icon: Icons.tune,
            label: 'Filters',
            onTap: _showFilterSheet,
          ),
          const SizedBox(width: kSpaceMD),
          BarButton(icon: Icons.sort, label: 'Sort', onTap: _showSortSheet),
        ],
      ),
    );
  }

  // â”€â”€ Sort tabs â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildSortTabs() {
    final tabs = [
      (SortOption.topRated, 'Top Rated'),
      (SortOption.closest, 'Closest'),
      (SortOption.budget, 'Budget'),
    ];
    return Container(
      color: kCardBackground,
      padding: const EdgeInsets.only(
        left: kSpaceLG,
        right: kSpaceLG,
        bottom: kSpaceLG,
      ),
      child: Row(
        children: tabs.map((t) {
          final selected = _selectedSort == t.$1;
          return Padding(
            padding: const EdgeInsets.only(right: kSpaceSM),
            child: GestureDetector(
              onTap: () => setState(() => _selectedSort = t.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: selected ? kGreen : kBackground,
                  borderRadius: BorderRadius.circular(kRadiusFull),
                  border: selected ? null : Border.all(color: kDividerColor),
                ),
                child: Text(
                  t.$2,
                  style: TextStyle(
                    color: selected ? Colors.white : kTextSecondary,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // â”€â”€ Filter bottom sheet â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(kRadiusXL)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => Padding(
          padding: const EdgeInsets.all(kSpaceXL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: kDividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: kSpaceXL),
              Text(
                'Filters',
                style: Theme.of(
                  ctx,
                ).textTheme.headlineSmall?.copyWith(color: kGreen),
              ),
              const SizedBox(height: kSpaceXL),
              Text(
                'Max Price: LKR ${_maxPrice.toInt()}',
                style: const TextStyle(
                  color: kTextSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Slider(
                value: _maxPrice,
                min: 3000,
                max: 20000,
                divisions: 17,
                activeColor: kGreen,
                inactiveColor: kGreenSoft,
                onChanged: (v) => setModal(() => _maxPrice = v),
              ),
              Text(
                'Max Distance: ${_maxDistance.toInt()} km',
                style: const TextStyle(
                  color: kTextSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Slider(
                value: _maxDistance,
                min: 1,
                max: 30,
                divisions: 29,
                activeColor: kGreen,
                inactiveColor: kGreenSoft,
                onChanged: (v) => setModal(() => _maxDistance = v),
              ),
              SwitchListTile(
                title: const Text(
                  'Eco-Friendly Only',
                  style: TextStyle(fontSize: 14),
                ),
                value: _ecoOnly,
                activeTrackColor: kGreenLight,
                thumbColor: WidgetStateProperty.resolveWith(
                  (states) =>
                      states.contains(WidgetState.selected) ? kGreen : null,
                ),
                onChanged: (v) => setModal(() => _ecoOnly = v),
              ),
              SwitchListTile(
                title: const Text(
                  'Family Friendly Only',
                  style: TextStyle(fontSize: 14),
                ),
                value: _familyOnly,
                activeTrackColor: kGreenLight,
                thumbColor: WidgetStateProperty.resolveWith(
                  (states) =>
                      states.contains(WidgetState.selected) ? kGreen : null,
                ),
                onChanged: (v) => setModal(() => _familyOnly = v),
              ),
              const SizedBox(height: kSpaceLG),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {});
                    Navigator.pop(ctx);
                  },
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // â”€â”€ Sort bottom sheet â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  void _showSortSheet() {
    final options = [
      (SortOption.topRated, Icons.star_rounded, 'Top Rated'),
      (SortOption.closest, Icons.near_me_rounded, 'Closest'),
      (SortOption.budget, Icons.savings_outlined, 'Budget Friendly'),
      (
        SortOption.familyFriendly,
        Icons.family_restroom_rounded,
        'Family Friendly',
      ),
    ];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(kRadiusXL)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(kSpaceXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: kDividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: kSpaceXL),
            Text(
              'Sort By',
              style: Theme.of(
                ctx,
              ).textTheme.headlineSmall?.copyWith(color: kGreen),
            ),
            const SizedBox(height: kSpaceMD),
            ...options.map(
              (o) => ListTile(
                leading: Icon(
                  o.$2,
                  color: _selectedSort == o.$1 ? kGreen : kTextHint,
                ),
                title: Text(
                  o.$3,
                  style: TextStyle(
                    fontWeight: _selectedSort == o.$1
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
                trailing: _selectedSort == o.$1
                    ? const Icon(Icons.check_circle_rounded, color: kGreen)
                    : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kRadiusMD),
                ),
                onTap: () {
                  setState(() => _selectedSort = o.$1);
                  Navigator.pop(ctx);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


