import 'package:flutter/material.dart';
import '../data/notification_data.dart';
import '../models/notification_setting.dart';
import '../widgets/notifications_app_bar.dart';
import '../widgets/notifications_card.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late List<NotificationSetting> _settings;

  @override
  void initState() {
    super.initState();
    // Initializing state with a deep copy of default settings.
    // This ensures that changes made in the UI don't accidentally mutate 
    // the global default data until they are explicitly saved.
    _settings = defaultNotificationSettings
        .map((e) => NotificationSetting(
              title: e.title,
              subtitle: e.subtitle,
              isEnabled: e.isEnabled,
            ))
        .toList();
  }

  // A centralized handler to update the local state when a user toggles a switch
  void _handleToggle(int index, bool value) {
    setState(() {
      _settings[index].isEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NotificationsAppBar(),
      backgroundColor: const Color(0xFFF0F7F4), // Soft nature-inspired background
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                // Passing the local state and the toggle handler to the card widget
                child: NotificationsCard(
                  settings: _settings,
                  onToggle: _handleToggle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}