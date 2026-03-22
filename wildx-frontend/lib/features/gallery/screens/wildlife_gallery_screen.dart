import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:wildx_frontend/core/config/app_config.dart';
import 'package:wildx_frontend/core/services/backend_service.dart';

class WildlifeGalleryScreen extends StatefulWidget {
  const WildlifeGalleryScreen({super.key});
  @override
  State<WildlifeGalleryScreen> createState() => _WildlifeGalleryScreenState();
}

class _WildlifeGalleryScreenState extends State<WildlifeGalleryScreen> {
  List<_Animal> _all = [];
  bool _loading = true;
  String _selectedPark    = 'All Parks';
  String _selectedAnimal  = 'All';
  final String _searchQuery     = '';

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final res = await BackendService.instance
          .get('${AppConfig.galleryBase}/animals');
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final list = (data is List ? data : (data['animals'] ?? data)) as List;
        if (list.isNotEmpty) {
          setState(() {
            _all = list.map((j) => _Animal.fromJson(j)).toList();
            _loading = false;
          });
          return;
        }
      }
    } catch (_) {}
    setState(() { _all = _fallback; _loading = false; });
  }

  List<String> get _parks {
    final s = <String>{'All Parks'};
    for (final a in _all) {
      s.add(a.parkLocation);
    }
    return s.toList();
  }

  List<String> get _categories {
    final s = <String>{'All'};
    for (final a in _all) {
      s.add(a.category);
    }
    return s.toList();
  }

  List<_Animal> get _filtered => _all.where((a) {
    final parkOk = _selectedPark   == 'All Parks' || a.parkLocation == _selectedPark;
    final catOk  = _selectedAnimal == 'All'        || a.category == _selectedAnimal;
    final searchOk = _searchQuery.isEmpty ||
        a.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        a.parkLocation.toLowerCase().contains(_searchQuery.toLowerCase());
    return parkOk && catOk && searchOk;
  }).toList();

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SafeArea(child: Column(children: [

        // ── App Bar ─────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16,12,16,0),
          child: Row(children: [
            _CircleBtn(icon: Icons.arrow_back_ios_new_rounded,
                onTap: () => Navigator.maybePop(context)),
            const SizedBox(width: 12),
            Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Wildlife Gallery',
                  style: TextStyle(fontSize: 22,
                      fontWeight: FontWeight.w800, color: Colors.black87)),
              Text('${filtered.length} animals',
                  style: const TextStyle(fontSize: 13, color: Colors.grey)),
            ])),
            _CircleBtn(
              icon: Icons.search_rounded,
              onTap: () => showSearch(
                  context: context,
                  delegate: _AnimalSearch(_all)),
            ),
          ]),
        ),
        const SizedBox(height: 14),

        // ── Filter by Park ───────────────────────────────────
        const _FilterLabel(icon: Icons.grid_view_rounded, label: 'Filter by Park'),
        const SizedBox(height: 8),
        _HScroll(
          items: _parks,
          selected: _selectedPark,
          selectedColor: const Color(0xFF2E7D32),
          labelFn: (p) => p == 'All Parks' ? 'All Parks'
              : p.replaceAll(' National Park','').replaceAll(' Forest',''),
          onTap: (p) => setState(() => _selectedPark = p),
        ),
        const SizedBox(height: 10),

        // ── Filter by Category ───────────────────────────────
        _HScroll(
          items: _categories,
          selected: _selectedAnimal,
          selectedColor: Colors.orange,
          labelFn: (c) => c,
          onTap: (c) => setState(() => _selectedAnimal = c),
        ),
        const SizedBox(height: 10),

        // ── Grid ─────────────────────────────────────────────
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator(
                  color: Color(0xFF2E7D32)))
              : filtered.isEmpty
                  ? const Center(child: Text('No animals found',
                      style: TextStyle(color: Colors.grey)))
                  : RefreshIndicator(
                      onRefresh: _load,
                      color: const Color(0xFF2E7D32),
                      child: GridView.builder(
                        padding: const EdgeInsets.fromLTRB(12,0,12,80),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8, mainAxisSpacing: 8,
                          childAspectRatio: 0.82,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (_, i) => _AnimalTile(animal: filtered[i]),
                      ),
                    ),
        ),
      ])),
      // Removed FAB
    );
  }
}

