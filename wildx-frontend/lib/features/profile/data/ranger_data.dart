import '../models/ranger_model.dart';

final kSampleRanger = RangerModel(
  name: 'Safari Explorer',
  avatarUrl: null,
  memberSince: DateTime(2024, 11, 1),
  sightingsCount: 28,
  parksVisited: 7,
  photosCount: 142,
  xp: 450,
  currentLevel: WildXLevel.ranger,
  email: 'safari.explorer@wildx.app',
  location: 'Colombo, Sri Lanka',
  bio: 'Wildlife enthusiast & nature photographer. Yala is home.',
  topParks: const [
    ParkVisit(parkName: 'Yala National Park', visitCount: 12),
    ParkVisit(parkName: 'Udawalawe',          visitCount: 8),
    ParkVisit(parkName: 'Wilpattu',           visitCount: 5),
  ],
  badges: const [
    BadgeModel(
      title: 'First Sighting',
      iconAsset: 'assets/icons/badge_first_sighting.png',
      earned: true,
    ),
    BadgeModel(
      title: '10 Sightings',
      iconAsset: 'assets/icons/badge_trophy.png',
      earned: true,
    ),
    BadgeModel(
      title: 'Photo Master',
      iconAsset: 'assets/icons/badge_photo.png',
      earned: true,
    ),
    BadgeModel(
      title: '5 Parks Visited',
      iconAsset: 'assets/icons/badge_park.png',
      earned: true,
    ),
    BadgeModel(
      title: 'Night Safari',
      iconAsset: 'assets/icons/badge_night.png',
      earned: false,
    ),
    BadgeModel(
      title: 'Leopard Spotter',
      iconAsset: 'assets/icons/badge_leopard.png',
      earned: false,
    ),
  ],
);
