import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../models/booking.dart';
import '../services/booking_service.dart';
import '../routes/app_routes.dart';
import 'package:intl/intl.dart';
import '../models/accommodation.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? _checkIn;
  DateTime? _checkOut;
  int _adults = 1;
  int _children = 0;

  int get _totalGuests => _adults + _children;

  int get _nights {
    if (_checkIn == null || _checkOut == null) return 0;
    return _checkOut!.difference(_checkIn!).inDays;
  }

  // Children are charged at half rate
  static const double _childRate = 0.5;
  static const double _serviceFeePercent = 0.05;

  double get _accommodationCost {
    if (_nights <= 0) return 0;
    final adultCost = _pricePerNight * _adults * _nights;
    final childCost = _pricePerNight * _childRate * _children * _nights;
    return adultCost + childCost;
  }

  double get _serviceFee => _accommodationCost * _serviceFeePercent;

  double get _totalPrice => _accommodationCost + _serviceFee;

  // Cached from build; set once per frame via the build method.
  double _pricePerNight = 0;

  /// Opens a date-range picker so the user selects both check-in and
  /// check-out in a single interaction.
  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastDate = today.add(const Duration(days: 365));

    final range = await showDateRangePicker(
      context: context,
      firstDate: today,
      lastDate: lastDate,
      initialDateRange: (_checkIn != null && _checkOut != null)
          ? DateTimeRange(start: _checkIn!, end: _checkOut!)
          : null,
      currentDate: today,
      saveText: 'CONFIRM',
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: kGreen,
            onPrimary: Colors.white,
            secondary: kGreenLight,
            onSecondary: Colors.white,
            surface: Colors.white,
            onSurface: Colors.black87,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: kGreen),
          ),
        ),
        child: child!,
      ),
    );

    if (range == null) return;
    setState(() {
      _checkIn = range.start;
      _checkOut = range.end;
    });
  }

  /// Opens a single-date picker for adjusting only check-in or check-out.
  Future<void> _pickSingleDate({required bool isCheckIn}) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastDate = today.add(const Duration(days: 365));

    final DateTime firstAllowed;
    final DateTime initial;

    if (isCheckIn) {
      firstAllowed = today;
      initial = _checkIn ?? today;
    } else {
      firstAllowed = (_checkIn ?? today).add(const Duration(days: 1));
      initial = _checkOut ?? firstAllowed;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(firstAllowed) ? firstAllowed : initial,
      firstDate: firstAllowed,
      lastDate: lastDate,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: kGreen,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: Colors.black87,
          ),
        ),
        child: child!,
      ),
    );

    if (picked == null) return;
    setState(() {
      if (isCheckIn) {
        _checkIn = picked;
        if (_checkOut != null && !_checkOut!.isAfter(picked)) {
          _checkOut = null;
        }
      } else {
        _checkOut = picked;
      }
    });
  }

  void _clearDates() => setState(() {
        _checkIn = null;
        _checkOut = null;
      });

  void _showBookingSummary(Accommodation accommodation) {
    showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _BookingSummarySheet(
        accommodation: accommodation,
        checkIn: _checkIn!,
        checkOut: _checkOut!,
        nights: _nights,
        adults: _adults,
        children: _children,
        accommodationCost: _accommodationCost,
        serviceFee: _serviceFee,
        total: _totalPrice,
      ),
    ).then((confirmed) async {
      if (confirmed == true && mounted) {
        // Save to backend
        try {
          await BookingService.createBooking(
            accommodationId: accommodation.id,
            checkInDate: DateFormat('yyyy-MM-dd').format(_checkIn!),
            checkOutDate: DateFormat('yyyy-MM-dd').format(_checkOut!),
            guests: _adults + _children,
            totalPrice: _totalPrice,
          );
        } catch (_) {}

        if (mounted) {
          final booking = Booking(
            bookingId: 'bk_${DateTime.now().millisecondsSinceEpoch}',
            accommodationId: accommodation.id,
            checkInDate: _checkIn!,
            checkOutDate: _checkOut!,
            guests: _adults + _children,
            totalPrice: _totalPrice,
          );
          Navigator.pushNamed(
            context,
            AppRoutes.bookingConfirmation,
            arguments: booking,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final accommodation =
        ModalRoute.of(context)!.settings.arguments as Accommodation;
    _pricePerNight = accommodation.pricePerNight;

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kGreen,
        foregroundColor: Colors.white,
        title: const Text(
          'Book Accommodation',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: -0.3),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(kSpaceXL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: kSpaceXL),
                  _AccommodationHeader(accommodation: accommodation),
                  const SizedBox(height: kSpaceXL),
                  _SectionCard(
                    title: 'Select Dates',
                    icon: Icons.date_range_outlined,
                    trailing: _checkIn != null || _checkOut != null
                        ? GestureDetector(
                            onTap: _clearDates,
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.clear_rounded,
                                    size: 14, color: kTextHint),
                                SizedBox(width: 2),
                                Text('Clear',
                                    style: TextStyle(
                                        fontSize: 12, color: kTextHint)),
                              ],
                            ),
                          )
                        : null,
                    child: Column(
                      children: [
                        // Tap either field to adjust individually
                        _DateField(
                          label: 'Check-in',
                          icon: Icons.login_rounded,
                          date: _checkIn,
                          hint: 'Select check-in date',
                          onTap: () => _pickSingleDate(isCheckIn: true),
                        ),
                        // Nights indicator
                        if (_nights > 0)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                const Expanded(child: Divider(color: kGreenSoft)),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: kGreenSoft,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '$_nights ${_nights == 1 ? 'night' : 'nights'}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: kGreen,
                                    ),
                                  ),
                                ),
                                const Expanded(child: Divider(color: kGreenSoft)),
                              ],
                            ),
                          )
                        else
                          const SizedBox(height: 12),
                        _DateField(
                          label: 'Check-out',
                          icon: Icons.logout_rounded,
                          date: _checkOut,
                          hint: _checkIn == null
                              ? 'Pick check-in first'
                              : 'Select check-out date',
                          enabled: _checkIn != null,
                          onTap: _checkIn != null
                              ? () => _pickSingleDate(isCheckIn: false)
                              : () {},
                        ),
                        const SizedBox(height: 12),
                        // Full range picker shortcut
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: kGreen,
                              side: const BorderSide(color: kGreenLight),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: _pickDateRange,
                            icon: const Icon(
                                Icons.calendar_month_outlined, size: 18),
                            label: Text(
                              _checkIn != null && _checkOut != null
                                  ? 'Change date range'
                                  : 'Pick date range',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: kSpaceLG),
                  _SectionCard(
                    title: 'Guests',
                    icon: Icons.people_outline_rounded,
                    trailing: _totalGuests > 0
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: kGreenSoft,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$_totalGuests total',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: kGreen,
                              ),
                            ),
                          )
                        : null,
                    child: _GuestSelector(
                      adults: _adults,
                      children: _children,
                      onAdultsChanged: (v) => setState(() => _adults = v),
                      onChildrenChanged: (v) => setState(() => _children = v),
                    ),
                  ),
                  const SizedBox(height: kSpaceLG),
                  _PriceSummary(
                    pricePerNight: accommodation.pricePerNight,
                    nights: _nights,
                    adults: _adults,
                    children: _children,
                    childRate: _childRate,
                    accommodationCost: _accommodationCost,
                    serviceFeePercent: _serviceFeePercent,
                    serviceFee: _serviceFee,
                    total: _totalPrice,
                  ),
                ],
              ),
            ),
          ),
          _BookingFooter(
            isEnabled: _nights > 0,
            total: _totalPrice,
            onConfirm: () => _showBookingSummary(accommodation),
          ),
        ],
      ),
    );
  }
}

