import 'package:flutter/material.dart';
import '../models/key_feature_item.dart';

// App Metadata - Centralized versioning and branding for easy updates
const String appVersion = 'Version 1.0.0';
const String appTagline = 'Wildlife Explorer';

// Mission Statement - Reflects the core values and the "Why" behind WildX
const String missionText =
    'WildX is dedicated to promoting wildlife conservation and sustainable '
    'tourism in Sri Lanka. We empower visitors and locals to explore, discover, '
    'and protect our precious wildlife heritage.';

// Conservation details to highlight the app's social and environmental impact
const String conservationPartnerTitle = 'Conservation Partner';
const String conservationPartnerSubtitle =
    'In partnership with the Department of Wildlife Conservation, Sri Lanka';
const String conservationPartnerBody =
    'A portion of app proceeds goes directly to wildlife conservation efforts '
    'and anti-poaching initiatives across Sri Lankan national parks.';

// Essential contact information for support and emergencies in the field
const String contactEmail = 'support@wildx.com';
const String contactWebsite = 'www.wildx.com';
const String contactEmergency = '119 (Wildlife Hotline)';

const String madeWithLoveText =
    "Dedicated to preserving Sri Lanka's magnificent wildlife for future "
    'generations. Together, we can make a difference.';

// List of core features showcased in the "About Us" or "Introduction" section
const List<KeyFeatureItem> keyFeatures = [
  KeyFeatureItem(
    title: 'Real-time Wildlife Tracking',
    subtitle: 'Report and view animal sightings across all parks',
    icon: Icons.location_on,
    iconColor: Color(0xFF2196F3),
    iconBgColor: Color(0xFFE3F2FD),
  ),
  KeyFeatureItem(
    title: 'Emergency SOS System',
    subtitle: 'Quick access to wildlife officers and emergency services',
    icon: Icons.warning_amber_rounded,
    iconColor: Color(0xFFFF9800),
    iconBgColor: Color(0xFFFFF3E0),
  ),
  KeyFeatureItem(
    title: 'Community Driven',
    subtitle: 'Connect with fellow wildlife enthusiasts and rangers',
    icon: Icons.people,
    iconColor: Color(0xFF9C27B0),
    iconBgColor: Color(0xFFF3E5F5),
  ),
  KeyFeatureItem(
    title: 'Offline Functionality',
    subtitle: 'Access maps and guides even without internet',
    icon: Icons.wifi_off,
    iconColor: Color(0xFF4CAF50),
    iconBgColor: Color(0xFFE8F5E9),
  ),
];