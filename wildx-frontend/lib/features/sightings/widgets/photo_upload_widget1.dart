import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class PhotoUploadWidget extends StatelessWidget {
  /// Mobile: File path use කරනවා
  final File? photo;

  /// Web: bytes use කරනවා (XFile.readAsBytes())
  final Uint8List? photoBytes;

  final VoidCallback onTap;
  final VoidCallback? onRemove;

  const PhotoUploadWidget({
    super.key,
    this.photo,
    this.photoBytes,
    required this.onTap,
    this.onRemove,
  });

  bool get _hasPhoto => kIsWeb ? photoBytes != null : photo != null;

  Widget _buildImage() {
    if (kIsWeb && photoBytes != null) {
      return Image.memory(photoBytes!, fit: BoxFit.cover);
    } else if (!kIsWeb && photo != null) {
      return Image.file(photo!, fit: BoxFit.cover);
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _hasPhoto
                ? const Color(0xFF2E7D32)
                : const Color(0xFFCCCCCC),
            width: _hasPhoto ? 2 : 1.5,
          ),
        ),
        child: _hasPhoto
            ? ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildImage(),
                    Container(color: Colors.black.withOpacity(0.15)),
                    const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.camera_alt_rounded,
                              color: Colors.white, size: 28),
                          SizedBox(height: 4),
                          Text(
                            'Tap to change',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    if (onRemove != null)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => onRemove!(),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red.shade600,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close,
                                color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F4F0),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(Icons.upload_rounded,
                        color: Color(0xFF757575), size: 26),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Tap to upload photo',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF424242)),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'JPG, PNG up to 10MB',
                    style: TextStyle(fontSize: 12, color: Color(0xFF9E9E9E)),
                  ),
                ],
              ),
      ),
    );
  }
}
