import 'package:flutter/material.dart';

import '../../home/screens/main_screen.dart';
import '../models/ranger_model.dart';
import '../screens/edit_ranger_screen.dart';
import '../screens/gear_screen.dart';
import '../theme/safari_theme.dart';

class RangerHeader extends StatelessWidget {
  final RangerModel ranger;
  final ValueChanged<RangerModel>? onRangerUpdated;

  const RangerHeader({
    super.key,
    required this.ranger,
    this.onRangerUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: SafariTheme.headerGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            children: [
              Row(
                children: [
                  _CircleBtn(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () {
                      MainScreen.jumpTo(context, 1);
                      Navigator.maybePop(context);
                    },
                  ),
                  const Spacer(),
                  _CircleBtn(
                    icon: Icons.settings_outlined,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const GearScreen()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  _RangerAvatar(ranger: ranger, radius: 40),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ranger.name,
                          style: SafariTheme.displayFont.copyWith(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (ranger.location != null &&
                            ranger.location!.isNotEmpty)
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_rounded,
                                color: Color(0xCCFFFFFF),
                                size: 13,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                ranger.location!,
                                style: const TextStyle(
                                  color: Color(0xCCFFFFFF),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                        else
                          Text(
                            'Member since ${ranger.memberSinceLabel}',
                            style: const TextStyle(
                              color: Color(0xCCFFFFFF),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () async {
                            final updated = await Navigator.push<RangerModel>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditRangerScreen(
                                  ranger: ranger,
                                  onSave: onRangerUpdated,
                                ),
                              ),
                            );
                            if (updated != null) {
                              onRangerUpdated?.call(updated);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0x2EFFFFFF),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0x4DFFFFFF),
                                width: 1,
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.edit_rounded,
                                  color: Colors.white,
                                  size: 13,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Edit Profile',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: const BoxDecoration(
          color: Color(0x2EFFFFFF),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}

class _RangerAvatar extends StatelessWidget {
  final RangerModel ranger;
  final double radius;

  const _RangerAvatar({required this.ranger, required this.radius});

  @override
  Widget build(BuildContext context) {
    final initials = ranger.name
        .split(' ')
        .take(2)
        .map((word) => word.isNotEmpty ? word[0] : '')
        .join()
        .toUpperCase();

    return Stack(
      children: [
        Container(
          width: radius * 2,
          height: radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
            image: ranger.avatarUrl != null
                ? DecorationImage(
                    image: NetworkImage(ranger.avatarUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: ranger.avatarUrl == null
              ? Center(
                  child: Text(
                    initials,
                    style: TextStyle(
                      color: SafariTheme.forestGreen,
                      fontSize: radius * 0.6,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                )
              : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: SafariTheme.amber,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(
              Icons.camera_alt_rounded,
              color: Colors.white,
              size: 13,
            ),
          ),
        ),
      ],
    );
  }
}

