import 'package:flutter/material.dart';
import '../models/ranger_model.dart';
import '../theme/safari_theme.dart';

class LevelCard extends StatelessWidget {
  final RangerModel ranger;
  final Animation<double> animation;

  const LevelCard({
    super.key,
    required this.ranger,
    required this.animation,
  });

  static const _levels = [
    WildXLevel.explorer,
    WildXLevel.ranger,
    WildXLevel.guardian,
  ];

  static const _labels = ['Explorer', 'Ranger', 'Guardian'];

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
              const Icon(Icons.military_tech_rounded,
                  color: SafariTheme.amber, size: 22),
              const SizedBox(width: 8),
              Text(
                'Level: ${ranger.levelLabel}',
                style: SafariTheme.displayFont.copyWith(
                  fontSize: 15,
                  color: SafariTheme.textPrimary,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: SafariTheme.mintGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${ranger.xp} / ${ranger.xpForNextLevel} XP',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: SafariTheme.forestGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: animation,
            builder: (_, __) => ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: ranger.levelProgress * animation.value,
                minHeight: 10,
                backgroundColor: const Color(0xFFE5E7EB),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  SafariTheme.leafGreen,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(3, (i) {
              final isActive = _levels[i].index <= ranger.currentLevel.index;
              return Text(
                _labels[i],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight:
                      isActive ? FontWeight.w700 : FontWeight.w400,
                  color: isActive
                      ? SafariTheme.forestGreen
                      : SafariTheme.textSecondary,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
