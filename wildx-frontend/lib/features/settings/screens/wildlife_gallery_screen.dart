import 'package:flutter/material.dart';
import '../data/gallery_data.dart';
import '../models/wildlife_animal.dart';
import '../widgets/gallery_app_bar.dart';
import '../widgets/gallery_search_bar.dart';
import '../widgets/category_filter_chips.dart';
import '../widgets/animal_grid_card.dart';
import '../widgets/animal_detail_sheet.dart';
import '../widgets/gallery_empty_state.dart';

class WildlifeGalleryScreen extends StatefulWidget {
  const WildlifeGalleryScreen({super.key});

  @override
  State<WildlifeGalleryScreen> createState() =>
      _WildlifeGalleryScreenState();
}

class _WildlifeGalleryScreenState extends State<WildlifeGalleryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _searchQuery = '';
  late List<WildlifeAnimal> _animals;

  @override
  void initState() {
    super.initState();
    // Initializing the local state with data from the mock database
    // Using .map to ensure each object is a fresh copy for local modifications
    _animals = wildlifeAnimals
        .map((a) => a.copyWith(isFavorite: false))
        .toList();
  }

  @override
  void dispose() {
    // Preventing memory leaks by disposing the controller
    _searchController.dispose();
    super.dispose();
  }

  // Getter for the logic-based filtering of the animal list
  List<WildlifeAnimal> get _filteredAnimals {
    return _animals.where((animal) {
      // Logic for Category filtering
      final matchesCategory = _selectedCategory == 'All' ||
          animal.category == _selectedCategory;
      
      // Multi-parameter search logic (Name, Scientific Name, or Location)
      final matchesSearch = _searchQuery.isEmpty ||
          animal.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          animal.scientificName
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          animal.parkLocation
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
              
      return matchesCategory && matchesSearch;
    }).toList();
  }

  // Handling the favorite toggle at the screen level to preserve state
  void _toggleFavorite(int index, WildlifeAnimal animal) {
    final globalIndex =
        _animals.indexWhere((a) => a.id == animal.id);
    if (globalIndex != -1) {
      setState(() {
        _animals[globalIndex] =
            _animals[globalIndex].copyWith(isFavorite: !animal.isFavorite);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredAnimals;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F7F4), // Light nature-themed background
      appBar: const GalleryAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search UI Section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: GallerySearchBar(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),

          // Horizontal Filter Section
          CategoryFilterChips(
            selectedCategory: _selectedCategory,
            onCategorySelected: (cat) =>
                setState(() => _selectedCategory = cat),
          ),
          const SizedBox(height: 12),

          // Dynamic Result Count display
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '${filtered.length} species found',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Main Gallery Content Section
          Expanded(
            child: filtered.isEmpty
                ? const GalleryEmptyState() // Feedback when no results found
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.78, // Adjusted for the card info area
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final animal = filtered[index];
                      return AnimalGridCard(
                        animal: animal,
                        onTap: () =>
                            AnimalDetailSheet.show(context, animal),
                        onFavoriteTap: () =>
                            _toggleFavorite(index, animal),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}