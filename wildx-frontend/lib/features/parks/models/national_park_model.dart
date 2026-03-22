// Matches exact DB schema:
// national_parks + park_animal_types + park_rules
// All nullable fields use ? — null safety fixed

class NationalPark {
  final int id;
  final String name;
  final String? description;
  final String? location;
  final double? sizeInHectares;
  final String? openingTime;
  final String? closingTime;
  final double? entryFee;
  final String? imageUrl;
  final String? contactNumber;
  final String? email;
  final String? bestVisitingSeason;
  final bool isActive;
  final List<String> animalTypes;
  final List<ParkRule> rules;

  const NationalPark({
    required this.id,
    required this.name,
    this.description,
    this.location,
    this.sizeInHectares,
    this.openingTime,
    this.closingTime,
    this.entryFee,
    this.imageUrl,
    this.contactNumber,
    this.email,
    this.bestVisitingSeason,
    this.isActive = true,
    this.animalTypes = const [],
    this.rules = const [],
  });

  // Alias for backward compat — park_details_screen uses rulesAndRegulations
  List<String> get rulesAndRegulations => rules.map((r) => r.rule).toList();

  factory NationalPark.fromJson(Map<String, dynamic> j) => NationalPark(
    id:                 (j['id'] as num).toInt(),
    name:               j['name'] as String,
    description:        j['description'] as String?,
    location:           j['location'] as String?,
    sizeInHectares:     (j['size_in_hectares'] as num?)?.toDouble(),
    openingTime:        j['opening_time'] as String?,
    closingTime:        j['closing_time'] as String?,
    entryFee:           (j['entry_fee'] as num?)?.toDouble(),
    imageUrl:           j['image_url'] as String?,
    contactNumber:      j['contact_number'] as String?,
    email:              j['email'] as String?,
    bestVisitingSeason: j['best_visiting_season'] as String?,
    isActive:           j['is_active'] as bool? ?? true,
    animalTypes:        (j['animal_types'] as List?)?.cast<String>() ?? [],
    rules:              (j['rules'] as List?)
                          ?.map((r) => ParkRule.fromJson(r)).toList() ?? [],
  );
}

class ParkRule {
  final int id;
  final int parkId;
  final String rule;

  const ParkRule({required this.id, required this.parkId, required this.rule});

  factory ParkRule.fromJson(Map<String, dynamic> j) => ParkRule(
    id:     (j['id'] as num).toInt(),
    parkId: (j['park_id'] as num?)?.toInt() ?? 0,
    rule:   j['rule'] as String,
  );
}
