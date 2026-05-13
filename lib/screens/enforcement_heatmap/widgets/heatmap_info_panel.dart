import 'package:flutter/material.dart';
import '../enforcement_heatmap_data.dart';

/// Bottom sheet info panel for viewing details about a zone or a plate marker.
class HeatmapInfoPanel {
  /// Shows zone details in a bottom sheet.
  static void showZoneDetails(BuildContext context, EnforcementZone zone) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(ctx).size.height * 0.85,
          ),
          child: _ZoneDetailSheet(zone: zone),
        ),
      ),
    );
  }

  /// Shows plate marker details in a bottom sheet.
  static void showMarkerDetails(BuildContext context, PlateMarker plate) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: _MarkerDetailSheet(plate: plate),
      ),
    );
  }
}

// ─── Zone Detail Sheet ──────────────────────────────────────────────────

class _ZoneDetailSheet extends StatelessWidget {
  final EnforcementZone zone;

  const _ZoneDetailSheet({
    required this.zone,
  });

  @override
  Widget build(BuildContext context) {
    final color = zoneSeverityColor(zone.severity);
    final violationPlates = zone.plates
        .where((p) =>
            p.status == PlateStatus.noPermitFound ||
            p.status == PlateStatus.compoundIssued ||
            p.status == PlateStatus.opnIssued)
        .toList();
    final validPlates = zone.plates
        .where((p) =>
            p.status == PlateStatus.activeECoupon ||
            p.status == PlateStatus.activeSeasonPass)
        .toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: ListView(
        shrinkWrap: true,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD1D5DB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.layers, size: 20, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      zone.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            zoneSeverityLabel(zone.severity).toUpperCase(),
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: color,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${zone.totalPlates} plates checked',
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF6B7280)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Status breakdown mini-cards
          Row(
            children: [
              _buildMiniStat(
                'No Permit',
                zone.countByStatus(PlateStatus.noPermitFound),
                const Color(0xFFEF4444),
              ),
              const SizedBox(width: 8),
              _buildMiniStat(
                'Compound',
                zone.countByStatus(PlateStatus.compoundIssued),
                const Color(0xFFF59E0B),
              ),
              const SizedBox(width: 8),
              _buildMiniStat(
                'OPN',
                zone.countByStatus(PlateStatus.opnIssued),
                const Color(0xFFF5A623),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildMiniStat(
                'eCoupon',
                zone.countByStatus(PlateStatus.activeECoupon),
                const Color(0xFF10B981),
              ),
              const SizedBox(width: 8),
              _buildMiniStat(
                'Season',
                zone.countByStatus(PlateStatus.activeSeasonPass),
                const Color(0xFF3B82F6),
              ),
              const SizedBox(width: 8),
              const Expanded(child: SizedBox()),
            ],
          ),
          const SizedBox(height: 20),

          // Violation plates list
          if (violationPlates.isNotEmpty) ...[
            const Text(
              'Violation Plates',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),
            ...violationPlates.map((p) => _buildPlateRow(p)),
          ],

          if (validPlates.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Valid Plates',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),
            ...validPlates.map((p) => _buildPlateRow(p)),
          ],
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, int count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: color.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlateRow(PlateMarker plate) {
    final color = plateStatusColor(plate.status);
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plate.plateNumber,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${plate.dateTime}  •  ${plate.wardenName} (PWID ${plate.wardenPwid})',
                  style: const TextStyle(
                      fontSize: 10, color: Color(0xFF9CA3AF)),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              plateStatusLabel(plate.status),
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Marker Detail Sheet ────────────────────────────────────────────────

class _MarkerDetailSheet extends StatelessWidget {
  final PlateMarker plate;

  const _MarkerDetailSheet({required this.plate});

  @override
  Widget build(BuildContext context) {
    final color = plateStatusColor(plate.status);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD1D5DB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Plate number hero
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                Text(
                  plate.plateNumber,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1F2937),
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        plateStatusLabel(plate.status),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Detail rows
          _buildDetailRow(Icons.location_on_outlined, 'Zone', plate.zone),
          _buildDetailRow(
              Icons.access_time_outlined, 'Date & Time', plate.dateTime),
          _buildDetailRow(Icons.gps_fixed_outlined, 'Coordinates',
              '${plate.coordinates.dx.toStringAsFixed(4)}, ${plate.coordinates.dy.toStringAsFixed(4)}'),
          _buildDetailRow(
              Icons.person_outline, 'Checked By', '${plate.wardenName} (PWID ${plate.wardenPwid})'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: const Color(0xFF6B7280)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF9CA3AF),
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
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