// ── Animal Tile ─────────────────────────────────────────────────────────────
class _AnimalTile extends StatelessWidget {
  final _Animal animal;
  const _AnimalTile({required this.animal});

  static const _catColors = {
    'Mammals':  Color(0xFF2E7D32),
    'Birds':    Color(0xFF1565C0),
    'Reptiles': Color(0xFF558B2F),
    'Amphibians': Color(0xFF00695C),
  };

  static const _statusColors = {
    'Endangered':   Color(0xFFE53935),
    'Vulnerable':   Color(0xFFF57C00),
    'Least Concern':Color(0xFF2E7D32),
  };

  Color get _catColor =>
      _catColors[animal.category] ?? const Color(0xFF455A64);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDetail(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(fit: StackFit.expand, children: [

          // Image
          _AnimalImage(animal: animal),

          // Bottom gradient
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.65),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Category badge (top-left)
          Positioned(top: 8, left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                  color: _catColor, borderRadius: BorderRadius.circular(20)),
              child: Text(animal.category,
                  style: const TextStyle(color: Colors.white,
                      fontSize: 11, fontWeight: FontWeight.w600)),
            ),
          ),

          // Check icon (top-right)
          Positioned(top: 8, right: 8,
            child: Container(
              width: 28, height: 28,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.check_rounded,
                  size: 16, color: Color(0xFF2E7D32)),
            ),
          ),

          // Name + Park (bottom)
          Positioned(bottom: 8, left: 8, right: 8,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(animal.name,
                  style: const TextStyle(color: Colors.white,
                      fontSize: 13, fontWeight: FontWeight.w700),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(
                animal.parkLocation
                    .replaceAll(' National Park','')
                    .replaceAll(' Forest Reserve',''),
                style: const TextStyle(color: Colors.white70, fontSize: 11),
                maxLines: 1, overflow: TextOverflow.ellipsis,
              ),
            ]),
          ),

          // Status badge
          Positioned(bottom: 52, left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: (_statusColors[animal.status] ?? Colors.grey)
                    .withOpacity(0.9),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(animal.status,
                  style: const TextStyle(color: Colors.white,
                      fontSize: 9, fontWeight: FontWeight.w600)),
            ),
          ),
        ]),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _AnimalDetailSheet(animal: animal),
    );
  }
}

// ── Animal Image ────────────────────────────────────────────────────────────
class _AnimalImage extends StatelessWidget {
  final _Animal animal;
  const _AnimalImage({required this.animal});

  static const _bgColors = {
    'Mammals':  Color(0xFF2E7D32),
    'Birds':    Color(0xFF1565C0),
    'Reptiles': Color(0xFF33691E),
  };

  @override
  Widget build(BuildContext context) {
    final bg = _bgColors[animal.category] ?? const Color(0xFF455A64);

    if (animal.assetPath != null) {
      return Image.asset(
        animal.assetPath!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(bg),
      );
    }

    if (animal.imageUrl != null && animal.imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: animal.imageUrl!,
        fit: BoxFit.cover,
        httpHeaders: const {
          'User-Agent': 'WildX/1.0 (Flutter; Sri Lanka Wildlife App)',
        },
        placeholder: (_, __) => _placeholder(bg),
        errorWidget:  (_, __, ___) => _placeholder(bg),
      );
    }
    return _placeholder(bg);
  }

  Widget _placeholder(Color bg) => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft, end: Alignment.bottomRight,
        colors: [bg, bg.withOpacity(0.7)],
      ),
    ),
    child: Center(
      child: Text(animal.emoji,
          style: const TextStyle(fontSize: 56)),
    ),
  );
}

