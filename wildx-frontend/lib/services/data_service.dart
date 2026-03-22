import 'dart:convert';
import '../models/models.dart';
import 'package:wildx_frontend/core/config/app_config.dart';
import 'package:wildx_frontend/core/services/backend_service.dart';

class WildXData {
  static final WildXData _i = WildXData._();
  factory WildXData() => _i;
  WildXData._();

  // Featured Park
  Park get featuredPark => const Park(
    id: 'yala', name: 'Yala National Park',
    location: 'Southern Province',
    imageUrl: 'assets/images/NationalParkImages/YalaNationalPark.webp',
    description: "Sri Lanka's most visited national park, famous for leopards and elephants.",
    animalCount: 215, isFeatured: true,
  );

  UserStats get stats => const UserStats(sightings: 24, badges: 3, parks: 12);

  List<Park> get parks => [
    featuredPark,
    const Park(id: 'wilpattu', name: 'Wilpattu National Park',
        location: 'North Western Province',
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Leopard_sitting_2.jpg/1280px-Leopard_sitting_2.jpg',
        description: 'Largest national park.', animalCount: 180),
    const Park(id: 'minneriya', name: 'Minneriya National Park',
        location: 'North Central Province',
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg/1280px-Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg',
        description: 'Known for The Gathering.', animalCount: 160),
    const Park(id: 'udawalawe', name: 'Udawalawe National Park',
        location: 'Sabaragamuwa Province',
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg/1280px-Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg',
        description: 'Elephant sanctuary.', animalCount: 140),
  ];

  // Load recent sightings from backend, fallback to static
  Future<List<Sighting>> getRecentSightings() async {
    try {
      final res = await BackendService.instance.get(AppConfig.sightingsBase);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final list = data['sightings'] as List? ?? [];
        if (list.isNotEmpty) {
          return list.take(5).map((s) => Sighting(
            id: s['id']?.toString() ?? '',
            animalName: s['animal_type_name'] ?? 'Unknown',
            parkName: s['location_name'] ?? 'Sri Lanka',
            imageUrl: s['photo_url'] ?? 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Leopard_sitting_2.jpg/300px-Leopard_sitting_2.jpg',
            category: s['animal_category'] ?? 'Wildlife',
            date: DateTime.tryParse(s['sighting_time'] ?? '') ?? DateTime.now(),
          )).toList();
        }
      }
    } catch (_) {}
    return recentSightings;
  }

  List<Sighting> get recentSightings => [
    Sighting(id: 's1', animalName: 'Leopard', parkName: 'Yala NP',
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Leopard_sitting_2.jpg/300px-Leopard_sitting_2.jpg',
        category: 'Big Cats', date: DateTime(2025, 11, 15)),
    Sighting(id: 's2', animalName: 'Elephant', parkName: 'Yala NP',
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg/300px-Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg',
        category: 'Mammals', date: DateTime(2025, 11, 16)),
    Sighting(id: 's3', animalName: 'Sloth Bear', parkName: 'Yala NP',
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/ba/Sloth_bear_guwahati.jpg/300px-Sloth_bear_guwahati.jpg',
        category: 'Bears', date: DateTime(2025, 11, 17)),
    Sighting(id: 's4', animalName: 'Peacock', parkName: 'Minneriya NP',
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5d/Peacock_Plumage.jpg/300px-Peacock_Plumage.jpg',
        category: 'Birds', date: DateTime(2025, 11, 18)),
  ];

  List<GalleryItem> get gallery => [
    const GalleryItem(id: 'g1', title: 'Sri Lankan Leopard', category: 'Big Cats',
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Leopard_sitting_2.jpg/300px-Leopard_sitting_2.jpg'),
    const GalleryItem(id: 'g2', title: 'Wild Elephant', category: 'Mammals',
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg/300px-Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg'),
    const GalleryItem(id: 'g3', title: 'Indian Peacock', category: 'Birds',
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5d/Peacock_Plumage.jpg/300px-Peacock_Plumage.jpg'),
    const GalleryItem(id: 'g4', title: 'Sloth Bear', category: 'Bears',
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/ba/Sloth_bear_guwahati.jpg/300px-Sloth_bear_guwahati.jpg'),
  ];

  List<Accommodation> get accommodations => const [
    Accommodation(name: 'Yala Safari Camp', location: 'Yala, Southern Province',
        price: 'From LKR 15,000/night', distance: '12 km from Park Gate', rating: 4.8),
    Accommodation(name: 'Wilpattu Rest House', location: 'Wilpattu, North Western',
        price: 'From LKR 8,500/night', distance: '5 km from Park Gate', rating: 4.5),
    Accommodation(name: 'Minneriya Eco Lodge', location: 'Minneriya, North Central',
        price: 'From LKR 12,000/night', distance: '3 km from Park Gate', rating: 4.7),
    Accommodation(name: 'Udawalawe River Camp', location: 'Udawalawe, Sabaragamuwa',
        price: 'From LKR 10,500/night', distance: '8 km from Park Gate', rating: 4.6),
  ];
}
