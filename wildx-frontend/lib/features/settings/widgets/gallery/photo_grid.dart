import 'package:flutter/material.dart';
import '../../models/wildlife_photo.dart';
import 'photo_grid_tile.dart';

class PhotoGrid extends StatelessWidget {
  final List<WildlifePhoto> photos;
  final Function(WildlifePhoto)? onPhotoTap;

  const PhotoGrid({
    super.key,
    required this.photos,
    this.onPhotoTap,
  });

  @override
  Widget build(BuildContext context) {
    // Conditional rendering: Show empty state if no data matches the filter
    if (photos.isEmpty) {
      return const _EmptyGallery();
    }

    return GridView.builder(
      shrinkWrap: true, // Allows the grid to be used inside a scrollable column
      physics: const NeverScrollableScrollPhysics(), // Disables internal scrolling to work with parent scroll view
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Two columns for a clean gallery layout
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.0, // Square tiles for consistent photography display
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return PhotoGridTile(
          photo: photos[index],
          onTap: onPhotoTap != null ? () => onPhotoTap!(photos[index]) : null,
        );
      },
    );
  }
}

/// A private helper widget to handle the 'No Results' UI
class _EmptyGallery extends StatelessWidget {
  const _EmptyGallery();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('📷', style: TextStyle(fontSize: 48)), // Visual cue
            const SizedBox(height: 12),
            Text(
              'No photos found',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Try a different filter',
              style: TextStyle(fontSize: 13, color: Colors.grey[400]),
            ),
          ],
        ),
      ),
    );
  }
}