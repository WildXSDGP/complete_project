import 'package:flutter/material.dart';
import '../models/location_info1.dart';

class LocationWidget extends StatelessWidget {
  final LocationInfo location;
  final bool isLoading;
  final VoidCallback onChangeTap;

  const LocationWidget({
    super.key,
    required this.location,
    required this.onChangeTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF4FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBBD0FF)),
      ),
      child: isLoading
          ? const Center(
              child: SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on_rounded,
                    color: Color(0xFF3B5BDB), size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Current Location',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1A1A))),
                      const SizedBox(height: 2),
                      Text(location.name,
                          style: const TextStyle(
                              fontSize: 13, color: Color(0xFF424242))),
                      Text(location.formattedCoordinates,
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF757575))),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: onChangeTap,
                        child: const Text(
                          'Change Location →',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF3B5BDB),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}