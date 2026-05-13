import 'package:flutter/material.dart';

/// Conversion rate card: Images → (Compounds + OPNs) ratio.
class KpiConversionCard extends StatelessWidget {
  final int imagesTaken;
  final int compounds;
  final int opns;
  final bool showPercentage;
  final VoidCallback onToggle;

  const KpiConversionCard({
    super.key,
    required this.imagesTaken,
    required this.compounds,
    required this.opns,
    required this.showPercentage,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final totalActions = compounds + opns;
    final rate = imagesTaken > 0 ? (totalActions / imagesTaken * 100) : 0.0;
    final fraction = imagesTaken > 0 ? (totalActions / imagesTaken).clamp(0.0, 1.0) : 0.0;

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
          Row(
            children: [
              const Text('Conversion Rate', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
              const Spacer(),
              // Toggle button
              GestureDetector(
                onTap: onToggle,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        showPercentage ? Icons.analytics_outlined : Icons.show_chart,
                        size: 14, color: const Color(0xFF6B7280),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        showPercentage ? 'Show Analysis' : 'Show %',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF6B7280)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text('Images → Compound + OPN', style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
          const SizedBox(height: 16),

          // Main display
          if (showPercentage)
            Center(
              child: Column(
                children: [
                  Text('${rate.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Color(0xFF1F2937))),
                  const SizedBox(height: 4),
                  const Text('conversion rate', style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
                ],
              ),
            )
          else
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildMetricPill(Icons.camera_alt_outlined, '$imagesTaken', const Color(0xFF3B82F6), 'Images'),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.arrow_forward, size: 18, color: Color(0xFFD1D5DB)),
                  ),
                  _buildMetricPill(Icons.receipt_long_outlined, '$compounds', const Color(0xFFF5A623), 'Compounds'),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text('+', style: TextStyle(fontSize: 16, color: Color(0xFF9CA3AF))),
                  ),
                  _buildMetricPill(Icons.description_outlined, '$opns', const Color(0xFF8B5CF6), 'OPNs'),
                ],
              ),
            ),

          const SizedBox(height: 16),

          // Visual bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 8,
              child: Stack(
                children: [
                  Container(color: const Color(0xFFF3F4F6)),
                  FractionallySizedBox(
                    widthFactor: fraction,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)]),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('0%', style: TextStyle(fontSize: 10, color: Color(0xFF9CA3AF))),
              Text('$totalActions / $imagesTaken', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF6B7280))),
              const Text('100%', style: TextStyle(fontSize: 10, color: Color(0xFF9CA3AF))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricPill(IconData icon, String value, Color color, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: color)),
            ],
          ),
        ),
        const SizedBox(height: 3),
        Text(label, style: const TextStyle(fontSize: 9, color: Color(0xFF9CA3AF))),
      ],
    );
  }
}
