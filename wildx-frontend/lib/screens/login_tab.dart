import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/input_card.dart';
import '../widgets/password_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/otp_card.dart';
import '../widgets/email_sent_card.dart';

class LoginTab extends StatefulWidget {
  final void Function(String msg, {bool isError}) showSnackBar;

  const LoginTab({super.key, required this.showSnackBar});

  @override
  State<LoginTab> createState() => _LoginTabState();
}

class _LoginTabState extends State<LoginTab> {
  final _inputCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _otpCtrl      = TextEditingController();

  bool _isLoading         = false;
  bool _otpSent           = false;
  bool _emailLinkSent     = false;
  bool _showPasswordField = false;
  String? _verificationId;
  String? _sentEmail;

  final _auth = AuthService();

  @override
  void dispose() {
    _inputCtrl.dispose();
    _passwordCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  String get _input  => _inputCtrl.text.trim();
  bool get _isPhone  => _auth.isPhone(_input);
  bool get _isEmail  => _auth.isEmail(_input);

  bool get _canContinue =>
      _input.isNotEmpty &&
      (_isPhone || _isEmail) &&
      (!_showPasswordField || _passwordCtrl.text.isNotEmpty);

  String get _buttonLabel {
    if (_otpSent) return 'Verify OTP';
    if (_showPasswordField) return 'Login';
    if (_isPhone) return 'Send OTP';
    return 'Continue';
  }

  // ── Continue ───────────────────────────────────────────────
  Future<void> _handleContinue() async {
    if (_isPhone) {
      _otpSent ? await _verifyOtp() : await _sendOtp();
    } else if (_isEmail) {
      if (!_showPasswordField) {
        setState(() => _showPasswordField = true);
      } else {
        await _loginWithEmail();
      }
    }
  }

  Future<void> _sendOtp() async {
    setState(() => _isLoading = true);
    await _auth.sendPhoneOtp(
      phoneNumber: _input,
      onCodeSent: (id) {
        setState(() { _isLoading = false; _otpSent = true; _verificationId = id; });
        widget.showSnackBar('📱 OTP sent to $_input', isError: false);
      },
      onFailed: (e) {
        setState(() => _isLoading = false);
        widget.showSnackBar(e);
      },
      onAutoVerified: (PhoneAuthCredential cred) async {
        await FirebaseAuth.instance.signInWithCredential(cred);
        if (mounted) {
          setState(() => _isLoading = false);
          widget.showSnackBar('🎉 Phone verified!', isError: false);
        }
      },
    );
  }

  Future<void> _verifyOtp() async {
    if (_verificationId == null) return;
    setState(() => _isLoading = true);
    final result = await _auth.verifyPhoneOtp(
      verificationId: _verificationId!,
      smsCode: _otpCtrl.text.trim(),
    );
    setState(() => _isLoading = false);
    if (!mounted) return;
    result.isSuccess
        ? widget.showSnackBar('🎉 Welcome to WildX!', isError: false)
        : widget.showSnackBar(result.errorMessage ?? 'OTP failed.');
  }

  Future<void> _loginWithEmail() async {
    setState(() => _isLoading = true);
    final result = await _auth.loginWithEmail(_input, _passwordCtrl.text);
    setState(() => _isLoading = false);
    if (!mounted) return;
    result.isSuccess
        ? widget.showSnackBar('🎉 Welcome back to WildX!', isError: false)
        : widget.showSnackBar(result.errorMessage ?? 'Login failed.');
  }

  Future<void> _forgotPassword() async {
    if (_input.isEmpty) { widget.showSnackBar('Enter your email first.'); return; }
    final result = await _auth.sendEmailLink(_input);
    if (!mounted) return;
    if (result.isEmailSent) {
      setState(() { _emailLinkSent = true; _sentEmail = result.email; });
    } else {
      widget.showSnackBar(result.errorMessage ?? 'Failed to send reset email.');
    }
  }

  void _reset() => setState(() {
    _inputCtrl.clear(); _passwordCtrl.clear(); _otpCtrl.clear();
    _otpSent = false; _emailLinkSent = false; _showPasswordField = false;
    _verificationId = null; _sentEmail = null;
  });

  @override
  Widget build(BuildContext context) {
    // Email link sent confirmation
    if (_emailLinkSent) {
      return EmailSentCard(key: const ValueKey('sent'), email: _sentEmail ?? '', onBack: _reset);
    }

    // OTP entry screen
    if (_otpSent) {
      return OtpCard(
        key: const ValueKey('otp'),
        controller: _otpCtrl,
        phone: _input,
        isLoading: _isLoading,
        onChanged: () => setState(() {}),
        onVerify: _verifyOtp,
        onBack: () => setState(() { _otpSent = false; _verificationId = null; _otpCtrl.clear(); }),
      );
    }

    // Default login form
    return Column(
      key: const ValueKey('login_form'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Phone or Email input
        InputCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputLabel(
                label: _input.isEmpty ? 'Phone Number or Email'
                    : _isPhone ? 'Phone Number' : 'Email Address',
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(_isPhone ? Icons.phone_rounded : Icons.mail_outline_rounded,
                      size: 18, color: Colors.grey[400]),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _inputCtrl,
                      onChanged: (_) => setState(() => _showPasswordField = false),
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF1A1A1A)),
                      decoration: InputDecoration(
                        hintText: '+94 77 123 4567  or  you@email.com',
                        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                        border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  if (_input.isNotEmpty)
                    GestureDetector(
                      onTap: () => setState(() { _inputCtrl.clear(); _showPasswordField = false; _passwordCtrl.clear(); }),
                      child: Icon(Icons.close_rounded, size: 18, color: Colors.grey[400]),
                    ),
                ],
              ),
            ],
          ),
        ),

        // Hint
        if (_input.isNotEmpty && (_isPhone || _isEmail) && !_showPasswordField) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(_isPhone ? Icons.sms_rounded : Icons.email_rounded, size: 13, color: const Color(0xFF4CAF50)),
              const SizedBox(width: 6),
              Text(
                _isPhone ? 'SMS OTP will be sent' : 'Enter your password to login',
                style: const TextStyle(fontSize: 12, color: Color(0xFF4CAF50)),
              ),
            ],
          ),
        ],

        // Password + Forgot
        if (_showPasswordField && _isEmail) ...[
          const SizedBox(height: 14),
          PasswordField(controller: _passwordCtrl, label: 'Password', onChanged: () => setState(() {})),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _forgotPassword,
              child: const Text('Forgot Password?',
                  style: TextStyle(color: Color(0xFF4CAF50), fontWeight: FontWeight.w600, fontSize: 13)),
            ),
          ),
        ],

        if (!_showPasswordField) const SizedBox(height: 20),

        PrimaryButton(
          label: _buttonLabel,
          isActive: _canContinue,
          isLoading: _isLoading,
          onPressed: _handleContinue,
        ),
      ],
    );
  }
}
