import 'package:flutter/material.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _shareLocation = true;
  bool _allowAnalytics = true;
  bool _publicProfile = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        title: const Text('Privacy & Security', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2E7D32),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          SwitchListTile(
            title: const Text('Share Location Data'),
            subtitle: const Text('Help us track wildlife accurately'),
            value: _shareLocation,
            activeThumbColor: const Color(0xFF2E7D32),
            onChanged: (val) => setState(() => _shareLocation = val),
            tileColor: Colors.white,
          ),
          const Divider(height: 1),
          SwitchListTile(
            title: const Text('Allow Analytics'),
            subtitle: const Text('Share usage data to improve the app'),
            value: _allowAnalytics,
            activeThumbColor: const Color(0xFF2E7D32),
            onChanged: (val) => setState(() => _allowAnalytics = val),
            tileColor: Colors.white,
          ),
          const Divider(height: 1),
          SwitchListTile(
            title: const Text('Public Profile'),
            subtitle: const Text('Let other rangers see your profile'),
            value: _publicProfile,
            activeThumbColor: const Color(0xFF2E7D32),
            onChanged: (val) => setState(() => _publicProfile = val),
            tileColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
