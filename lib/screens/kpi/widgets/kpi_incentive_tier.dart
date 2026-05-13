import 'package:flutter/material.dart';

/// Incentive tier levels based on BOTH compounds/month AND OPNs/month.
/// Upgrade requires BOTH metrics to exceed current tier thresholds.
/// Incentives are finalized at the end of each month (payday).
enum IncentiveTier { bronze, silver, gold, platinum }

/// Tier thresholds.
class TierThreshold {
  final IncentiveTier tier;
  final String name;
  final int minCompounds;
  final int minOPNs;
  final int bonusRM;
  final Color color;
  final IconData icon;

  const TierThreshold({
    required this.tier,
    required this.name,
    required this.minCompounds,
    required this.minOPNs,
    required this.bonusRM,
    required this.color,
    required this.icon,
  });
}

const kTiers = [
  TierThreshold(tier: IncentiveTier.bronze, name: 'Bronze', minCompounds: 0, minOPNs: 0, bonusRM: 0,
    color: Color(0xFFCD7F32), icon: Icons.shield_outlined),
  TierThreshold(tier: IncentiveTier.silver, name: 'Silver', minCompounds: 131, minOPNs: 51, bonusRM: 150,
    color: Color(0xFF9CA3AF), icon: Icons.shield),
  TierThreshold(tier: IncentiveTier.gold, name: 'Gold', minCompounds: 261, minOPNs: 121, bonusRM: 350,
    color: Color(0xFFF59E0B), icon: Icons.shield),
  TierThreshold(tier: IncentiveTier.platinum, name: 'Platinum', minCompounds: 401, minOPNs: 201, bonusRM: 600,
    color: Color(0xFF8B5CF6), icon: Icons.workspace_premium),
];

/// Returns the current tier based on monthly compounds AND OPNs.
/// Both must meet the threshold to qualify.
TierThreshold getCurrentTier(int monthlyCompounds, int monthlyOPNs) {
  TierThreshold current = kTiers[0];
  for (final tier in kTiers) {
    if (monthlyCompounds >= tier.minCompounds && monthlyOPNs >= tier.minOPNs) {
      current = tier;
    }
  }
  return current;
}

/// Returns the next tier (or null if already platinum).
TierThreshold? getNextTier(int monthlyCompounds, int monthlyOPNs) {
  final current = getCurrentTier(monthlyCompounds, monthlyOPNs);
  final idx = kTiers.indexOf(current);
  if (idx < kTiers.length - 1) return kTiers[idx + 1];
  return null;
}

/// Performance status based on tier + pace analysis.
enum PerformanceStatus { overperforming, onTrack, underperforming }

PerformanceStatus getPerformanceStatus(int monthlyCompounds, int monthlyOPNs, int dayOfMonth, int daysInMonth) {
  // Calculate expected pace to reach at least Silver by end of month
  final fractionElapsed = dayOfMonth / daysInMonth;
  final tier = getCurrentTier(monthlyCompounds, monthlyOPNs);

  if (tier.tier == IncentiveTier.gold || tier.tier == IncentiveTier.platinum) {
    return PerformanceStatus.overperforming;
  }

  // If Silver and pace is good for Gold
  if (tier.tier == IncentiveTier.silver) {
    final compoundsPace = monthlyCompounds / fractionElapsed;
    final opnsPace = monthlyOPNs / fractionElapsed;
    if (compoundsPace >= 261 && opnsPace >= 121) return PerformanceStatus.overperforming;
    return PerformanceStatus.onTrack;
  }

  // Bronze — check if pace suggests reaching Silver
  if (fractionElapsed > 0) {
    final compoundsPace = monthlyCompounds / fractionElapsed;
    final opnsPace = monthlyOPNs / fractionElapsed;
    if (compoundsPace >= 131 && opnsPace >= 51) return PerformanceStatus.onTrack;
  }
  return PerformanceStatus.underperforming;
}

/// Per-staff monthly incentive data for the dropdown.
class StaffMonthlyData {
  final String pwid;
  final String name;
  final int monthlyCompounds;
  final int monthlyOPNs;
  final int monthlyImages;
  final String monthlyRevenue;
  final IncentiveTier? goalTier; // null = no goal set

  const StaffMonthlyData({
    required this.pwid,
    required this.name,
    required this.monthlyCompounds,
    required this.monthlyOPNs,
    required this.monthlyImages,
    required this.monthlyRevenue,
    this.goalTier,
  });
}