// â”€â”€ Accommodation header card â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _AccommodationHeader extends StatelessWidget {
  final Accommodation accommodation;

  const _AccommodationHeader({required this.accommodation});

  @override
  Widget build(BuildContext context) {
    final imageUrl = accommodation.imageUrl;
    final isAsset = imageUrl.startsWith('assets/');

    return Container(
      decoration: BoxDecoration(
        color: kCardBackground,
        borderRadius: BorderRadius.circular(kRadiusLG),
        boxShadow: const [
          BoxShadow(
            color: kShadowColor,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(kRadiusLG)),
            child: isAsset
                ? Image.asset(
                    imageUrl,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, _) => Container(
                      height: 160,
                      color: kGreenSoft,
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 48,
                        color: kGreen,
                      ),
                    ),
                  )
                : Image.network(
                    imageUrl,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, _) => Container(
                      height: 160,
                      color: kGreenSoft,
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 48,
                        color: kGreen,
                      ),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(kSpaceLG),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  accommodation.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: kTextPrimary,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: kSpaceXS),
                Row(
                  children: [
                    const Icon(Icons.park_outlined,
                        size: 14, color: kGreenLight),
                    const SizedBox(width: kSpaceXS),
                    Text(
                      accommodation.parkName,
                      style: const TextStyle(
                          fontSize: 13, color: kTextSecondary),
                    ),
                    const Spacer(),
                    const Icon(Icons.star_rounded, size: 14, color: kAmber),
                    const SizedBox(width: 2),
                    Text(
                      '${accommodation.rating}',
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: kTextPrimary),
                    ),
                  ],
                ),
                const SizedBox(height: kSpaceSM),
                Row(
                  children: [
                    Text(
                      'LKR ${accommodation.pricePerNight.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kGreen,
                      ),
                    ),
                    const Text(
                      ' / night',
                      style: TextStyle(fontSize: 13, color: kTextHint),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// â”€â”€ Generic section card â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final Widget? trailing;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(kSpaceLG),
      decoration: BoxDecoration(
        color: kCardBackground,
        borderRadius: BorderRadius.circular(kRadiusLG),
        boxShadow: const [
          BoxShadow(
            color: kShadowColor,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: kGreen),
              const SizedBox(width: kSpaceSM),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: kTextPrimary,
                ),
              ),
              if (trailing != null) ...[
                const Spacer(),
                trailing!,
              ],
            ],
          ),
          const SizedBox(height: kSpaceLG),
          child,
        ],
      ),
    );
  }
}

