class WildlifeAnimal {
  final String id;
  final String name;
  final String scientificName;
  final String category;            // Mammal, Bird, etc
  final String parkLocation;
  final String status;
  final String emoji;               // Image path or Emoji
  final bool isFavorite;

  const WildlifeAnimal({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.category,
    required this.parkLocation,
    required this.status,
    required this.emoji,
    this.isFavorite = false,
  });

  WildlifeAnimal copyWith({bool? isFavorite}) {
    return WildlifeAnimal(
      id: id,
      name: name,
      scientificName: scientificName,
      category: category,
      parkLocation: parkLocation,
      status: status,
      emoji: emoji,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
