import 'package:flutter/material.dart';
import 'primary_button.dart';

class OtpCard extends StatelessWidget {
  final TextEditingController controller;
  final String phone;
  final bool isLoading;
  final VoidCallback onChanged;
  final VoidCallback onVerify;
  final VoidCallback onBack;

  const OtpCard({
    super.key,
    required this.controller,
    required this.phone,
    required this.isLoading,
    required this.onChanged,
    required this.onVerify,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 14, offset: const Offset(0, 4))],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: onBack,
                    child: const Icon(Icons.arrow_back_rounded, size: 20, color: Color(0xFF4CAF50)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text('OTP sent to $phone',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text('Enter 6-digit OTP',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.lock_outline_rounded, size: 18, color: Colors.grey[400]),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onChanged: (_) => onChanged(),
                      keyboardType: TextInputType.number,
                      maxLength: 6, autofocus: true,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: 14, color: Color(0xFF1A1A1A)),
                      decoration: InputDecoration(
                        hintText: '------',
                        hintStyle: TextStyle(color: Colors.grey[300], letterSpacing: 14, fontSize: 28),
                        border: InputBorder.none, isDense: true, counterText: '', contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        PrimaryButton(
          label: 'Verify OTP',
          isActive: controller.text.length == 6,
          isLoading: isLoading,
          onPressed: onVerify,
        ),
      ],
    );
  }
}
