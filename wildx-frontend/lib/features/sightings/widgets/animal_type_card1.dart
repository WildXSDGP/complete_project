import 'package:flutter/material.dart';
import '../models/animal_type1.dart';

class AnimalTypeCard extends StatefulWidget {
  final AnimalType animal;
  final bool isSelected;
  final VoidCallback onTap;

  const AnimalTypeCard({
    super.key,
    required this.animal,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<AnimalTypeCard> createState() => _AnimalTypeCardState();
}

class _AnimalTypeCardState extends State<AnimalTypeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.95,
      upperBound: 1.0,
    )..value = 1.0;
    _scaleAnimation = _controller;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _controller.reverse();
  void _onTapUp(_) {
    _controller.forward();
    widget.onTap();
  }
  void _onTapCancel() => _controller.forward();

  @override
  Widget build(BuildContext context) {
    final selected = widget.isSelected;
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFF2E7D32).withOpacity(0.08)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? const Color(0xFF2E7D32)
                  : const Color(0xFFE0E0E0),
              width: selected ? 2 : 1,
            ),
            boxShadow: selected
                ? [BoxShadow(
                    color: const Color(0xFF2E7D32).withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )]
                : [BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  )],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.animal.emoji,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 6),
              Text(
                widget.animal.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected
                      ? const Color(0xFF2E7D32)
                      : const Color(0xFF424242),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}