// ── Animal Detail Sheet ─────────────────────────────────────────────────────
class _AnimalDetailSheet extends StatelessWidget {
  final _Animal animal;
  const _AnimalDetailSheet({required this.animal});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6, maxChildSize: 0.9, minChildSize: 0.4,
      builder: (_, ctrl) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: ListView(controller: ctrl, padding: const EdgeInsets.all(24),
            children: [
          Center(child: Container(width: 40, height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 16),
          Row(children: [
            Text(animal.emoji, style: const TextStyle(fontSize: 48)),
            const SizedBox(width: 12),
            Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(animal.name,
                  style: const TextStyle(fontSize: 20,
                      fontWeight: FontWeight.w800)),
              Text(animal.scientificName,
                  style: const TextStyle(fontSize: 13,
                      fontStyle: FontStyle.italic, color: Colors.grey)),
            ])),
          ]),
          const SizedBox(height: 16),
          _DetailRow(icon: Icons.park_rounded, label: 'Location',
              value: animal.parkLocation),
          _DetailRow(icon: Icons.category_rounded, label: 'Category',
              value: animal.category),
          _DetailRow(icon: Icons.warning_amber_rounded, label: 'Status',
              value: animal.status,
              valueColor: animal.status == 'Endangered'
                  ? Colors.red : animal.status == 'Vulnerable'
                  ? Colors.orange : Colors.green),
        ]),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon; final String label, value; final Color? valueColor;
  const _DetailRow({required this.icon, required this.label,
      required this.value, this.valueColor});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(children: [
      Icon(icon, size: 18, color: const Color(0xFF2E7D32)),
      const SizedBox(width: 10),
      Text('$label: ', style: const TextStyle(color: Colors.grey, fontSize: 13)),
      Expanded(child: Text(value,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13,
              color: valueColor ?? Colors.black87))),
    ]),
  );
}

// ── Helpers ─────────────────────────────────────────────────────────────────
class _CircleBtn extends StatelessWidget {
  final IconData icon; final VoidCallback onTap;
  const _CircleBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 40, height: 40,
      decoration: BoxDecoration(color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08),
              blurRadius: 8, offset: const Offset(0,2))]),
      child: Icon(icon, size: 18, color: Colors.black87),
    ),
  );
}

class _FilterLabel extends StatelessWidget {
  final IconData icon; final String label;
  const _FilterLabel({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Row(children: [
      Icon(icon, size: 14, color: Colors.grey),
      const SizedBox(width: 6),
      Text(label, style: const TextStyle(
          fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey)),
    ]),
  );
}

class _HScroll extends StatelessWidget {
  final List<String> items; final String selected;
  final Color selectedColor;
  final String Function(String) labelFn;
  final void Function(String) onTap;
  const _HScroll({required this.items, required this.selected,
      required this.selectedColor, required this.labelFn,
      required this.onTap});
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 36,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(width: 8),
      itemBuilder: (_, i) {
        final item = items[i];
        final sel = item == selected;
        return GestureDetector(
          onTap: () => onTap(item),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: sel ? selectedColor : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                  color: sel ? selectedColor : Colors.grey.shade300),
            ),
            child: Text(labelFn(item),
                style: TextStyle(fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: sel ? Colors.white : Colors.black87)),
          ),
        );
      },
    ),
  );
}

// ── Search Delegate ──────────────────────────────────────────────────────────
class _AnimalSearch extends SearchDelegate<String> {
  final List<_Animal> animals;
  _AnimalSearch(this.animals);

  @override
  List<Widget> buildActions(BuildContext context) =>
      [IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')];

  @override
  Widget buildLeading(BuildContext context) =>
      IconButton(icon: const Icon(Icons.arrow_back),
          onPressed: () => close(context, ''));

  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);

  @override
  Widget buildSuggestions(BuildContext context) {
    final res = animals.where((a) =>
        a.name.toLowerCase().contains(query.toLowerCase()) ||
        a.parkLocation.toLowerCase().contains(query.toLowerCase())).toList();
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 8,
          mainAxisSpacing: 8, childAspectRatio: 0.82),
      itemCount: res.length,
      itemBuilder: (_, i) => _AnimalTile(animal: res[i]),
    );
  }
}

// ── Animal Model ─────────────────────────────────────────────────────────────
class _Animal {
  final String id, name, scientificName, category, parkLocation, status, emoji;
  final String? imageUrl;
  static const Map<String, String> _assetByName = {
    'Asian Elephant': 'assets/images/Asian Elephant.jpg.jpeg',
    'Indian Cobra': 'assets/images/Indian Cobra.jpg.jpeg',
    'Mugger Crocodile': 'assets/images/Mugger Crocodile.jpg.jpeg',
    'Peacock': 'assets/images/Peacock.jpg.jpeg',
    'Purple-faced Langur': 'assets/images/Purple-faced Langur.jpg.jpeg',
    'Sri Lanka Junglefowl': 'assets/images/Sri Lanka Junglefowl.jpg.jpeg',
    'Sri Lankan Leopard': 'assets/images/Sri Lankan Leopard.jpg.jpeg',
    'Sri Lankan Sloth Bear': 'assets/images/Sri Lankan Sloth Bear.jpg.jpeg',
  };

