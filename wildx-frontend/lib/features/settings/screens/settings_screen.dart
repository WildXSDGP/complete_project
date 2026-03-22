import 'package:flutter/material.dart';
import '../../auth/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../auth/services/auth_service.dart';
import '../widgets/setting/feedback_sheet.dart';
import '../widgets/setting/logout_button.dart';
import '../widgets/setting/settings_footer.dart';
import '../widgets/setting/settings_tile.dart';
import '../widgets/setting/profile_card.dart';
import '../widgets/setting/section_card.dart';
import '../widgets/setting/help_sheet.dart';
import '../models/user_profile.dart';
import '../data/settings_data.dart';
import '../../profile/screens/explorer_screen.dart';
import '../../profile/data/ranger_data.dart';
import '../../profile/models/ranger_model.dart';
import '../screens/notifications_screen.dart';
import '../screens/about_screen.dart';
import '../screens/language_screen.dart';
import '../screens/privacy_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  UserProfile get _profile {
    final user = FirebaseAuth.instance.currentUser;
    return UserProfile(
      displayName: user?.displayName ??
          user?.email?.split('@').first ??
          'Wildlife Explorer',
      email: user?.email ?? user?.phoneNumber ?? 'wildx@explorer.com',
      badge: 'Expert Ranger',
      avatarUrl: user?.photoURL,
    );
  }

  RangerModel get _ranger {
    final user = FirebaseAuth.instance.currentUser;
    return kSampleRanger.copyWith(
      name: user?.displayName ?? user?.email?.split('@').first ?? 'Wildlife Explorer',
      email: user?.email ?? user?.phoneNumber,
      avatarUrl: user?.photoURL,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        title: const Text('Settings'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [

          // ── Profile Card ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ProfileCard(
              profile: _profile,
              onTap: () async {
                final updated = await Navigator.push<RangerModel>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ExplorerScreen(ranger: _ranger),
                  ),
                );
                if (updated != null) setState(() {});
              },
            ),
          ),

          const SizedBox(height: 24),

          // ── Main Settings ─────────────────────────────────────────
          SectionCard(items: [
            SettingsTile(
              icon: mainSettingsItems[0].icon,
              iconColor: mainSettingsItems[0].iconColor,
              label: mainSettingsItems[0].label,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const NotificationsScreen())),
            ),
            SettingsTile(
              icon: mainSettingsItems[1].icon,
              iconColor: mainSettingsItems[1].iconColor,
              label: mainSettingsItems[1].label,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const LanguageScreen())),
            ),
            SettingsTile(
              icon: mainSettingsItems[2].icon,
              iconColor: mainSettingsItems[2].iconColor,
              label: mainSettingsItems[2].label,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const PrivacyScreen())),
            ),
            SettingsTile(
              icon: mainSettingsItems[3].icon,
              iconColor: mainSettingsItems[3].iconColor,
              label: mainSettingsItems[3].label,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AboutScreen())),
            ),
          ]),

          const SizedBox(height: 16),

          // ── Help & Feedback ───────────────────────────────────────
          SectionCard(items: [
            SettingsTile(
              icon: helpSettingsItems[0].icon,
              iconColor: helpSettingsItems[0].iconColor,
              label: helpSettingsItems[0].label,
              onTap: () => HelpSheet.show(context),
            ),
            SettingsTile(
              icon: helpSettingsItems[1].icon,
              iconColor: helpSettingsItems[1].iconColor,
              label: helpSettingsItems[1].label,
              onTap: () => FeedbackSheet.show(context),
            ),
          ]),

          const SizedBox(height: 16),

          // ── Logout ────────────────────────────────────────────────
          LogoutButton(onTap: () => _showLogoutDialog()),

          const SizedBox(height: 32),

          // ── Footer ────────────────────────────────────────────────
          const SettingsFooter(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$feature — coming soon'),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: const Color(0xFF2E7D32),
      duration: const Duration(seconds: 2),
    ));
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
        content: const Text(
          'Are you sure you want to logout of your WildX account?',
          style: TextStyle(color: Color(0xFF6B6B6B), fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Color(0xFF2E7D32))),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await AuthService().signOut();
              if (mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text('Logout',
                style: TextStyle(
                    color: Color(0xFFFF3B30), fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

