import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../models/booking.dart';

class BookingConfirmationScreen extends StatelessWidget {
  const BookingConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final booking =
        ModalRoute.of(context)!.settings.arguments as Booking;

    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kSpaceXXL),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // ── Success icon ──
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: kGreenSoft,
                  shape: BoxShape.circle,
                  border: Border.all(color: kGreenLight, width: 3),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 52,
                  color: kGreen,
                ),
              ),
              const SizedBox(height: kSpaceXXL),

              // ── Title ──
              const Text(
                'Booking Confirmed!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: kGreen,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: kSpaceSM),
              const Text(
                'Your reservation has been placed successfully.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: kTextSecondary,
                ),
              ),

              const Spacer(),

              // ── Booking details card ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(kSpaceXL),
                decoration: BoxDecoration(
                  color: kGreenSoft,
                  borderRadius: BorderRadius.circular(kRadiusLG),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Booking Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: kTextPrimary,
                      ),
                    ),
                    const SizedBox(height: kSpaceLG),
                    _DetailRow(
                      icon: Icons.confirmation_number_outlined,
                      label: 'Booking ID',
                      value: booking.bookingId,
                    ),
                    const SizedBox(height: kSpaceMD),
                    _DetailRow(
                      icon: Icons.calendar_today_rounded,
                      label: 'Check-in',
                      value: _formatDate(booking.checkInDate),
                    ),
                    const SizedBox(height: kSpaceMD),
                    _DetailRow(
                      icon: Icons.calendar_today_rounded,
                      label: 'Check-out',
                      value: _formatDate(booking.checkOutDate),
                    ),
                    const SizedBox(height: kSpaceMD),
                    _DetailRow(
                      icon: Icons.nightlight_round,
                      label: 'Nights',
                      value: '${booking.nights}',
                    ),
                    const SizedBox(height: kSpaceMD),
                    _DetailRow(
                      icon: Icons.people_outline_rounded,
                      label: 'Guests',
                      value: '${booking.guests}',
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: kSpaceLG),
                      child: Divider(height: 1, color: kGreenLight),
                    ),
                    _DetailRow(
                      icon: Icons.payments_outlined,
                      label: 'Total',
                      value: 'LKR ${booking.totalPrice.toStringAsFixed(0)}',
                      isBold: true,
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // ── Actions ──
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.of(context).popUntil((r) => r.isFirst),
                  child: const Text('Back to Home'),
                ),
              ),
              const SizedBox(height: kSpaceMD),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('View Booking'),
                ),
              ),
              const SizedBox(height: kSpaceXXL),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${weekdays[d.weekday - 1]}, ${d.day} ${months[d.month - 1]} ${d.year}';
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isBold;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: kGreen),
        const SizedBox(width: 10),
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isBold ? kTextPrimary : kTextSecondary,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: isBold ? 16 : 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: isBold ? kGreen : kTextPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
