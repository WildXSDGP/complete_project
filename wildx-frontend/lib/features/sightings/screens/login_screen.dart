import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/login_header.dart';
import '../widgets/auth_tab_bar.dart';
import '../widgets/google_button.dart';
import '../widgets/or_divider.dart';
import '../widgets/terms_text.dart';
import 'login_tab.dart';
import 'signup_tab.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {

  int _tab = 0;
  bool _isGoogleLoading = false;

  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogle() async {
    setState(() => _isGoogleLoading = true);
    final result = await _authService.signInWithGoogle();
    setState(() => _isGoogleLoading = false);
    if (!mounted) return;
    result.isSuccess
        ? _snack('🎉 Welcome to WildX!', isError: false)
        : _snack(result.errorMessage ?? 'Google sign in failed.');
  }

  void _snack(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            isError ? const Color(0xFFE05A2B) : const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF0F7EC),
              Color(0xFFEAF4E5),
              Color(0xFFF5F9F2),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // ── Logo + Title ───────────────────────
                    const LoginHeader(),
                    const SizedBox(height: 32),

                    // ── Login / Sign Up Tabs ───────────────
                    AuthTabBar(
                      selectedTab: _tab,
                      onTabChanged: (t) => setState(() => _tab = t),
                    ),
                    const SizedBox(height: 28),

                    // ── Tab Content ────────────────────────
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, anim) =>
                          FadeTransition(opacity: anim, child: child),
                      child: _tab == 0
                          ? LoginTab(
                              key: const ValueKey('login'),
                              showSnackBar: _snack,
                            )
                          : SignUpTab(
                              key: const ValueKey('signup'),
                              showSnackBar: _snack,
                            ),
                    ),

                    const SizedBox(height: 24),

                    // ── OR + Google ────────────────────────
                    const OrDivider(),
                    const SizedBox(height: 20),
                    GoogleButton(
                      isLoading: _isGoogleLoading,
                      onPressed: _handleGoogle,
                    ),

                    const SizedBox(height: 24),

                    // ── Terms ──────────────────────────────
                    const TermsText(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
