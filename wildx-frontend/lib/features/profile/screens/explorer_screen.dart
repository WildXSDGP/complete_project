import 'package:flutter/material.dart';

import '../../auth/screens/login_screen.dart';
import '../../auth/services/auth_service.dart';
import '../models/ranger_model.dart';
import '../theme/safari_theme.dart';
import '../widgets/badge_grid.dart';
import '../widgets/level_card.dart';
import '../widgets/ranger_header.dart';
import '../widgets/safari_parks_card.dart';
import '../widgets/tracker_card.dart';

class ExplorerScreen extends StatefulWidget {
  final RangerModel ranger;
  final ValueChanged<RangerModel>? onRangerUpdated;

  const ExplorerScreen({
    super.key,
    required this.ranger,
    this.onRangerUpdated,
  });

  @override
  State<ExplorerScreen> createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _xpAnim;
  late RangerModel _ranger;

  @override
  void initState() {
    super.initState();
    _ranger = widget.ranger;
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _xpAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    _ctrl.forward();
  }

  @override
  void didUpdateWidget(covariant ExplorerScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ranger != widget.ranger) {
      _ranger = widget.ranger;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onRangerUpdated(RangerModel updated) {
    setState(() => _ranger = updated);
    widget.onRangerUpdated?.call(updated);
  }

  Future<void> _showLogoutDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Logout',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
        ),
        content: const Text(
          'Are you sure you want to logout of your WildX account?',
          style: TextStyle(color: Color(0xFF6B6B6B), fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF2E7D32)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Logout',
              style: TextStyle(
                color: Color(0xFFFF3B30),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    await AuthService().signOut();
    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SafariTheme.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: RangerHeader(
              ranger: _ranger,
              onRangerUpdated: _onRangerUpdated,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 20),
                if (_ranger.bio != null && _ranger.bio!.isNotEmpty) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: SafariTheme.cardDecoration,
                    child: Text(
                      _ranger.bio!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: SafariTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                TrackerCardRow(ranger: _ranger),
                const SizedBox(height: 20),
                LevelCard(ranger: _ranger, animation: _xpAnim),
                const SizedBox(height: 20),
                BadgeGrid(badges: _ranger.badges),
                const SizedBox(height: 20),
                SafariParksCard(parks: _ranger.topParks),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _showLogoutDialog,
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text('Logout'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFFF3B30),
                      side: const BorderSide(color: Color(0xFFFF3B30)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
