import 'package:flutter/material.dart';
import '../models/ranger_model.dart';
import '../theme/safari_theme.dart';

class BadgeGrid extends StatelessWidget {
  final List<BadgeModel> badges;

  const BadgeGrid({super.key, required this.badges});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: SafariTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.workspace_premium_rounded,
                  color: SafariTheme.amber, size: 20),
              const SizedBox(width: 8),
              Text(
                'Badges & Achievements',
                style: SafariTheme.displayFont.copyWith(
                  fontSize: 15,
                  color: SafariTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: badges.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.90,
            ),
            itemBuilder: (_, i) => _BadgeTile(badge: badges[i]),
          ),
        ],
      ),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  final BadgeModel badge;

  const _BadgeTile({required this.badge});

  Color _tileColor() {
    if (badge.iconAsset.contains('sighting')) return const Color(0xFF6366F1);
    if (badge.iconAsset.contains('trophy'))   return const Color(0xFFF59E0B);
    if (badge.iconAsset.contains('photo'))    return const Color(0xFF3B82F6);
    if (badge.iconAsset.contains('park'))     return const Color(0xFF10B981);
    if (badge.iconAsset.contains('night'))    return const Color(0xFF8B5CF6);
    if (badge.iconAsset.contains('leopard'))  return const Color(0xFFEF4444);
    return SafariTheme.forestGreen;
  }

  @override
  Widget build(BuildContext context) {
    final color = _tileColor();
    return Opacity(
      opacity: badge.earned ? 1.0 : 0.38,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: badge.earned
              ? color.withOpacity(0.08)
              : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: badge.earned
                ? color.withOpacity(0.25)
                : SafariTheme.cardBorder,
            width: 1.2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: badge.earned
                    ? color.withOpacity(0.15)
                    : const Color(0x1F9E9E9E),
              ),
              child: Center(
                child: Image.asset(
                  badge.iconAsset,
                  width: 26,
                  height: 26,
                  color: badge.earned ? null : Colors.grey,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.star_rounded,
                    size: 22,
                    color: badge.earned ? color : Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              badge.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: badge.earned
                    ? SafariTheme.textPrimary
                    : SafariTheme.textSecondary,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
