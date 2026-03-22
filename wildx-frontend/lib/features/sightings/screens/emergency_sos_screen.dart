import 'package:flutter/material.dart';
import '../models/emergency_contact.dart';
import '../models/location_info.dart';
import '../models/safety_tip.dart';
import '../services/emergency_service.dart';
import '../services/location_service.dart';
import '../widgets/sos_button.dart';
import '../widgets/emergency_contact_card.dart';
import '../widgets/location_card.dart';
import '../widgets/quick_safety_tips_card.dart';
import '../widgets/tool_button_row.dart';

class EmergencySOSScreen extends StatefulWidget {
  const EmergencySOSScreen({super.key});

  @override
  State<EmergencySOSScreen> createState() => _EmergencySOSScreenState();
}

class _EmergencySOSScreenState extends State<EmergencySOSScreen> {
  final EmergencyService _service = EmergencyService();
  final LocationService _locationService = LocationService();

  final List<EmergencyContact> _contacts = defaultEmergencyContacts;
  final List<SafetyTip> _tips = wildlifeSafetyTips;

  bool _flashlightActive = false;
  bool _alarmActive = false;
  LocationInfo? _gpsLocation;

  @override
  void initState() {
    super.initState();
    _loadGPSLocation();
  }

  @override
  void dispose() {
    _service.ensureAllOff();
    super.dispose();
  }

  Future<void> _loadGPSLocation() async {
    final result = await _locationService.getCurrentLocation();
    if (mounted && result.status == LocationStatus.success) {
      setState(() => _gpsLocation = result.location);
    }
  }

  LocationInfo get _activeLocation => _gpsLocation ?? defaultLocation;

  void _onSOSActivated() {
    _service.sendSOSAlert(_activeLocation);
    _showSnackBar('🚨 SOS Alert Sent! Help is on the way.', Colors.red.shade700);
  }

  void _onCallContact(EmergencyContact contact) {
    _service.callEmergency(contact);
    _showSnackBar('📞 Calling ${contact.name} (${contact.number})...', Colors.green.shade700);
  }

  void _onShareLocation() {
    _service.shareLocation(_activeLocation);
    _showSnackBar('📍 Location shared: ${_activeLocation.coordinates}', Colors.blue.shade700);
  }

  Future<void> _toggleFlashlight() async {
    final result = await _service.toggleFlashlight();
    if (result == null) {
      _showSnackBar('⚠️ Torch not available on this device.', Colors.grey.shade700);
      return;
    }
    setState(() => _flashlightActive = result);
    _showSnackBar(
      _flashlightActive ? '🔦 Flashlight ON' : '🔦 Flashlight OFF',
      Colors.amber.shade700,
    );
  }

  Future<void> _toggleAlarm() async {
    final isNowPlaying = await _service.toggleAlarm();
    setState(() => _alarmActive = isNowPlaying);
    _showSnackBar(
      isNowPlaying ? '🔔 Alarm ON — playing at full volume!' : '🔕 Alarm stopped.',
      isNowPlaying ? Colors.red.shade600 : Colors.grey.shade600,
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFC0392B),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Emergency SOS',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
            Text('Help & Safety', style: TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.warning_amber_rounded), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: SOSButton(onSOSActivated: _onSOSActivated)),
            const SizedBox(height: 24),
            ToolButtonRow(
              flashlightActive: _flashlightActive,
              alarmActive: _alarmActive,
              onFlashlightTap: _toggleFlashlight,
              onAlarmTap: _toggleAlarm,
            ),
            const SizedBox(height: 26),
            const Text('Emergency Contacts',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1A1A2E))),
            const SizedBox(height: 12),
            ..._contacts.map((contact) =>
                EmergencyContactCard(contact: contact, onCall: () => _onCallContact(contact))),
            const SizedBox(height: 20),
            LocationCard(fallbackLocation: defaultLocation, onShare: _onShareLocation),
            const SizedBox(height: 16),
            QuickSafetyTipsCard(tips: _tips),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4)),
                    child: const Text('SOS',
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'In case of emergency, stay in your vehicle and call for help. Park rangers are available 24/7.',
                      style: TextStyle(color: Color(0xFF7A1A1A), fontSize: 13, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Alarm active banner
            if (_alarmActive)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.red.shade600,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.volume_up, color: Colors.white),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        '🔔 ALARM IS ACTIVE — Tap Alarm button again to stop.',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                    GestureDetector(
                      onTap: _toggleAlarm,
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
