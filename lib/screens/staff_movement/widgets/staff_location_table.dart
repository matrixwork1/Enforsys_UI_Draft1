import 'package:flutter/material.dart';
import '../staff_movement_data.dart';

/// Enriched table with status column, row tinting, and visual hierarchy.
class StaffLocationTable extends StatelessWidget {
  final List<StaffMember> staff;
  final void Function(StaffMember) onStaffTap;
  final DateTime now;

  const StaffLocationTable({
    super.key,
    required this.staff,
    required this.onStaffTap,
    required this.now,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFFF9FAFB),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
            ),
            child: const Row(
              children: [
                SizedBox(width: 28, child: Text('', style: TextStyle(fontSize: 10))), // status dot column
                SizedBox(width: 48, child: Text('PWID', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF6B7280)))),
                SizedBox(width: 6),
                Expanded(flex: 3, child: Text('Staff', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF6B7280)))),
                Expanded(flex: 2, child: Text('Last Seen', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF6B7280)))),
                Expanded(flex: 3, child: Text('Address', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF6B7280)))),
              ],
            ),
          ),
          // Rows
          ...List.generate(staff.length, (index) {
            final s = staff[index];
            final isLast = index == staff.length - 1;
            final status = s.getStatus(now);
            final dotColor = statusColor(status);
            final rowBg = statusBgTint(status);
            final isCritical = status == StaffStatus.criticalInactive;

            return GestureDetector(
              onTap: () => onStaffTap(s),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: rowBg,
                  borderRadius: isLast
                      ? const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12))
                      : null,
                  border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
                ),
                child: Row(
                  children: [
                    // Status dot
                    SizedBox(
                      width: 28,
                      child: Center(
                        child: Container(
                          width: 8, height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: dotColor,
                            boxShadow: [BoxShadow(color: dotColor.withValues(alpha: 0.3), blurRadius: 3)],
                          ),
                        ),
                      ),
                    ),
                    // PWID badge
                    Container(
                      width: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5A623).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        s.pwid,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFFD4891A)),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      flex: 3,
                      child: Text(
                        s.name,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isCritical ? FontWeight.w700 : FontWeight.w600,
                          color: isCritical ? const Color(0xFFEF4444) : const Color(0xFF1F2937),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        s.latestTimestamp,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isCritical ? FontWeight.w600 : FontWeight.w400,
                          color: isCritical ? const Color(0xFFEF4444) : const Color(0xFF6B7280),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        s.latestAddress,
                        style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