// â”€â”€ Date selection field â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _DateField extends StatelessWidget {
  final String label;
  final IconData icon;
  final DateTime? date;
  final String hint;
  final bool enabled;
  final VoidCallback onTap;

  const _DateField({
    required this.label,
    required this.icon,
    required this.date,
    required this.onTap,
    this.hint = 'Select date',
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final hasDate = date != null;
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: enabled ? kGreenSoft : kSand,
          borderRadius: BorderRadius.circular(kRadiusMD),
          border: Border.all(
            color: hasDate
                ? kGreen
                : enabled
                    ? kGreenLight.withValues(alpha: 0.4)
                    : kDividerColor,
            width: hasDate ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 18,
                color: enabled ? kGreen : kTextHint),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: enabled ? kTextHint : kTextHint,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  hasDate ? _formatDate(date!) : hint,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: hasDate
                        ? kTextPrimary
                        : enabled
                            ? kTextHint
                            : kTextHint,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Icon(
              Icons.calendar_today_rounded,
              size: 16,
              color: enabled
                  ? kGreen.withValues(alpha: 0.6)
                  : kDividerColor,
            ),
          ],
        ),
      ),
    );
  }

  static String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${weekdays[d.weekday - 1]}, ${d.day} ${months[d.month - 1]} ${d.year}';
  }
}

// â”€â”€ Guest selector (adults + children) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _GuestSelector extends StatelessWidget {
  final int adults;
  final int children;
  final ValueChanged<int> onAdultsChanged;
  final ValueChanged<int> onChildrenChanged;

  static const int _maxGuests = 20;

  const _GuestSelector({
    required this.adults,
    required this.children,
    required this.onAdultsChanged,
    required this.onChildrenChanged,
  });

  int get _total => adults + children;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _GuestRow(
          icon: Icons.person_outline_rounded,
          label: 'Adults',
          subtitle: 'Age 13+',
          value: adults,
          onDecrement: adults > 1 ? () => onAdultsChanged(adults - 1) : null,
          onIncrement:
              _total < _maxGuests ? () => onAdultsChanged(adults + 1) : null,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(height: 1, color: kDividerColor),
        ),
        _GuestRow(
          icon: Icons.child_care_rounded,
          label: 'Children',
          subtitle: 'Age 0 â€“ 12',
          value: children,
          onDecrement:
              children > 0 ? () => onChildrenChanged(children - 1) : null,
          onIncrement: _total < _maxGuests
              ? () => onChildrenChanged(children + 1)
              : null,
        ),
        if (_total >= _maxGuests)
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, size: 14, color: kTextHint),
                SizedBox(width: 6),
                Text(
                  'Maximum of 20 guests reached',
                  style: TextStyle(fontSize: 12, color: kTextHint),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _GuestRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final int value;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;

  const _GuestRow({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: kGreen),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: kTextPrimary,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: kTextHint),
            ),
          ],
        ),
        const Spacer(),
        _CounterButton(
          icon: Icons.remove,
          onTap: onDecrement,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: SizedBox(
            width: 24,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kGreen,
              ),
            ),
          ),
        ),
        _CounterButton(
          icon: Icons.add,
          onTap: onIncrement,
        ),
      ],
    );
  }
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _CounterButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: enabled ? kGreen : kGreenSoft,
          borderRadius: BorderRadius.circular(kRadiusSM),
        ),
        child: Icon(
          icon,
          size: 18,
          color: enabled ? Colors.white : kTextHint,
        ),
      ),
    );
  }
}

