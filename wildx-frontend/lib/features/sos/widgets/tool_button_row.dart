import 'package:flutter/material.dart';

class ToolButtonRow extends StatelessWidget {
  final bool flashlightActive;
  final bool alarmActive;
  final Future<void> Function() onFlashlightTap;
  final Future<void> Function() onAlarmTap;

  const ToolButtonRow({
    super.key,
    required this.flashlightActive,
    required this.alarmActive,
    required this.onFlashlightTap,
    required this.onAlarmTap,
  });

  Widget _buildToolButton({
    required IconData icon,
    required String label,
    required bool active,
    required VoidCallback onTap,
    required Color activeColor,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: active ? activeColor.withOpacity(0.12) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: active ? activeColor : Colors.grey.shade200,
              width: active ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: active
                    ? activeColor.withOpacity(0.15)
                    : Colors.grey.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 28,
                color: active ? activeColor : Colors.grey.shade700,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: active ? activeColor : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildToolButton(
          icon: flashlightActive ? Icons.flashlight_on : Icons.flashlight_off,
          label: 'Flashlight',
          active: flashlightActive,
          onTap: onFlashlightTap,
          activeColor: Colors.amber.shade700,
        ),
        const SizedBox(width: 12),
        _buildToolButton(
          icon: alarmActive ? Icons.volume_up : Icons.volume_up_outlined,
          label: 'Alarm',
          active: alarmActive,
          onTap: onAlarmTap,
          activeColor: Colors.red.shade600,
        ),
      ],
    );
  }
}
