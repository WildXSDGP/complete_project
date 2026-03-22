import 'package:flutter/material.dart';
import 'dart:async';
import 'package:wildx_frontend/features/auth/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    Timer(const Duration(seconds: 3), () {
      // Assuming you want to navigate to the LoginScreen
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (_, __, ___) => const LoginScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/images/Sri Lankan Leopard.jpg.jpeg',
            fit: BoxFit.cover,
          ),
          // Green Tint Overlay
          Container(
            color: const Color(0xFF1B5E20).withOpacity(0.75),
          ),
          
          // Center Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lion Icon Box
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    '🦁',
                    style: TextStyle(fontSize: 56),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // App Title
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Wild',
                      style: TextStyle(
                        fontFamily: 'Segoe UI', // General sans-serif fallback
                        fontSize: 46,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    TextSpan(
                      text: 'X',
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 46,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFFF8A65), // Orange shade from the image
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              
              // Subtitle
              const Text(
                'Explore. Discover. Protect.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 32),
              
              // Loading Dots Animation
              AnimatedBuilder(
                animation: _animController,
                builder: (context, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDot(0),
                      const SizedBox(width: 8),
                      _buildDot(1),
                      const SizedBox(width: 8),
                      _buildDot(2),
                    ],
                  );
                },
              ),
            ],
          ),
          
          // Bottom Footer Text
          const Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Sri Lanka Wildlife Explorer',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    // A simple sine wave to animate dots
    // index 0 -> 0-0.33, index 1 -> 0.33-0.66, index 2 -> 0.66-1.0
    final value = _animController.value;
    double opacity = 0.4;
    
    // Create a wave effect across the 3 dots
    double delay = index * 0.2;
    double adjValue = (value + delay) % 1.0;
    
    if (adjValue > 0.5) {
      opacity = 1.0 - (adjValue - 0.5) * 2;
    } else {
      opacity = adjValue * 2;
    }
    
    // Map opacity to 0.4 -> 1.0 range
    opacity = 0.4 + (opacity * 0.6);

    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(opacity),
        shape: BoxShape.circle,
      ),
    );
  }
}
