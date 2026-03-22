import 'package:flutter/material.dart';
import '../models/wildlife_photo.dart';

class PhotoGridTile extends StatelessWidget {
  final WildlifePhoto photo;
  final VoidCallback? onTap;

  const PhotoGridTile({
    super.key,
    required this.photo,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      // Clipping the content to ensure rounded corners are applied to the image/stack
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand, // Ensures the stack children fill the tile area
          children: [
            // Displaying the photo from local assets
            Image.asset(
              photo.imageUrl,
              fit: BoxFit.cover, // Ensures the image fills the tile without distortion
              // Handling missing assets gracefully with a fallback placeholder
              errorBuilder: (_, __, ___) => _PlaceholderTile(photo: photo),
            ),
            
            // Subtle gradient overlay at the bottom to improve contrast
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.35),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A fallback widget used if the image fails to load or is missing
class _PlaceholderTile extends StatelessWidget {
  final WildlifePhoto photo;
  const _PlaceholderTile({required this.photo});

  // Dynamically selecting a background color based on the animal category
  Color get _bgColor {
    switch (photo.animalType) {
      case 'Elephant':
        return const Color(0xFFE8F5E9);
      case 'Leopard':
        return const Color(0xFF212121);
      case 'Bird':
        return const Color(0xFFE3F2FD);
      case 'Deer':
        return const Color(0xFFFFF3E0);
      default:
        return const Color(0xFFF5F5F5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _bgColor,
      child: Center(
        child: Text(
          _animalEmoji(photo.animalType),
          style: const TextStyle(fontSize: 36),
        ),
      ),
    );
  }

  // Mapping animal types to visual emoji representation
  String _animalEmoji(String type) {
    switch (type) {
      case 'Elephant':
        return '🐘';
      case 'Leopard':
        return '🐆';
      case 'Bird':
        return '🦜';
      case 'Deer':
        return '🦌';
      default:
        return '🌿';
    }
  }
}