enum WildXLevel { explorer, ranger, guardian }

class BadgeModel {
  final String title;
  final String iconAsset;
  final bool earned;

  const BadgeModel({
    required this.title,
    required this.iconAsset,
    this.earned = true,
  });
}

class ParkVisit {
  final String parkName;
  final int visitCount;

  const ParkVisit({required this.parkName, required this.visitCount});
}

class RangerModel {
  final String name;
  final String? avatarUrl;
  final DateTime memberSince;
  final int sightingsCount;
  final int parksVisited;
  final int photosCount;
  final int xp;
  final WildXLevel currentLevel;
  final List<BadgeModel> badges;
  final List<ParkVisit> topParks;
  final String? email;
  final String? location;
  final String? bio;

  const RangerModel({
    required this.name,
    this.avatarUrl,
    required this.memberSince,
    required this.sightingsCount,
    required this.parksVisited,
    required this.photosCount,
    required this.xp,
    required this.currentLevel,
    required this.badges,
    required this.topParks,
    this.email,
    this.location,
    this.bio,
  });

  RangerModel copyWith({
    String? name,
    String? avatarUrl,
    DateTime? memberSince,
    int? sightingsCount,
    int? parksVisited,
    int? photosCount,
    int? xp,
    WildXLevel? currentLevel,
    List<BadgeModel>? badges,
    List<ParkVisit>? topParks,
    String? email,
    String? location,
    String? bio,
  }) {
    return RangerModel(
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      memberSince: memberSince ?? this.memberSince,
      sightingsCount: sightingsCount ?? this.sightingsCount,
      parksVisited: parksVisited ?? this.parksVisited,
      photosCount: photosCount ?? this.photosCount,
      xp: xp ?? this.xp,
      currentLevel: currentLevel ?? this.currentLevel,
      badges: badges ?? this.badges,
      topParks: topParks ?? this.topParks,
      email: email ?? this.email,
      location: location ?? this.location,
      bio: bio ?? this.bio,
    );
  }

  int get xpForCurrentLevel {
    switch (currentLevel) {
      case WildXLevel.explorer:  return 0;
      case WildXLevel.ranger:    return 250;
      case WildXLevel.guardian:  return 700;
    }
  }

  int get xpForNextLevel {
    switch (currentLevel) {
      case WildXLevel.explorer:  return 250;
      case WildXLevel.ranger:    return 700;
      case WildXLevel.guardian:  return 1500;
    }
  }

  double get levelProgress =>
      ((xp - xpForCurrentLevel) / (xpForNextLevel - xpForCurrentLevel))
          .clamp(0.0, 1.0);

  String get levelLabel {
    switch (currentLevel) {
      case WildXLevel.explorer:  return 'Explorer';
      case WildXLevel.ranger:    return 'Ranger';
      case WildXLevel.guardian:  return 'Guardian';
    }
  }

  String get memberSinceLabel {
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec',
    ];
    return '${months[memberSince.month - 1]} ${memberSince.year}';
  }
}
