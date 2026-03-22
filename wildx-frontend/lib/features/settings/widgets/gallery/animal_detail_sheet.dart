import 'package:flutter/material.dart';
import '../../models/wildlife_animal.dart';
import '../../data/gallery_data.dart';

class AnimalDetailSheet extends StatelessWidget {
  final WildlifeAnimal animal;

  const AnimalDetailSheet({super.key, required this.animal});

  // Static method to easily trigger the bottom sheet from any screen
  static void show(BuildContext context, WildlifeAnimal animal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the sheet to size based on content
      backgroundColor: Colors.transparent,
      builder: (_) => AnimalDetailSheet(animal: animal),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Visual handle for better UX (indicates it's draggable)
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Animal Emoji/Image Container
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F7F4),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(animal.emoji,
                  style: const TextStyle(fontSize: 56)),
            ),
          ),

          // Title Section
          Text(
            animal.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            animal.scientificName,
            style: TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 16),

          // Status and Category Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _InfoChip(
                label: animal.status,
                color: getStatusColor(animal.status),
                bgColor: getStatusBgColor(animal.status),
              ),
              const SizedBox(width: 10),
              _InfoChip(
                label: animal.category,
                color: const Color(0xFF1E88E5),
                bgColor: const Color(0xFFE3F2FD),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Location Detail Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.location_on,
                      color: Color(0xFF2ECC71), size: 20),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Found In',
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[400])),
                    Text(
                      animal.parkLocation,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Action Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2ECC71),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'View Full Profile',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Private helper widget for info chips to maintain consistency
class _InfoChip extends StatelessWidget {
  final String label;
  final Color color;
  final Color bgColor;

  const _InfoChip({
    required this.label,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}