import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';

// ════════════════════════════════════════════════════════════════
// APP HEADER
// ════════════════════════════════════════════════════════════════
class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.headerGradient,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 20, right: 20, bottom: 20,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('WildX', style: AppTextStyles.appTitle),
          SizedBox(height: 2),
          Text("Explore Sri Lanka's Wildlife", style: AppTextStyles.appSubtitle),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
// SECTION HEADER
// ════════════════════════════════════════════════════════════════
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key, required this.title, this.actionLabel, this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.sectionTitle),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Row(children: [
              Text(actionLabel!,
                  style: const TextStyle(
                      color: AppColors.primary, fontSize: 13,
                      fontWeight: FontWeight.w600)),
              const SizedBox(width: 3),
              const Icon(Icons.arrow_forward, size: 14, color: AppColors.primary),
            ]),
          ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════
// STATS ROW
// ════════════════════════════════════════════════════════════════
class StatsRow extends StatelessWidget {
  final UserStats stats;
  const StatsRow({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: AppDecorations.card,
      child: Row(children: [
        _StatItem(value: '${stats.sightings}', label: 'Sightings',
            color: AppColors.blue),
        Container(height: 36, width: 1, color: AppColors.divider),
        _StatItem(value: '${stats.badges}', label: 'Badges',
            color: AppColors.amber),
        Container(height: 36, width: 1, color: AppColors.divider),
        _StatItem(value: '${stats.parks}', label: 'Parks',
            color: AppColors.cyan),
      ]),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value, label;
  final Color color;
  const _StatItem({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Column(children: [
      Text(value,
          style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.w800)),
      const SizedBox(height: 3),
      Text(label, style: AppTextStyles.hint),
    ]));
  }
}

// ════════════════════════════════════════════════════════════════
// FEATURED PARK CARD
// ════════════════════════════════════════════════════════════════
class FeaturedParkCard extends StatelessWidget {
  final Park park;
  final VoidCallback? onExplore;
  const FeaturedParkCard({super.key, required this.park, this.onExplore});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 185,
      decoration: AppDecorations.cardLg,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(fit: StackFit.expand, children: [
          Image.network(park.imageUrl, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                  color: AppColors.primaryDark,
                  child: const Icon(Icons.park, color: Colors.white54, size: 60)),
              loadingBuilder: (_, child, p) {
                if (p == null) return child;
                return Container(color: AppColors.primaryDark,
                    child: const Center(
                        child: CircularProgressIndicator(color: Colors.white54)));
              }),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.75)],
                stops: const [0.3, 1.0],
              ),
            ),
          ),
          Positioned(
            left: 16, bottom: 16, right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.22),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('Featured Park',
                        style: TextStyle(color: Colors.white, fontSize: 11,
                            fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(height: 5),
                  Text(park.name, style: AppTextStyles.cardTitle),
                  const SizedBox(height: 3),
                  Row(children: [
                    const Icon(Icons.location_on_rounded,
                        color: Colors.white70, size: 13),
                    const SizedBox(width: 3),
                    Text(park.location,
                        style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  ]),
                ]),
                GestureDetector(
                  onTap: onExplore,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(children: [
                      Text('Explore',
                          style: TextStyle(color: AppColors.primary,
                              fontWeight: FontWeight.w700, fontSize: 13)),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward, size: 14, color: AppColors.primary),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
// SIGHTING CARD
// ════════════════════════════════════════════════════════════════
class SightingCard extends StatelessWidget {
  final Sighting sighting;
  final VoidCallback? onTap;
  const SightingCard({super.key, required this.sighting, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: AppDecorations.card,
        child: Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(sighting.imageUrl,
                width: 64, height: 64, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                    width: 64, height: 64, color: AppColors.primarySurface,
                    child: Center(
                      child: Text(
                        _getEmojiForAnimal(sighting.animalName),
                        style: const TextStyle(fontSize: 30),
                      ),
                    )),
                loadingBuilder: (_, child, p) {
                  if (p == null) return child;
                  return Container(width: 64, height: 64,
                      color: AppColors.primarySurface,
                      child: const Center(
                          child: SizedBox(width: 20, height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: AppColors.primary))));
                }),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(sighting.animalName,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 3),
            Text(sighting.parkName, style: AppTextStyles.caption),
            const SizedBox(height: 3),
            Text(sighting.formattedDate, style: AppTextStyles.hint),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(sighting.category,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                    color: AppColors.primary)),
          ),
        ]),
      ),
    );
  }
}
