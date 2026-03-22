import 'package:flutter/material.dart';
import '../models/location_info.dart';
import '../services/location_service.dart';

class LocationCard extends StatefulWidget {
  final LocationInfo fallbackLocation;
  final VoidCallback? onShare;

  const LocationCard({
    super.key,
    required this.fallbackLocation,
    this.onShare,
  });

  @override
  State<LocationCard> createState() => _LocationCardState();
}

class _LocationCardState extends State<LocationCard> {
  final LocationService _locationService = LocationService();

  LocationInfo? _currentLocation;
  LocationStatus _status = LocationStatus.loading;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    setState(() {
      _status = LocationStatus.loading;
      _errorMsg = null;
    });

    final result = await _locationService.getCurrentLocation();
    if (!mounted) return;

    setState(() {
      _status = result.status;
      _currentLocation = result.location;
      _errorMsg = result.error;
    });
  }

  LocationInfo get _displayLocation =>
      _currentLocation ?? widget.fallbackLocation;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _status == LocationStatus.success
              ? Colors.blue.shade100
              : _status == LocationStatus.permissionDenied
                  ? Colors.orange.shade200
                  : Colors.blue.shade100,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.location_pin, color: Colors.blue.shade700, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Your Current Location',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (_status == LocationStatus.loading)
                      SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.blue.shade600,
                        ),
                      )
                    else if (_status == LocationStatus.success)
                      Icon(Icons.gps_fixed, size: 14, color: Colors.green.shade600)
                    else
                      Icon(Icons.gps_off, size: 14, color: Colors.orange.shade600),
                  ],
                ),
                const SizedBox(height: 3),
                if (_status == LocationStatus.loading)
                  Text(
                    'Getting GPS location...',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                  )
                else if (_status == LocationStatus.success && _currentLocation != null) ...[
                  if (_currentLocation!.parkName.isNotEmpty)
                    Text(
                      _currentLocation!.fullLocation,
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                    ),
                  Text(
                    'Coordinates: ${_currentLocation!.coordinates}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                ] else ...[
                  Text(
                    _errorMsg ?? 'Location unavailable',
                    style: TextStyle(color: Colors.orange.shade700, fontSize: 12),
                  ),
                  Text(
                    'Using: ${widget.fallbackLocation.coordinates}',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    GestureDetector(
                      onTap: widget.onShare != null
                          ? () => widget.onShare!()
                          : null,
                      child: Text(
                        'Share Location →',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: _fetchLocation,
                      child: Row(
                        children: [
                          Icon(Icons.refresh, size: 13, color: Colors.grey.shade500),
                          const SizedBox(width: 3),
                          Text(
                            'Refresh',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
