import 'package:flutter/material.dart';

/// Segmented control to toggle between Zones and Markers view.
/// Styled to match the CompoundsPage TabBar pattern (solid indicator,
/// border-based highlight, no shadow animation jank).
class HeatmapViewToggle extends StatelessWidget {
  final bool isZoneView;
  final ValueChanged<bool> onToggle;

  const HeatmapViewToggle({
    super.key,
    required this.isZoneView,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        children: [
          _buildSegment(
            label: 'Zones',
            isSelected: isZoneView,
            onTap: () => onToggle(true),
          ),
          _buildSegment(
            label: 'Markers',
            isSelected: !isZoneView,
            onTap: () => onToggle(false),
          ),
        ],
      ),
    );
  }

  Widget _buildSegment({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isSelected
                ? Border.all(color: const Color(0xFFE5E7EB), width: 1)
                : null,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    )
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF1F2937)
                    : const Color(0xFF9CA3AF),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
