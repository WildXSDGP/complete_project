import '../models/notification_setting.dart';

/// Centralized configuration for default notification preferences.
/// This list drives the UI for the settings toggle screen.
List<NotificationSetting> defaultNotificationSettings = [
  NotificationSetting(
    title: 'New Sightings',
    subtitle: 'Get notified about wildlife sightings\nin saved parks',
    isEnabled: true, // Enabled by default to encourage engagement
  ),
  NotificationSetting(
    title: 'Park Alerts',
    subtitle: 'Updates about park closures and\nconditions',
    isEnabled: true, // Critical for user planning and logistical awareness
  ),
  NotificationSetting(
    title: 'Badges & Achievements',
    subtitle: 'Celebrate your milestones',
    isEnabled: true, // Gamification element to reward user contributions
  ),
  NotificationSetting(
    title: 'Community Updates',
    subtitle: 'News from other wildlife explorers',
    isEnabled: false, // Disabled by default to prevent notification fatigue
  ),
  NotificationSetting(
    title: 'Emergency Alerts',
    subtitle: 'Critical safety notifications',
    isEnabled: true, // Safety-first approach; essential for field exploration
  ),
];