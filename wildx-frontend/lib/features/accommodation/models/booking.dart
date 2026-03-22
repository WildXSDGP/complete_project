class Booking {
  final String bookingId;
  final String accommodationId;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int guests;
  final double totalPrice;

  int get nights => checkOutDate.difference(checkInDate).inDays;

  const Booking({
    required this.bookingId,
    required this.accommodationId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.guests,
    required this.totalPrice,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      bookingId: json['bookingId'] as String,
      accommodationId: json['accommodationId'] as String,
      checkInDate: DateTime.parse(json['checkInDate'] as String),
      checkOutDate: DateTime.parse(json['checkOutDate'] as String),
      guests: json['guests'] as int,
      totalPrice: (json['totalPrice'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'accommodationId': accommodationId,
      'checkInDate': checkInDate.toIso8601String(),
      'checkOutDate': checkOutDate.toIso8601String(),
      'guests': guests,
      'totalPrice': totalPrice,
    };
  }

  Booking copyWith({
    String? bookingId,
    String? accommodationId,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    int? guests,
    double? totalPrice,
  }) {
    return Booking(
      bookingId: bookingId ?? this.bookingId,
      accommodationId: accommodationId ?? this.accommodationId,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      guests: guests ?? this.guests,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}
