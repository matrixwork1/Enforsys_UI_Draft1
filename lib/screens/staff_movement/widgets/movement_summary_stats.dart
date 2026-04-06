import 'package:flutter/material.dart';

class MovementSummaryStats extends StatelessWidget {
  final String distance;
  final String onDuty;
  final int stops;

  const MovementSummaryStats({
    super.key,
    required this.distance,
    required this.onDuty,
    required this.stops,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildStatCard(
          icon: Icons.straighten,
          label: 'Distance',
          value: distance,
          color: const Color(0xFF3B82F6),
        ),
        const SizedBox(width: 10),
        _buildStatCard(
          icon: Icons.schedule,
          label: 'On Duty',
          value: onDuty,
          color: const Color(0xFF10B981),
        ),
        const SizedBox(width: 10),
        _buildStatCard(
          icon: Icons.location_on_outlined,
          label: 'Stops',
          value: '$stops',
          color: const Color(0xFFF5A623),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF3F4F6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
