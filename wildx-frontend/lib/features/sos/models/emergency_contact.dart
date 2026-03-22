class EmergencyContact {
  final String name;
  final String number;
  final String emoji;

  const EmergencyContact({
    required this.name,
    required this.number,
    required this.emoji,
  });
}

final List<EmergencyContact> defaultEmergencyContacts = [
  const EmergencyContact(
    name: 'Wildlife Emergency',
    number: '119',
    emoji: '🚨',
  ),
  const EmergencyContact(
    name: 'Park Rangers',
    number: '0112-888-585',
    emoji: '👮',
  ),
  const EmergencyContact(
    name: 'Medical Emergency',
    number: '110',
    emoji: '🏥',
  ),
];
