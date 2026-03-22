// lib/data/settings_data.dart

import 'package:flutter/material.dart';

// ── FAQ Structure ────────────────────────────────────────────────────────
// Model to hold Frequently Asked Questions and their answers.
class FaqItem {
  final String question;
  final String answer;
  const FaqItem({required this.question, required this.answer});
}

// List of questions to help users navigate the WildX app features.
const List<FaqItem> faqItems = [
  FaqItem(
    question: 'How do I report a wildlife sighting?',
    answer:
        'Tap the camera icon on the main gallery screen and upload a photo with location details. Our team will review and add it to the database.',
  ),
  FaqItem(
    question: 'How are conservation statuses determined?',
    answer:
        'We follow the IUCN Red List classifications: Least Concern, Vulnerable, Endangered, and Critically Endangered, updated annually.',
  ),
  FaqItem(
    question: 'Can I use WildX offline?',
    answer:
        'The animal gallery is cached after your first visit. Photo uploads require an internet connection.',
  ),
  FaqItem(
    question: 'How do I change my profile name?',
    answer:
        'Tap your profile card at the top of Settings to edit your display name and profile photo.',
  ),
];

// ── Feedback Categories ──────────────────────────────────────────────────
// Dropdown options for the "Send Feedback" sheet.
const List<String> feedbackTypes = [
  'General',
  'Bug Report',
  'Feature Request',
  'Content Issue',
];

// ── Settings Tile Model ──────────────────────────────────────────────────
// Blueprint for creating individual settings rows with icons and labels.
class SettingsItem {
  final IconData icon;
  final Color iconColor;
  final String label;

  const SettingsItem({
    required this.icon,
    required this.iconColor,
    required this.label,
  });
}

// Main configuration items (Account, Preferences, Information).
const List<SettingsItem> mainSettingsItems = [
  SettingsItem(
    icon:      Icons.notifications_outlined,
    iconColor: Color(0xFFFF9500), // Orange
    label:     'Notifications',
  ),
  SettingsItem(
    icon:      Icons.language_outlined,
    iconColor: Color(0xFF007AFF), // Blue
    label:     'Language',
  ),
  SettingsItem(
    icon:      Icons.shield_outlined,
    iconColor: Color(0xFF5856D6), // Purple
    label:     'Privacy & Security',
  ),
  SettingsItem(
    icon:      Icons.info_outline,
    iconColor: Color(0xFF34C759), // Green
    label:     'About WildX',
  ),
];

// Items for the "Support" section at the bottom of the Settings screen.
const List<SettingsItem> helpSettingsItems = [
  SettingsItem(
    icon:      Icons.help_outline_rounded,
    iconColor: Color(0xFF00C7BE), // Teal
    label:     'Help & Support',
  ),
  SettingsItem(
    icon:      Icons.rate_review_outlined,
    iconColor: Color(0xFFFF2D55), // Red
    label:     'Send Feedback',
  ),
];