/// Dummy per-staff monthly data showing different use cases.
final kStaffMonthlyData = <String, StaffMonthlyData>{
  'Mas Anak Mani': StaffMonthlyData(
    pwid: 'PW1201',
    name: 'Mas Anak Mani',
    monthlyCompounds: 342,
    monthlyOPNs: 156,
    monthlyImages: 1284,
    monthlyRevenue: 'RM 13,680',
    goalTier: IncentiveTier.platinum, // Gold → aiming for Platinum
  ),
  'Ahmad Bin Ismail': StaffMonthlyData(
    pwid: 'PW1202',
    name: 'Ahmad Bin Ismail',
    monthlyCompounds: 180,
    monthlyOPNs: 72,
    monthlyImages: 820,
    monthlyRevenue: 'RM 7,200',
    goalTier: IncentiveTier.gold, // Silver → aiming for Gold
  ),
  'Siti Binti Yusof': StaffMonthlyData(
    pwid: 'PW1203',
    name: 'Siti Binti Yusof',
    monthlyCompounds: 95,
    monthlyOPNs: 38,
    monthlyImages: 480,
    monthlyRevenue: 'RM 3,800',
    goalTier: IncentiveTier.silver, // Bronze → aiming for Silver
  ),
  'Betty Anak Darin': StaffMonthlyData(
    pwid: 'PW1204',
    name: 'Betty Anak Darin',
    monthlyCompounds: 420,
    monthlyOPNs: 210,
    monthlyImages: 1580,
    monthlyRevenue: 'RM 16,800',
    goalTier: null, // Platinum — already at max
  ),
};

/// Widget showing the incentive tier badge, progress to goal, payday countdown.
/// Only uses MONTHLY totals for tier calculation (incentives finalized end of month).
class KpiIncentiveTier extends StatelessWidget {
  final int monthlyCompounds;
  final int monthlyOPNs;
  final IncentiveTier? goalTier; // user-set goal
  final VoidCallback? onSetGoal;

  const KpiIncentiveTier({
    super.key,
    required this.monthlyCompounds,
    required this.monthlyOPNs,
    this.goalTier,
    this.onSetGoal,
  });

