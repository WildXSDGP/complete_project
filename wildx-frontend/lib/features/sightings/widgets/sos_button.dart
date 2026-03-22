import 'dart:async';
import 'package:flutter/material.dart';

class SOSButton extends StatefulWidget {
  final VoidCallback onSOSActivated;

  const SOSButton({super.key, required this.onSOSActivated});

  @override
  State<SOSButton> createState() => _SOSButtonState();
}

class _SOSButtonState extends State<SOSButton>
    with SingleTickerProviderStateMixin {
  static const int _holdDurationSeconds = 3;

  Timer? _holdTimer;
  double _progress = 0.0;
  bool _isHolding = false;
  bool _activated = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startHold() {
    if (_activated) return;
    setState(() {
      _isHolding = true;
      _progress = 0.0;
    });

    const tickMs = 50;
    const totalTicks = (_holdDurationSeconds * 1000) / tickMs;
    int ticks = 0;

    _holdTimer = Timer.periodic(const Duration(milliseconds: tickMs), (timer) {
      ticks++;
      setState(() => _progress = ticks / totalTicks);

      if (ticks >= totalTicks) {
        timer.cancel();
        setState(() {
          _activated = true;
          _isHolding = false;
        });
        widget.onSOSActivated();

        // Reset after 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) setState(() => _activated = false);
        });
      }
    });
  }

  void _stopHold() {
    _holdTimer?.cancel();
    if (!_activated) {
      setState(() {
        _isHolding = false;
        _progress = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTapDown: (_) => _startHold(),
          onTapUp: (_) => _stopHold(),
          onTapCancel: _stopHold,
          child: AnimatedBuilder(
            animation: _pulseAnim,
            builder: (context, child) {
              return Transform.scale(
                scale: _isHolding ? 1.0 : _pulseAnim.value,
                child: child,
              );
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer glow ring
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.withOpacity(0.15),
                  ),
                ),
                // Progress ring
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: _progress,
                    strokeWidth: 4,
                    color: Colors.white,
                    backgroundColor: Colors.red.shade700,
                  ),
                ),
                // Main SOS circle
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: _activated
                          ? [Colors.orange.shade400, Colors.red.shade800]
                          : [Colors.red.shade400, Colors.red.shade700],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.5),
                        blurRadius: _isHolding ? 30 : 15,
                        spreadRadius: _isHolding ? 8 : 3,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _activated ? Icons.check : Icons.phone,
                        color: Colors.white,
                        size: 36,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _activated ? 'SENT!' : 'SOS',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        _activated ? 'Help is coming' : 'Emergency',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: TextStyle(
            color: _isHolding ? Colors.red.shade700 : Colors.grey.shade600,
            fontSize: 13,
            fontWeight: _isHolding ? FontWeight.w600 : FontWeight.normal,
          ),
          child: Text(
            _isHolding
                ? 'Hold... ${((_holdDurationSeconds * (1 - _progress)).ceil())}s'
                : 'Press and hold for 3 seconds to activate emergency alert',
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
