import 'package:flutter/material.dart';
import '../data/gallery_data.dart';

class AnimalFilterBar extends StatelessWidget {
  final String selectedAnimal;
  final ValueChanged<String> onAnimalSelected;

  const AnimalFilterBar({
    super.key,
    required this.selectedAnimal,
    required this.onAnimalSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      // Horizontal scrolling for many categories
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: galleryCategories.map((animal) { // galleryCategories is imported from gallery_data
            final isSelected = selectedAnimal == animal;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => onAnimalSelected(animal),
                // Using AnimatedContainer for smooth color transitions
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFFF6B35) // Primary accent color
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFFF6B35)
                          : Colors.grey[300]!,
                    ),
                  ),
                  child: Text(
                    animal,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF1A1A2E),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}