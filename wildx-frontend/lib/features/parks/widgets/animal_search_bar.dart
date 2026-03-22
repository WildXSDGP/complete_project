import 'package:flutter/material.dart';

class AnimalSearchBar extends StatelessWidget {
  final String? selectedAnimal;
  final List<String> animalTypes;
  final ValueChanged<String?> onAnimalChanged;
  final VoidCallback onSearchPressed;

  const AnimalSearchBar({
    super.key,
    required this.selectedAnimal,
    required this.animalTypes,
    required this.onAnimalChanged,
    required this.onSearchPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[700],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Search by Animal',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _AnimalDropdown(
            selectedAnimal: selectedAnimal,
            animalTypes: animalTypes,
            onChanged: onAnimalChanged,
          ),
          const SizedBox(height: 16),
          _ViewParksButton(onPressed: onSearchPressed),
        ],
      ),
    );
  }
}

class _AnimalDropdown extends StatelessWidget {
  final String? selectedAnimal;
  final List<String> animalTypes;
  final ValueChanged<String?> onChanged;

  const _AnimalDropdown({
    required this.selectedAnimal,
    required this.animalTypes,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        value: selectedAnimal,
        hint: const Text('Select an animal'),
        underline: const SizedBox(),
        items: animalTypes.map((animal) {
          return DropdownMenuItem(value: animal, child: Text(animal));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

class _ViewParksButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _ViewParksButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text(
        'View Parks',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
