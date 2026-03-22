import 'package:flutter/material.dart';
import '../models/national_park_model.dart';
import '../services/national_park_service.dart';
import '../widgets/park_card.dart';

// Animal list matching DB park_animal_types
const _animals = [
  'Asian Elephant',
  'Sri Lankan Leopard',
  'Spotted Deer',
  'Crocodile',
  'Water Buffalo',
  'Sloth Bear',
  'Peacock',
  'Purple-faced Langur',
];

class ParkSearchScreen extends StatefulWidget {
  const ParkSearchScreen({super.key});
  @override
  State<ParkSearchScreen> createState() => _ParkSearchScreenState();
}

class _ParkSearchScreenState extends State<ParkSearchScreen> {
  final _service = NationalParkService();

  String? _selectedAnimal;
  List<NationalPark> _parks = [];
  bool _loading = false;
  bool _searched = false;

  Future<void> _viewParks() async {
    if (_selectedAnimal == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select an animal first'),
        backgroundColor: Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
      ));
      return;
    }
    setState(() { _loading = true; _searched = true; _parks = []; });
    final parks = await _service.searchParkByAnimal(_selectedAnimal!);
    setState(() { _parks = parks; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(children: [
        // ── Green Header ─────────────────────────────────────
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16, right: 16, bottom: 24,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFF2E7D32),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Find National Parks',
                style: TextStyle(color: Colors.white,
                    fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Search by Animal',
                style: TextStyle(color: Colors.white70,
                    fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),

            // Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedAnimal,
                  hint: const Text('Select an animal',
                      style: TextStyle(color: Colors.grey)),
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  items: _animals.map((a) => DropdownMenuItem(
                    value: a,
                    child: Text(a),
                  )).toList(),
                  onChanged: (v) => setState(() {
                    _selectedAnimal = v;
                    _searched = false;
                    _parks = [];
                  }),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // View Parks button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _viewParks,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text('View Parks',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ]),
        ),

        // ── Results ───────────────────────────────────────────
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator(
                  color: Color(0xFF2E7D32)))
              : !_searched
                  ? Center(
                      child: Column(
                          mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.search_rounded, size: 64,
                            color: Colors.grey[300]),
                        const SizedBox(height: 12),
                        Text('Select an animal and click "View Parks"',
                            style: TextStyle(color: Colors.grey[500],
                                fontSize: 14)),
                      ]))
                  : _parks.isEmpty
                      ? Center(
                          child: Column(
                              mainAxisSize: MainAxisSize.min, children: [
                            Icon(Icons.park_outlined, size: 64,
                                color: Colors.grey[300]),
                            const SizedBox(height: 12),
                            Text('No parks found for "$_selectedAnimal"',
                                style: TextStyle(color: Colors.grey[500])),
                          ]))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _parks.length,
                          itemBuilder: (_, i) => ParkCard(park: _parks[i]),
                        ),
        ),
      ]),
    );
  }
}