// â”€â”€ Price summary card â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _PriceSummary extends StatelessWidget {
  final double pricePerNight;
  final int nights;
  final int adults;
  final int children;
  final double childRate;
  final double accommodationCost;
  final double serviceFeePercent;
  final double serviceFee;
  final double total;

  const _PriceSummary({
    required this.pricePerNight,
    required this.nights,
    required this.adults,
    required this.children,
    required this.childRate,
    required this.accommodationCost,
    required this.serviceFeePercent,
    required this.serviceFee,
    required this.total,
  });

  bool get _hasDates => nights > 0;
  String _lkr(double v) => 'LKR ${v.toStringAsFixed(0)}';

  @override
  Widget build(BuildContext context) {
    final adultSubtotal = pricePerNight * adults * nights;
    final childSubtotal = pricePerNight * childRate * children * nights;

    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(kSpaceLG),
        decoration: BoxDecoration(
          color: kCardBackground,
          borderRadius: BorderRadius.circular(kRadiusLG),
          boxShadow: const [
            BoxShadow(
              color: kShadowColor,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.receipt_long_outlined, size: 18, color: kGreen),
                SizedBox(width: 8),
                Text(
                  'Price Summary',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: kTextPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // â”€â”€ Line items â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            if (_hasDates) ...[
              // Adults
              _PriceRow(
                label: '${_lkr(pricePerNight)} Ã— $adults '
                    '${adults == 1 ? 'adult' : 'adults'} Ã— $nights '
                    '${nights == 1 ? 'night' : 'nights'}',
                value: _lkr(adultSubtotal),
              ),
              // Children (shown only when present)
              if (children > 0) ...[
                const SizedBox(height: 6),
                _PriceRow(
                  label: '${_lkr(pricePerNight * childRate)} Ã— $children '
                      '${children == 1 ? 'child' : 'children'} Ã— $nights '
                      '${nights == 1 ? 'night' : 'nights'}',
                  value: _lkr(childSubtotal),
                ),
                const SizedBox(height: 2),
                const _PriceRow(
                  label: 'Children charged at 50% rate',
                  value: '',
                  isSubtle: true,
                ),
              ],
              const SizedBox(height: 6),
              // Service fee
              _PriceRow(
                label: 'Service fee (${(serviceFeePercent * 100).toStringAsFixed(0)}%)',
                value: _lkr(serviceFee),
              ),
            ] else ...[
              _PriceRow(
                label: '${_lkr(pricePerNight)} / night',
                value: 'â€”',
              ),
              const SizedBox(height: 6),
              _PriceRow(
                label: '$adults ${adults == 1 ? 'adult' : 'adults'}'
                    '${children > 0 ? ', $children ${children == 1 ? 'child' : 'children'}' : ''}',
                value: '',
                isSubtle: true,
              ),
            ],

            // â”€â”€ Divider â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1, color: kDividerColor),
            ),

            // â”€â”€ Total â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kTextPrimary,
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    _hasDates ? _lkr(total) : 'â€”',
                    key: ValueKey<String>(
                        _hasDates ? total.toStringAsFixed(0) : 'empty'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kGreen,
                    ),
                  ),
                ),
              ],
            ),
            if (!_hasDates) ...[
              const SizedBox(height: 8),
              const Text(
                'Select check-in and check-out dates to see the total price.',
                style: TextStyle(fontSize: 12, color: kTextHint),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isSubtle;

  const _PriceRow({
    required this.label,
    required this.value,
    this.isSubtle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isSubtle ? kTextHint : kTextSecondary,
          ),
        ),
        if (value.isNotEmpty)
          Text(
            value,
            style: const TextStyle(fontSize: 13, color: kTextPrimary),
          ),
      ],
    );
  }
}

