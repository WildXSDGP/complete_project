enum SortOption { topRated, closest, budget, familyFriendly }

class Accommodation {
  final String id;
  final String name;
  final String parkName;
  final double pricePerNight;
  final double distanceFromGate;
  final String travelTime;
  final int fuelStops;
  final double rating;
  final bool isEcoFriendly;
  final bool isFamilyFriendly;
  final bool hasJeepHire;
  final List<String> imageUrls;
  final String description;

  String get imageUrl => imageUrls.isNotEmpty ? imageUrls.first : '';

  const Accommodation({
    required this.id,
    required this.name,
    required this.parkName,
    required this.pricePerNight,
    required this.distanceFromGate,
    required this.travelTime,
    required this.fuelStops,
    required this.rating,
    required this.isEcoFriendly,
    required this.isFamilyFriendly,
    required this.hasJeepHire,
    required this.imageUrls,
    required this.description,
  });

  static List<String> _localImageUrlsFor({
    required String name,
    required String parkName,
  }) {
    final normalizedName = name.toLowerCase();
    final normalizedPark = parkName.toLowerCase();

    if (normalizedName.contains('green valley')) {
      return const ['assets/images/acc_green_valley.jpg'];
    }
    if (normalizedName.contains('yala safari')) {
      return const ['assets/images/acc_yala.jpg'];
    }
    if (normalizedName.contains('wilpattu')) {
      return const ['assets/images/acc_wilpattu.jpg'];
    }
    if (normalizedName.contains('minneriya') ||
        normalizedPark.contains('minneriya')) {
      return const ['assets/images/park_minneriya.jpg'];
    }
    if (normalizedName.contains('udawalawe') ||
        normalizedName.contains('udawalawa') ||
        normalizedPark.contains('udawalawe') ||
        normalizedPark.contains('udawalawa')) {
      return const ['assets/images/acc_udawalawe.jfif'];
    }
    if (normalizedName.contains('horton') || normalizedPark.contains('horton')) {
      return const ['assets/images/acc_green_valley.jpg'];
    }

    return const [];
  }

  factory Accommodation.fromJson(Map<String, dynamic> json) {
    final name = json['name'] ?? '';
    final parkName = json['parkName'] ?? '';
    final remoteImageUrls = List<String>.from(json['imageUrls'] ?? []);
    final localImageUrls = _localImageUrlsFor(name: name, parkName: parkName);

    return Accommodation(
      id: json['id']?.toString() ?? '',
      name: name,
      parkName: parkName,
      pricePerNight: (json['pricePerNight'] ?? 0).toDouble(),
      distanceFromGate: (json['distanceFromGate'] ?? 0).toDouble(),
      travelTime: json['travelTime'] ?? '',
      fuelStops: json['fuelStops'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      isEcoFriendly: json['isEcoFriendly'] ?? false,
      isFamilyFriendly: json['isFamilyFriendly'] ?? false,
      hasJeepHire: json['hasJeepHire'] ?? false,
      imageUrls: localImageUrls.isNotEmpty ? localImageUrls : remoteImageUrls,
      description: json['description'] ?? '',
    );
  }
}
