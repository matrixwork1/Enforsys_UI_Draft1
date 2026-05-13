import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../enforcement_heatmap_data.dart';

/// Analytics dashboard section for the Enforcement Heatmap module.
/// Contains period selector, summary cards, bar chart, donut chart.
class HeatmapDashboard extends StatefulWidget {
  final List<EnforcementZone> zones;

  const HeatmapDashboard({super.key, required this.zones});

  @override
  State<HeatmapDashboard> createState() => _HeatmapDashboardState();
}

class _HeatmapDashboardState extends State<HeatmapDashboard> {
  int _selectedPeriod = 2; // default: Month

  // Multipliers to simulate accumulated data for week/month/year
  int get _multiplier {
    switch (_selectedPeriod) {
      case 0:
        return 1; // Day
      case 1:
        return 7; // Week
      case 2:
        return 30; // Month
      case 3:
        return 365; // Year
      default:
        return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final stats = HeatmapStats.fromZones(widget.zones);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        const Row(
          children: [
            Icon(Icons.analytics_outlined,
                size: 18, color: Color(0xFF1F2937)),
            SizedBox(width: 8),
            Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2937),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Period selector
        _buildPeriodSelector(),
        const SizedBox(height: 14),

        // 4 Summary cards
        Row(
          children: [
            _buildSummaryCard(
              'Plates Checked',
              '${stats.totalChecked * _multiplier}',
              Icons.directions_car_outlined,
              const Color(0xFF6366F1),
            ),
            const SizedBox(width: 8),
            _buildSummaryCard(
              'No Permit',
              '${stats.noPermitCount * _multiplier}',
              Icons.warning_amber_outlined,
              const Color(0xFFEF4444),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildSummaryCard(
              'Compounds',
              '${stats.compoundCount * _multiplier}',
              Icons.receipt_long_outlined,
              const Color(0xFFF59E0B),
            ),
            const SizedBox(width: 8),
            _buildSummaryCard(
              'OPNs Issued',
              '${stats.opnCount * _multiplier}',
              Icons.description_outlined,
              const Color(0xFFF5A623),
            ),
          ],
        ),
        const SizedBox(height: 18),

        // Violation by Zone — bar chart
        _buildViolationBarChart(),
        const SizedBox(height: 18),

        // Status Distribution — donut chart
        _buildStatusDonut(stats),
      ],
    );
  }

  Widget _buildPeriodSelector() {
    final labels = ['Day', 'Week', 'Month', 'Year'];
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        children: List.generate(4, (i) {
          final isSelected = _selectedPeriod == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedPeriod = i),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: isSelected
                      ? Border.all(color: const Color(0xFFE5E7EB), width: 1)
                      : null,
                ),
                child: Center(
                  child: Text(
                    labels[i],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? const Color(0xFF1F2937)
                          : const Color(0xFF9CA3AF),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF3F4F6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Icon(icon, size: 14, color: color),
                ),
                const Spacer(),
                Icon(Icons.trending_up, size: 14, color: color),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViolationBarChart() {
    // Aggregate sub-zones by area name
    final areaViolations = <String, int>{};
    final areaSeverities = <String, ZoneSeverity>{};
    for (final zone in widget.zones) {
      areaViolations[zone.name] = (areaViolations[zone.name] ?? 0) + zone.violationCount;
      // Keep the worst severity for bar coloring
      final existing = areaSeverities[zone.name];
      if (existing == null || zone.severity.index > existing.index) {
        areaSeverities[zone.name] = zone.severity;
      }
    }

    // Sort by violation count descending
    final sortedNames = areaViolations.keys.toList()
      ..sort((a, b) => areaViolations[b]!.compareTo(areaViolations[a]!));
    final maxVal = sortedNames.isEmpty ? 1 : areaViolations[sortedNames.first]! * _multiplier;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Violations by Zone',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 14),
          ...sortedNames.map((name) {
            final val = areaViolations[name]! * _multiplier;
            final fraction = maxVal > 0 ? val / maxVal : 0.0;
            final color = zoneSeverityColor(areaSeverities[name]!);
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF4B5563),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          height: 18,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: fraction.clamp(0.02, 1.0),
                          child: Container(
                            height: 18,
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 4),
                            child: Text(
                              '$val',
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStatusDonut(HeatmapStats stats) {
    final segments = <_DonutSeg>[
      _DonutSeg('No Permit', stats.noPermitCount, const Color(0xFFEF4444)),
      _DonutSeg('Compound', stats.compoundCount, const Color(0xFFF59E0B)),
      _DonutSeg('OPN', stats.opnCount, const Color(0xFFF5A623)),
      _DonutSeg('eCoupon', stats.eCouponCount, const Color(0xFF10B981)),
      _DonutSeg('Season', stats.seasonPassCount, const Color(0xFF3B82F6)),
    ];
    final total =
        segments.fold<int>(0, (s, seg) => s + seg.value);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Status Distribution',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: Row(
              children: [
                // Donut
                Expanded(
                  flex: 3,
                  child: CustomPaint(
                    painter: _DonutPainter(segments: segments, total: total),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$total',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Legend
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: segments
                        .map((s) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: s.color,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      '${s.label} (${s.value})',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF4B5563),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Donut Painter ──────────────────────────────────────────────────────

class _DonutSeg {
  final String label;
  final int value;
  final Color color;
  const _DonutSeg(this.label, this.value, this.color);
}

class _DonutPainter extends CustomPainter {
  final List<_DonutSeg> segments;
  final int total;

  _DonutPainter({required this.segments, required this.total});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 4;
    const strokeW = 20.0;
    double startAngle = -math.pi / 2;

    for (final seg in segments) {
      if (total == 0) continue;
      final sweep = (seg.value / total) * 2 * math.pi;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweep,
        false,
        Paint()
          ..color = seg.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeW
          ..strokeCap = StrokeCap.butt,
      );
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
