import 'package:flutter/material.dart';
import '../staff_movement_data.dart';

/// Enriched staff card with status-aware tinting, activity stats, and inactivity badge.
class StaffCard extends StatelessWidget {
  final StaffMember staff;
  final VoidCallback? onTap;
  final DateTime now;

  const StaffCard({
    super.key,
    required this.staff,
    this.onTap,
    required this.now,
  });

  @override
  Widget build(BuildContext context) {
    final status = staff.getStatus(now);
    final bgColor = statusBgTint(status);
    final dotColor = statusColor(status);
    final inactivityLabel = staff.getInactivityLabel(now);

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _getBorderColor(status)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Left accent strip
              Container(width: 4, color: dotColor),
              Expanded(child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Status dot + Name + Badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status dot
                Container(
                  margin: const EdgeInsets.only(top: 4, right: 10),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dotColor,
                    boxShadow: [
                      BoxShadow(
                        color: dotColor.withValues(alpha: 0.3),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                // Name + ID
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5A623).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              staff.pwid,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFD4891A)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              staff.name,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Status badge
                _buildStatusBadge(status, inactivityLabel, dotColor),
              ],
            ),

            const SizedBox(height: 8),

            // Row 2: Area + Last Updated
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  const Icon(Icons.location_on, size: 13, color: Color(0xFFF5A623)),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      staff.area,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF6B7280)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    staff.latestTimestamp,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF9CA3AF)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Row 3: Activity stats
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  _buildStatChip(Icons.camera_alt_outlined, '${staff.imagesCount}', const Color(0xFF3B82F6)),
                  const SizedBox(width: 12),
                  _buildStatChip(Icons.receipt_long_outlined, '${staff.compoundsCount}', const Color(0xFFF5A623)),
                  const SizedBox(width: 12),
                  _buildStatChip(Icons.description_outlined, '${staff.opnsCount}', const Color(0xFF8B5CF6)),
                  const Spacer(),
                  const Icon(Icons.chevron_right, size: 18, color: Color(0xFFD1D5DB)),
                ],
              ),
            ),
          ],
        ),
      )),
      ],
      ),
      ),
      ),
    );
  }

  Widget _buildStatusBadge(StaffStatus status, String label, Color color) {
    if (status == StaffStatus.active) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (status == StaffStatus.criticalInactive || status == StaffStatus.warningInactive)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(Icons.warning_amber_rounded, size: 11, color: color),
            ),
          if (status == StaffStatus.lunch)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(Icons.restaurant, size: 11, color: color),
            ),
          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color.withValues(alpha: 0.7)),
        const SizedBox(width: 3),
        Text(value, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
      ],
    );
  }

  Color _getBorderColor(StaffStatus status) {
    if (status == StaffStatus.criticalInactive) return const Color(0xFFFECACA);
    if (status == StaffStatus.warningInactive) return const Color(0xFFFDE68A);
    return const Color(0xFFF3F4F6);
  }
}
