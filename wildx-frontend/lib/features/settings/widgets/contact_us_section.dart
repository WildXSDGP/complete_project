import 'package:flutter/material.dart';
import '../data/about_data.dart';
import 'section_card.dart';

class ContactUsSection extends StatelessWidget {
  const ContactUsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with a soft blue icon to signal communication/support
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD), // Subtle blue background
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.email_outlined,
                  color: Color(0xFF1E88E5),
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Mapping contact data to a uniform row structure
          const _ContactRow(label: 'Email:', value: contactEmail),
          const SizedBox(height: 8),
          const _ContactRow(label: 'Website:', value: contactWebsite),
          const SizedBox(height: 8),
          const _ContactRow(label: 'Emergency:', value: contactEmergency),
        ],
      ),
    );
  }
}

/// A private helper widget to ensure label-value alignment across contact items
class _ContactRow extends StatelessWidget {
  final String label;
  final String value;

  const _ContactRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fixed width for labels ensures consistent vertical alignment of values
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13.5,
              color: Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }
}