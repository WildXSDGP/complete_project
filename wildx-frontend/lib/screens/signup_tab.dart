import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/input_card.dart';
import '../widgets/password_field.dart';
import '../widgets/primary_button.dart';

class SignUpTab extends StatefulWidget {
  final void Function(String msg, {bool isError}) showSnackBar;

  const SignUpTab({super.key, required this.showSnackBar});

  @override
  State<SignUpTab> createState() => _SignUpTabState();
}

class _SignUpTabState extends State<SignUpTab> {
  final _emailCtrl   = TextEditingController();
  final _passCtrl    = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _isLoading = false;

  final _auth = AuthService();

  @override
  void dispose() {
    _emailCtrl.dispose(); _passCtrl.dispose(); _confirmCtrl.dispose();
    super.dispose();
  }

  bool get _canSignUp =>
      _emailCtrl.text.isNotEmpty &&
      _passCtrl.text.isNotEmpty &&
      _confirmCtrl.text.isNotEmpty;

  Future<void> _handleSignUp() async {
    if (_passCtrl.text != _confirmCtrl.text) {
      widget.showSnackBar('Passwords do not match!'); return;
    }
    setState(() => _isLoading = true);
    final result = await _auth.registerWithEmail(_emailCtrl.text, _passCtrl.text);
    setState(() => _isLoading = false);
    if (!mounted) return;
    result.isSuccess
        ? widget.showSnackBar('🎉 Account created! Welcome to WildX!', isError: false)
        : widget.showSnackBar(result.errorMessage ?? 'Registration failed.');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('signup_form'),
      children: [
        // Email
        InputCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const InputLabel(label: 'Email Address'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.mail_outline_rounded, size: 18, color: Colors.grey[400]),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _emailCtrl,
                      onChanged: (_) => setState(() {}),
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF1A1A1A)),
                      decoration: InputDecoration(
                        hintText: 'you@example.com',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        PasswordField(controller: _passCtrl, label: 'Password', onChanged: () => setState(() {})),
        const SizedBox(height: 14),
        PasswordField(controller: _confirmCtrl, label: 'Confirm Password', onChanged: () => setState(() {})),
        const SizedBox(height: 20),
        PrimaryButton(
          label: 'Create Account',
          isActive: _canSignUp,
          isLoading: _isLoading,
          onPressed: _handleSignUp,
        ),
      ],
    );
  }
}