// â”€â”€ Sticky booking footer â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _BookingFooter extends StatelessWidget {
  final bool isEnabled;
  final double total;
  final VoidCallback onConfirm;

  const _BookingFooter({
    required this.isEnabled,
    required this.total,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: kCardBackground,
        boxShadow: [
          BoxShadow(
            color: kShadowColor,
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: kSpaceXL, vertical: kSpaceLG),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEnabled
                        ? 'LKR ${total.toStringAsFixed(0)}'
                        : 'Select dates',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isEnabled ? kGreen : kTextHint,
                    ),
                  ),
                  const Text(
                    'total',
                    style: TextStyle(fontSize: 11, color: kTextHint),
                  ),
                ],
              ),
              const SizedBox(width: kSpaceLG),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isEnabled ? kGreen : kTextHint,
                    elevation: isEnabled ? 2 : 0,
                  ),
                  onPressed: isEnabled ? onConfirm : null,
                  child: const Text('Confirm Booking'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// â”€â”€ Helpers â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

String _formatDateShort(DateTime d) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return '${weekdays[d.weekday - 1]}, ${d.day} ${months[d.month - 1]} ${d.year}';
}

String _lkr(double v) => 'LKR ${v.toStringAsFixed(0)}';

// â”€â”€ Booking summary bottom sheet â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _BookingSummarySheet extends StatelessWidget {
  final Accommodation accommodation;
  final DateTime checkIn;
  final DateTime checkOut;
  final int nights;
  final int adults;
  final int children;
  final double accommodationCost;
  final double serviceFee;
  final double total;

  const _BookingSummarySheet({
    required this.accommodation,
    required this.checkIn,
    required this.checkOut,
    required this.nights,
    required this.adults,
    required this.children,
    required this.accommodationCost,
    required this.serviceFee,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final totalGuests = adults + children;

    return Container(
      decoration: const BoxDecoration(
        color: kCardBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(kRadiusXL)),
      ),
      padding: const EdgeInsets.fromLTRB(kSpaceXXL, kSpaceMD, kSpaceXXL, kSpaceXXL),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // â”€â”€ Drag handle â”€â”€
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: kDividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: kSpaceXL),

            // â”€â”€ Title â”€â”€
            const Row(
              children: [
                Icon(Icons.receipt_long_rounded, color: kGreen, size: 22),
                SizedBox(width: kSpaceSM),
                Text(
                  'Booking Summary',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kTextPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: kSpaceXL),

            // â”€â”€ Accommodation â”€â”€
            _SummaryRow(
              icon: Icons.hotel_rounded,
              label: 'Accommodation',
              value: accommodation.name,
            ),
            const SizedBox(height: 14),

            // â”€â”€ Location â”€â”€
            _SummaryRow(
              icon: Icons.location_on_outlined,
              label: 'Location',
              value: accommodation.parkName,
            ),
            const SizedBox(height: 14),

            // â”€â”€ Check-in / Check-out â”€â”€
            _SummaryRow(
              icon: Icons.calendar_today_rounded,
              label: 'Check-in',
              value: _formatDateShort(checkIn),
            ),
            const SizedBox(height: 8),
            _SummaryRow(
              icon: Icons.calendar_today_rounded,
              label: 'Check-out',
              value: '${_formatDateShort(checkOut)}  ($nights ${nights == 1 ? 'night' : 'nights'})',
            ),
            const SizedBox(height: 14),

            // â”€â”€ Guests â”€â”€
            _SummaryRow(
              icon: Icons.people_outline_rounded,
              label: 'Guests',
              value: children > 0
                  ? '$adults ${adults == 1 ? 'adult' : 'adults'}, $children ${children == 1 ? 'child' : 'children'} ($totalGuests total)'
                  : '$adults ${adults == 1 ? 'adult' : 'adults'}',
            ),
            const SizedBox(height: kSpaceXL),

            // â”€â”€ Price breakdown â”€â”€
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(kSpaceLG),
              decoration: BoxDecoration(
                color: kGreenSoft,
                borderRadius: BorderRadius.circular(kRadiusMD),
              ),
              child: Column(
                children: [
                  _SummaryPriceRow(
                    label: 'Accommodation ($nights ${nights == 1 ? 'night' : 'nights'})',
                    value: _lkr(accommodationCost),
                  ),
                  const SizedBox(height: 6),
                  _SummaryPriceRow(
                    label: 'Service fee',
                    value: _lkr(serviceFee),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(height: 1, color: kGreenLight),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: kTextPrimary,
                        ),
                      ),
                      Text(
                        _lkr(total),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kGreen,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: kSpaceXXL),

            // â”€â”€ Action buttons â”€â”€
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kTextSecondary,
                      side: const BorderSide(color: kDividerColor),
                    ),
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Go Back',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: kSpaceMD),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Confirm Booking'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: kGreen),
        const SizedBox(width: 10),
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: kTextHint),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: kTextPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryPriceRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryPriceRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: kTextSecondary)),
        Text(value, style: const TextStyle(fontSize: 13, color: kTextPrimary)),
      ],
    );
  }
}



