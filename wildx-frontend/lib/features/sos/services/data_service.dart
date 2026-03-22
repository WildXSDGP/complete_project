import '../models/models.dart';

class WildXData {
  static final WildXData _i = WildXData._();
  factory WildXData() => _i;
  WildXData._();

  // ── Featured Park ──────────────────────────────────────────────
  Park get featuredPark => const Park(
        id: 'yala', name: 'Yala National Park',
        location: 'Southern Province',
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg/1280px-Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg',
        description: "Sri Lanka's most visited national park.",
        animalCount: 215, isFeatured: true,
      );

  // ── Stats ──────────────────────────────────────────────────────
  UserStats get stats => const UserStats(sightings: 24, badges: 3, parks: 12);

  // ── Parks ──────────────────────────────────────────────────────
  List<Park> get parks => [
        featuredPark,
        const Park(id: 'wilpattu', name: 'Wilpattu National Park',
            location: 'North Western Province',
            imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Leopard_sitting_2.jpg/1280px-Leopard_sitting_2.jpg',
            description: 'Largest national park in Sri Lanka.', animalCount: 180),
        const Park(id: 'minneriya', name: 'Minneriya National Park',
            location: 'North Central Province',
            imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg/1280px-Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg',
            description: 'Known for The Gathering.', animalCount: 160),
        const Park(id: 'udawalawe', name: 'Udawalawe National Park',
            location: 'Sabaragamuwa Province',
            imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg/1280px-Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg',
            description: 'Elephant sanctuary.', animalCount: 140),
      ];

  // ── Recent Sightings ───────────────────────────────────────────
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

  // ── Gallery ────────────────────────────────────────────────────
  List<GalleryItem> get gallery => [
        const GalleryItem(id: 'g1', title: 'Sri Lankan Leopard', category: 'Big Cats',
            imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Leopard_sitting_2.jpg/300px-Leopard_sitting_2.jpg'),
        const GalleryItem(id: 'g2', title: 'Wild Elephant', category: 'Mammals',
            imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg/300px-Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg'),
        const GalleryItem(id: 'g3', title: 'Indian Peacock', category: 'Birds',
            imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5d/Peacock_Plumage.jpg/300px-Peacock_Plumage.jpg'),
        const GalleryItem(id: 'g4', title: 'Sloth Bear', category: 'Bears',
            imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/ba/Sloth_bear_guwahati.jpg/300px-Sloth_bear_guwahati.jpg'),
        const GalleryItem(id: 'g5', title: 'Wild Elephant Herd', category: 'Mammals',
            imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg/300px-Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg'),
        const GalleryItem(id: 'g6', title: 'Leopard at Rest', category: 'Big Cats',
            imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Leopard_sitting_2.jpg/300px-Leopard_sitting_2.jpg'),
      ];

  // ── Accommodations ─────────────────────────────────────────────
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
