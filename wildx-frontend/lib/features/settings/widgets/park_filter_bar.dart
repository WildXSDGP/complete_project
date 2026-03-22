import 'package:flutter/material.dart';
import '../data/gallery_data.dart';

class ParkFilterBar extends StatelessWidget {
  final String selectedPark;
  final ValueChanged<String> onParkSelected;

  const ParkFilterBar({
    super.key,
    required this.selectedPark,
    required this.onParkSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Label with an Icon for better visual hierarchy
          Row(
            children: [
              Icon(Icons.grid_view_rounded, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Text(
                'Filter by Park',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          
          // Horizontal scrollable list for park categories
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: galleryParks.map((park) {
                final isSelected = selectedPark == park;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => onParkSelected(park),
                    // AnimatedContainer provides a smooth feedback transition when tapped
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF2ECC71) // Brand primary green
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF2ECC71)
                              : Colors.grey[300]!,
                        ),
                      ),
                      child: Text(
                        park,
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
        ],
      ),
    );
  }
}