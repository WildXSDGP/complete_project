/// Data model representing a single notification preference.
/// This acts as a blueprint for the settings UI and persistence logic.
class NotificationSetting {
  final String title;    // Main label for the setting (e.g., "Emergency Alerts")
  final String subtitle; // Descriptive text to explain what the setting does
  bool isEnabled;        // Mutable field to track user preference (on/off)

  NotificationSetting({
    required this.title,
    required this.subtitle,
    required this.isEnabled,
  });
}