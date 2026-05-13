import 'package:flutter/material.dart';

/// Daily averages section — always visible, no toggles.
class KpiAveragesSection extends StatelessWidget {
  final double avgDailyImages;
  final double avgDailyCompounds;
  final double avgDailyOPNs;
  final bool showImages;
  final bool showCompounds;
  final bool showOPNs;
  final ValueChanged<bool> onToggleImages;
  final ValueChanged<bool> onToggleCompounds;
  final ValueChanged<bool> onToggleOPNs;

  const KpiAveragesSection({
    super.key,
    required this.avgDailyImages,
    required this.avgDailyCompounds,
    required this.avgDailyOPNs,
    required this.showImages,
    required this.showCompounds,
    required this.showOPNs,
    required this.onToggleImages,
    required this.onToggleCompounds,
    required this.onToggleOPNs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.analytics_outlined, size: 18, color: Color(0xFF6B7280)),
              SizedBox(width: 8),
              Text('Daily Averages', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
            ],
          ),
          const SizedBox(height: 4),
          const Text('Average performance per working day', style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
          const SizedBox(height: 14),
          _buildMetricRow(Icons.camera_alt_outlined, 'Avg Daily Images', avgDailyImages, const Color(0xFF3B82F6)),
          const SizedBox(height: 8),
          _buildMetricRow(Icons.receipt_long_outlined, 'Avg Daily Compounds', avgDailyCompounds, const Color(0xFFF5A623)),
          const SizedBox(height: 8),
          _buildMetricRow(Icons.description_outlined, 'Avg Daily OPNs', avgDailyOPNs, const Color(0xFF8B5CF6)),
        ],
      ),
    );
  }

  Widget _buildMetricRow(IconData icon, String label, double value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1F2937))),
          ),
          Text(value.toStringAsFixed(1), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(width: 4),
          const Text('/day', style: TextStyle(fontSize: 10, color: Color(0xFF9CA3AF))),
        ],
      ),
    );
  }
}
