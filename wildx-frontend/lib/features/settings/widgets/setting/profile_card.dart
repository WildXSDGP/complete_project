// lib/widgets/settings/profile_card.dart

import 'package:flutter/material.dart';
import '../../models/user_profile.dart';

/// A custom widget that displays the user's profile summary at the top 
/// of the Settings screen. It includes an avatar, user info, and an achievement badge.
class ProfileCard extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback? onTap;

  const ProfileCard({
    super.key,
    required this.profile,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Makes the entire card interactive (e.g., to go to Edit Profile)
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            // ── User Avatar Section ────────────────────────────────────
            // Displays the user's photo or a default icon if no image is set.
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE8F5E9), // Light green background
                border: Border.all(
                  color: const Color(0xFF2ECC71).withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: profile.avatarUrl != null
                  ? CircleAvatar(
                      radius: 27,
                      backgroundImage: NetworkImage(profile.avatarUrl!),
                    )
                  : const CircleAvatar(
                      radius: 27,
                      backgroundColor: Color(0xFFD0EDD8),
                      child: Icon(
                        Icons.person_rounded,
                        size: 30,
                        color: Color(0xFF2ECC71),
                      ),
                    ),
            ),
            const SizedBox(width: 14),

            // ── User Information Section ───────────────────────────────
            // Shows Name, Email, and the User's WildX Badge.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.displayName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    profile.email,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF8E8E93),
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Custom helper widget for the rank/badge
                  _BadgeChip(label: profile.badge),
                ],
              ),
            ),

            // Navigation indicator (Chevron)
            Icon(Icons.chevron_right_rounded,
                color: Colors.grey[300], size: 22),
          ],
        ),
      ),
    );
  }
}

/// Internal helper widget to display the user's rank (e.g., "Expert Ranger")
/// in a stylized, small container.
class _BadgeChip extends StatelessWidget {
  final String label;
  const _BadgeChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2ECC71),
        ),
      ),
    );
  }
}