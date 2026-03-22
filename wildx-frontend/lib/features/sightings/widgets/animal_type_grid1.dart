import 'package:flutter/material.dart';
import '../models/animal_type1.dart';
import 'animal_type_card1.dart';

class AnimalTypeGrid extends StatelessWidget {
  final AnimalType? selected;
  final ValueChanged<AnimalType> onSelected;

  const AnimalTypeGrid({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final animals = AnimalTypeExtension.allAnimals;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: animals.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.05,
      ),
      itemBuilder: (_, i) => AnimalTypeCard(
        animal: animals[i],
        isSelected: selected == animals[i],
        onTap: () => onSelected(animals[i]),
      ),
    );
  }
}