  @override
  Widget build(BuildContext context) {
    final current = getCurrentTier(monthlyCompounds, monthlyOPNs);
    final next = getNextTier(monthlyCompounds, monthlyOPNs);

    // Payday countdown — end of current month
    final now = DateTime.now();
    final endOfMonth = DateTime(now.year, now.month + 1, 0);
    final daysLeft = endOfMonth.day - now.day;
    final daysInMonth = endOfMonth.day;
    final perfStatus = getPerformanceStatus(monthlyCompounds, monthlyOPNs, now.day, daysInMonth);

    // Determine the goal target tier
    TierThreshold? goalTarget;
    if (goalTier != null) {
      goalTarget = kTiers.firstWhere((t) => t.tier == goalTier);
      // Only show goal if it's above current tier
      final currentIdx = kTiers.indexOf(current);
      final goalIdx = kTiers.indexOf(goalTarget);
      if (goalIdx <= currentIdx) goalTarget = null;
    }
    // Default to next tier if no goal set
    final displayTarget = goalTarget ?? next;

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
          // Header: title + performance badge
          Row(
            children: [
              const Text('Monthly Incentive', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
              const Spacer(),
              _buildPerformanceBadge(perfStatus),
            ],
          ),
          const SizedBox(height: 4),
          // Payday countdown
          Row(
            children: [
              const Icon(Icons.schedule_outlined, size: 13, color: Color(0xFF9CA3AF)),
              const SizedBox(width: 4),
              Text(
                '$daysLeft day${daysLeft == 1 ? '' : 's'} until payday (end of month)',
                style: TextStyle(
                  fontSize: 11,
                  color: daysLeft <= 5 ? const Color(0xFFEF4444) : const Color(0xFF9CA3AF),
                  fontWeight: daysLeft <= 5 ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Current tier badge + incentive amount
          Row(
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [current.color.withValues(alpha: 0.15), current.color.withValues(alpha: 0.05)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: current.color.withValues(alpha: 0.3)),
                ),
                child: Icon(current.icon, size: 24, color: current.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(current.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: current.color)),
                        const SizedBox(width: 6),
                        const Text('Tier', style: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF))),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text('Projected: RM ${current.bonusRM}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF6B7280))),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F2937),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('RM ${current.bonusRM}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Progress to goal / next tier
          if (displayTarget != null) ...[
            // Goal header with set/change button
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: displayTarget.color.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: displayTarget.color.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(goalTarget != null ? Icons.flag : Icons.arrow_upward, size: 12, color: displayTarget.color),
                      const SizedBox(width: 4),
                      Text(
                        goalTarget != null ? 'Goal: ${displayTarget.name}' : 'Next: ${displayTarget.name}',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: displayTarget.color),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onSetGoal,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(goalTarget != null ? Icons.edit : Icons.flag_outlined, size: 12, color: const Color(0xFF6B7280)),
                        const SizedBox(width: 4),
                        Text(goalTarget != null ? 'Change' : 'Set Goal', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF6B7280))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Compounds progress
            _buildProgressRow(
              'Compounds',
              monthlyCompounds,
              displayTarget.minCompounds,
              const Color(0xFFF5A623),
              daysLeft,
            ),
            const SizedBox(height: 8),

            // OPNs progress
            _buildProgressRow(
              'OPNs',
              monthlyOPNs,
              displayTarget.minOPNs,
              const Color(0xFF8B5CF6),
              daysLeft,
            ),

            const SizedBox(height: 10),

            // Tier upgrade bonus info
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: displayTarget.color.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: displayTarget.color.withValues(alpha: 0.12)),
              ),
              child: Row(
                children: [
                  Icon(Icons.emoji_events_outlined, size: 14, color: displayTarget.color),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Reach ${displayTarget.name} for RM ${displayTarget.bonusRM} incentive (+RM ${displayTarget.bonusRM - current.bonusRM})',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: displayTarget.color),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            // Requirement note
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFF3F4F6)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, size: 13, color: Color(0xFF9CA3AF)),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Both Compounds and OPNs must exceed thresholds. Incentive based on monthly totals only.',
                      style: TextStyle(fontSize: 10, color: Color(0xFF9CA3AF)),
                    ),
                  ),
                ],
              ),
            ),
          ] else
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: current.color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.emoji_events, size: 18, color: current.color),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text('Maximum tier achieved! RM ${current.bonusRM} secured.', 
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: current.color),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // All tiers overview strip
          const SizedBox(height: 14),
          _buildTierStrip(current),
        ],
      ),
    );
  }

  Widget _buildProgressRow(String label, int currentVal, int target, Color color, int daysLeft) {
    final fraction = target > 0 ? (currentVal / target).clamp(0.0, 1.0) : 0.0;
    final remaining = (target - currentVal).clamp(0, target);
    final bool metThreshold = currentVal >= target;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF4B5563))),
                if (metThreshold) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.check_circle, size: 12, color: Color(0xFF10B981)),
                ],
              ],
            ),
            metThreshold
                ? Text('$currentVal / $target ✓', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF10B981)))
                : Text('$currentVal / $target  ($remaining more · ~${daysLeft > 0 ? (remaining / daysLeft).ceil() : remaining}/day)', style: const TextStyle(fontSize: 10, color: Color(0xFF9CA3AF))),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: 6,
            child: Stack(
              children: [
                Container(color: const Color(0xFFF3F4F6)),
                FractionallySizedBox(
                  widthFactor: fraction,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        metThreshold ? const Color(0xFF10B981) : color,
                        metThreshold ? const Color(0xFF10B981).withValues(alpha: 0.7) : color.withValues(alpha: 0.7),
                      ]),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTierStrip(TierThreshold currentTier) {
    return Row(
      children: kTiers.map((tier) {
        final isCurrent = tier.tier == currentTier.tier;
        final isPast = kTiers.indexOf(tier) < kTiers.indexOf(currentTier);
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: isCurrent ? tier.color.withValues(alpha: 0.12) : (isPast ? const Color(0xFFF3F4F6) : const Color(0xFFFAFAFA)),
              borderRadius: BorderRadius.circular(6),
              border: isCurrent ? Border.all(color: tier.color.withValues(alpha: 0.4), width: 1.5) : null,
            ),
            child: Column(
              children: [
                Icon(tier.icon, size: 14, color: isCurrent ? tier.color : (isPast ? const Color(0xFF9CA3AF) : const Color(0xFFD1D5DB))),
                const SizedBox(height: 2),
                Text(tier.name, style: TextStyle(fontSize: 8, fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w500,
                  color: isCurrent ? tier.color : (isPast ? const Color(0xFF9CA3AF) : const Color(0xFFD1D5DB)))),
                Text('RM ${tier.bonusRM}', style: TextStyle(fontSize: 7, color: isCurrent ? tier.color : const Color(0xFFD1D5DB))),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPerformanceBadge(PerformanceStatus status) {
    final (label, color, icon) = switch (status) {
      PerformanceStatus.overperforming => ('Overperforming', const Color(0xFF10B981), Icons.trending_up),
      PerformanceStatus.onTrack => ('On Track', const Color(0xFF3B82F6), Icons.check_circle_outline),
      PerformanceStatus.underperforming => ('Underperforming', const Color(0xFFEF4444), Icons.trending_down),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }
}
