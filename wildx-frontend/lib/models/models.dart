// ── Park ──────────────────────────────────────────────────────────
class Park {
  final String id, name, location, imageUrl, description;
  final int animalCount;
  final bool isFeatured;

  const Park({
    required this.id, required this.name, required this.location,
    required this.imageUrl, required this.description,
    required this.animalCount, this.isFeatured = false,
  });
}

// ── Sighting ──────────────────────────────────────────────────────
class Sighting {
  final String id, animalName, parkName, imageUrl, category;
  final DateTime date;

  const Sighting({
    required this.id, required this.animalName, required this.parkName,
    required this.imageUrl, required this.category, required this.date,
  });

  String get formattedDate =>
      '${date.month.toString().padLeft(2,'0')}/'
      '${date.day.toString().padLeft(2,'0')}/${date.year}';
}

// ── UserStats ─────────────────────────────────────────────────────
class UserStats {
  final int sightings, badges, parks;
  const UserStats({required this.sightings, required this.badges, required this.parks});
}

// ── GalleryItem ───────────────────────────────────────────────────
class GalleryItem {
  final String id, title, imageUrl, category;
  const GalleryItem({required this.id, required this.title,
      required this.imageUrl, required this.category});
}

// ── Accommodation ─────────────────────────────────────────────────
class Accommodation {
  final String name, location, price, distance;
  final double rating;
  const Accommodation({required this.name, required this.location,
      required this.price, required this.distance, required this.rating});
}
