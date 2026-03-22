import 'package:flutter/material.dart';
import '../models/location_info1.dart';
import '../services/location_service1.dart';

class ChangeLocationSheet extends StatefulWidget {
  final LocationInfo currentLocation;
  final ValueChanged<LocationInfo> onLocationSelected;

  const ChangeLocationSheet({
    super.key,
    required this.currentLocation,
    required this.onLocationSelected,
  });

  @override
  State<ChangeLocationSheet> createState() => _ChangeLocationSheetState();
}

class _ChangeLocationSheetState extends State<ChangeLocationSheet> {
  final _searchController = TextEditingController();
  final _locationService = LocationService();
  List<LocationInfo> _results = LocationInfo.predefinedLocations;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearch);
  }

  void _onSearch() {
    setState(() {
      _results = _locationService.searchLocations(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Select Location',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search location...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.4,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _results.length,
              itemBuilder: (_, i) {
                final loc = _results[i];
                final isCurrent = loc.name == widget.currentLocation.name;
                return ListTile(
                  leading: Icon(
                    Icons.location_on_outlined,
                    color: isCurrent
                        ? const Color(0xFF2E7D32)
                        : const Color(0xFF757575),
                  ),
                  title: Text(loc.name,
                      style: TextStyle(
                          fontWeight: isCurrent
                              ? FontWeight.w600
                              : FontWeight.w400)),
                  subtitle: Text(loc.formattedCoordinates,
                      style: const TextStyle(fontSize: 11)),
                  trailing: isCurrent
                      ? const Icon(Icons.check_circle,
                          color: Color(0xFF2E7D32))
                      : null,
                  onTap: () {
                    widget.onLocationSelected(loc);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}