import 'package:flutter/material.dart';
import '../models/wildlife_animal.dart';
import '../data/gallery_data.dart';

class AnimalGridCard extends StatelessWidget {
  final WildlifeAnimal animal;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const AnimalGridCard({
    super.key,
    required this.animal,
    required this.onTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          // Subtle shadow for better depth and modern look
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section: Emoji and Overlaid Information Badges
            Stack(
              children: [
                Container(
                  height: 110,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF0F7F4), // Soft nature-inspired green
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16)),
                  ),
                  child: Center(
                    child: Text(
                      animal.emoji,
                      style: const TextStyle(fontSize: 52),
                    ),
                  ),
                ),
                
                // Favorite Button - Positioned in the top right
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Icon(
                        animal.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: animal.isFavorite
                            ? Colors.red
                            : Colors.grey[400],
                        size: 16,
                      ),
                    ),
                  ),
                ),
                
                // Conservation Status Badge - Positioned in the top left
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: getStatusBgColor(animal.status),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      animal.status,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: getStatusColor(animal.status),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Bottom Section: Animal Metadata and Location Info
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    animal.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, // Prevents UI breaking if name is too long
                  ),
                  const SizedBox(height: 2),
                  Text(
                    animal.scientificName,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[400],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  
                  // Location Row
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 11, color: Colors.grey[400]),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          animal.parkLocation,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[400],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}