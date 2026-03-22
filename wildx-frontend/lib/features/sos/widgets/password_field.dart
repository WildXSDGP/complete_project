import 'package:flutter/material.dart';
import 'input_card.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final VoidCallback onChanged;

  const PasswordField({super.key, required this.controller, required this.label, required this.onChanged});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return InputCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputLabel(label: widget.label),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.lock_outline_rounded, size: 18, color: Colors.grey[400]),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  onChanged: (_) => widget.onChanged(),
                  obscureText: _obscure,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF1A1A1A)),
                  decoration: InputDecoration(
                    hintText: '••••••••',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _obscure = !_obscure),
                child: Icon(
                  _obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                  size: 18, color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
