import 'animal_type1.dart';
import 'location_info1.dart';

enum ReportStatus { draft, submitted, verified, rejected }

class SightingReport {
  final String id;
  final AnimalType animalType;
  final String? photoPath;
  final LocationInfo location;
  final String? notes;
  final DateTime reportedAt;
  final ReportStatus status;

  const SightingReport({
    required this.id,
    required this.animalType,
    this.photoPath,
    required this.location,
    this.notes,
    required this.reportedAt,
    this.status = ReportStatus.draft,
  });

  SightingReport copyWith({
    AnimalType? animalType,
    String? photoPath,
    LocationInfo? location,
    String? notes,
    DateTime? reportedAt,
    ReportStatus? status,
  }) {
    return SightingReport(
      id: id,
      animalType: animalType ?? this.animalType,
      photoPath: photoPath ?? this.photoPath,
      location: location ?? this.location,
      notes: notes ?? this.notes,
      reportedAt: reportedAt ?? this.reportedAt,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'animalType': animalType.name,
    'photoPath': photoPath,
    'locationName': location.name,
    'latitude': location.latitude,
    'longitude': location.longitude,
    'notes': notes,
    'reportedAt': reportedAt.toIso8601String(),
    'status': status.name,
  };
}