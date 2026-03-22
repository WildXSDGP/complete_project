enum AnimalType { elephant, leopard, deer, bird, bear, crocodile }

extension AnimalTypeExtension on AnimalType {
  String get label {
    switch (this) {
      case AnimalType.elephant:  return 'Elephant';
      case AnimalType.leopard:   return 'Leopard';
      case AnimalType.deer:      return 'Deer';
      case AnimalType.bird:      return 'Bird';
      case AnimalType.bear:      return 'Bear';
      case AnimalType.crocodile: return 'Crocodile';
    }
  }

  String get emoji {
    switch (this) {
      case AnimalType.elephant:  return '\u{1F418}';
      case AnimalType.leopard:   return '\u{1F406}';
      case AnimalType.deer:      return '\u{1F98C}';
      case AnimalType.bird:      return '\u{1F985}';
      case AnimalType.bear:      return '\u{1F43B}';
      case AnimalType.crocodile: return '\u{1F40A}';
    }
  }

  static List<AnimalType> get allAnimals => AnimalType.values;
}