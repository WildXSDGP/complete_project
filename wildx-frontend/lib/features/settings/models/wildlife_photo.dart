class WildlifePhoto {
  final String id;
  final String imageUrl;
  final String animalType; // e.g., Leopard, Elephant
  final String parkName;   // Location where the photo was taken
  final String uploadedBy; // User or Photographer name
  final DateTime uploadedAt;

  const WildlifePhoto({
    required this.id,
    required this.imageUrl,
    required this.animalType,
    required this.parkName,
    required this.uploadedBy,
    required this.uploadedAt,
  });
}