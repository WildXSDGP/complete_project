import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/ranger_model.dart';
import '../theme/safari_theme.dart';

class EditRangerScreen extends StatefulWidget {
  final RangerModel ranger;
  final ValueChanged<RangerModel>? onSave;
  final bool popOnSave;
  final bool showBackButton;

  const EditRangerScreen({
    super.key,
    required this.ranger,
    this.onSave,
    this.popOnSave = true,
    this.showBackButton = true,
  });

  @override
  State<EditRangerScreen> createState() => _EditRangerScreenState();
}

class _EditRangerScreenState extends State<EditRangerScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _lastNameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _locationCtrl;
  late final TextEditingController _bioCtrl;

  bool _saving = false;
  String? _localAvatarUrl;

  @override
  void initState() {
    super.initState();
    _firstNameCtrl = TextEditingController();
    _lastNameCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _locationCtrl = TextEditingController();
    _bioCtrl = TextEditingController();
    _localAvatarUrl = widget.ranger.avatarUrl;
    _applyRanger(widget.ranger);
  }

  @override
  void didUpdateWidget(covariant EditRangerScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ranger != widget.ranger) {
      _localAvatarUrl = widget.ranger.avatarUrl;
      _applyRanger(widget.ranger);
    }
  }

  void _applyRanger(RangerModel ranger) {
    final parts = ranger.name.split(' ');
    _firstNameCtrl.text = parts.isNotEmpty ? parts.first : '';
    _lastNameCtrl.text = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    _emailCtrl.text = ranger.email ?? '';
    _locationCtrl.text = ranger.location ?? '';
    _bioCtrl.text = ranger.bio ?? '';
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _locationCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _localAvatarUrl = pickedFile.path;
      });
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updatePhotoURL(pickedFile.path);
      }
    }
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);

    final fullName =
        '${_firstNameCtrl.text.trim()} ${_lastNameCtrl.text.trim()}'.trim();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updateDisplayName(fullName);
      }
    } catch (_) {}

    final updated = widget.ranger.copyWith(
      name: fullName,
      email: _emailCtrl.text.trim(),
      location: _locationCtrl.text.trim(),
      bio: _bioCtrl.text.trim(),
      avatarUrl: _localAvatarUrl,
    );

    widget.onSave?.call(updated);

    if (!mounted) return;

    if (widget.popOnSave && Navigator.canPop(context)) {
      Navigator.pop(context, updated);
      return;
    }

    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SafariTheme.background,
      body: Form(
        key: _formKey,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: _EditHeader(
                ranger: widget.ranger,
                showBackButton: widget.showBackButton,
                localAvatarUrl: _localAvatarUrl,
                onPickImage: _pickImage,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FieldLabel(label: 'Your Name'),
                    const SizedBox(height: 6),
                    _TrailField(
                      controller: _firstNameCtrl,
                      hint: 'First name',
                      prefixIcon: Icons.person_outline,
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                              ? 'Required'
                              : null,
                    ),
                    const SizedBox(height: 14),
                    const _FieldLabel(label: 'Last Name'),
                    const SizedBox(height: 6),
                    _TrailField(
                      controller: _lastNameCtrl,
                      hint: 'Last name',
                      prefixIcon: Icons.person_outline,
                    ),
                    const SizedBox(height: 14),
                    const _FieldLabel(label: 'Your Email'),
                    const SizedBox(height: 6),
                    _TrailField(
                      controller: _emailCtrl,
                      hint: 'explorer@wildx.app',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 14),
                    const _FieldLabel(label: 'Location'),
                    const SizedBox(height: 6),
                    _TrailField(
                      controller: _locationCtrl,
                      hint: 'Colombo, Sri Lanka',
                      prefixIcon: Icons.location_on_outlined,
                    ),
                    const SizedBox(height: 14),
                    const _FieldLabel(label: 'Bio'),
                    const SizedBox(height: 6),
                    _TrailField(
                      controller: _bioCtrl,
                      hint: 'Tell us about your wildlife journey...',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saving ? null : _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SafariTheme.forestGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: _saving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Save Changes',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditHeader extends StatelessWidget {
  final RangerModel ranger;
  final bool showBackButton;
  final String? localAvatarUrl;
  final VoidCallback? onPickImage;

  const _EditHeader({
    required this.ranger,
    required this.showBackButton,
    this.localAvatarUrl,
    this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    final initials = ranger.name.isNotEmpty
        ? ranger.name
            .trim()
            .split(' ')
            .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
            .take(2)
            .join()
        : '?';

    return Container(
      decoration: const BoxDecoration(
        gradient: SafariTheme.headerGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: Column(
            children: [
              Row(
                children: [
                  showBackButton
                      ? IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () => Navigator.maybePop(context),
                        )
                      : const SizedBox(width: 48),
                  const Spacer(),
                  const Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: onPickImage,
                child: Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.2),
                        border: Border.all(color: Colors.white, width: 3),
                        image: localAvatarUrl != null
                            ? DecorationImage(
                                image: localAvatarUrl!.startsWith('http')
                                    ? NetworkImage(localAvatarUrl!) as ImageProvider
                                    : FileImage(File(localAvatarUrl!)),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: localAvatarUrl == null
                          ? Center(
                              child: Text(
                                initials,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: SafariTheme.forestGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                ranger.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrailField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;

  const _TrailField({
    required this.controller,
    required this.hint,
    this.prefixIcon,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: SafariTheme.textSecondary,
          fontSize: 14,
        ),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: SafariTheme.textSecondary, size: 20)
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: SafariTheme.forestGreen,
            width: 2,
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;

  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: SafariTheme.textSecondary,
      ),
    );
  }
}