  const _Animal({required this.id, required this.name,
      required this.scientificName, required this.category,
      required this.parkLocation, required this.status,
      required this.emoji, this.imageUrl});

  String? get assetPath => _assetByName[name];

  factory _Animal.fromJson(Map<String, dynamic> j) => _Animal(
    id: j['id']?.toString() ?? '',
    name: j['name'] ?? '',
    scientificName: j['scientificName'] ?? j['scientific_name'] ?? '',
    category: j['category'] ?? 'Mammals',
    parkLocation: j['parkLocation'] ?? j['park_location'] ?? '',
    status: j['status'] ?? 'Least Concern',
    emoji: j['emoji'] ?? '??',
    imageUrl: j['imageUrl'] ?? j['image_url'],
  );
}

// ── Fallback Data ─────────────────────────────────────────────────────────────
const _fallback = [
  _Animal(id:'1', name:'Sri Lankan Leopard',
      scientificName:'Panthera pardus kotiya', category:'Mammals',
      parkLocation:'Yala National Park', status:'Endangered', emoji:'🐆',
      imageUrl:'https://upload.wikimedia.org/wikipedia/commons/thumb/4/45/A_Female_leopard_in_Yala_National_Park.jpg/480px-A_Female_leopard_in_Yala_National_Park.jpg'),
  _Animal(id:'2', name:'Asian Elephant',
      scientificName:'Elephas maximus', category:'Mammals',
      parkLocation:'Minneriya National Park', status:'Endangered', emoji:'🐘',
      imageUrl:'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg/480px-Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg'),
  _Animal(id:'3', name:'Sri Lankan Sloth Bear',
      scientificName:'Melursus ursinus inornatus', category:'Mammals',
      parkLocation:'Wilpattu National Park', status:'Vulnerable', emoji:'🐻',
      imageUrl:'https://upload.wikimedia.org/wikipedia/commons/thumb/b/ba/Sloth_bear_guwahati.jpg/480px-Sloth_bear_guwahati.jpg'),
  _Animal(id:'4', name:'Peacock',
      scientificName:'Pavo cristatus', category:'Birds',
      parkLocation:'Udawalawe National Park', status:'Least Concern', emoji:'🦚',
      imageUrl:'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5d/Peacock_Plumage.jpg/480px-Peacock_Plumage.jpg'),
  _Animal(id:'5', name:'Purple-faced Langur',
      scientificName:'Trachypithecus vetulus', category:'Mammals',
      parkLocation:'Sinharaja Forest', status:'Endangered', emoji:'🐒',
      imageUrl:'https://upload.wikimedia.org/wikipedia/commons/thumb/3/30/Purple_faced_langur.jpg/480px-Purple_faced_langur.jpg'),
  _Animal(id:'6', name:'Mugger Crocodile',
      scientificName:'Crocodylus palustris', category:'Reptiles',
      parkLocation:'Yala National Park', status:'Vulnerable', emoji:'🐊',
      imageUrl:'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Crocodylus_palustris.jpg/480px-Crocodylus_palustris.jpg'),
  _Animal(id:'7', name:'Sri Lanka Junglefowl',
      scientificName:'Gallus lafayettii', category:'Birds',
      parkLocation:'Horton Plains', status:'Least Concern', emoji:'🐓',
      imageUrl:'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f3/Gallus_lafayettii_-_Sri_Lanka_junglefowl.jpg/480px-Gallus_lafayettii_-_Sri_Lanka_junglefowl.jpg'),
  _Animal(id:'8', name:'Indian Cobra',
      scientificName:'Naja naja', category:'Reptiles',
      parkLocation:'Bundala National Park', status:'Least Concern', emoji:'🐍',
      imageUrl:'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3b/Naja_naja_zilla.jpg/480px-Naja_naja_zilla.jpg'),
];


