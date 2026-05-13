import 'dart:math';
import 'package:flutter/material.dart';

// ─── Enums ─────────────────────────────────────────────────────────────

/// Parking enforcement status for an individual car plate.
enum PlateStatus {
  activeECoupon,
  activeSeasonPass,
  noPermitFound,
  compoundIssued,
  opnIssued,
}

/// Severity level for enforcement zones.
enum ZoneSeverity { clear, moderate, high, critical }

/// Priority level for AI patrol recommendations.
enum PatrolPriority { critical, high, medium, low }

// ─── Color Helpers ─────────────────────────────────────────────────────

/// Returns the dot color for a given plate status.
Color plateStatusColor(PlateStatus status) {
  switch (status) {
    case PlateStatus.activeECoupon:
      return const Color(0xFF10B981); // Green
    case PlateStatus.activeSeasonPass:
      return const Color(0xFF3B82F6); // Blue
    case PlateStatus.noPermitFound:
      return const Color(0xFFEF4444); // Red
    case PlateStatus.compoundIssued:
      return const Color(0xFFF59E0B); // Amber
    case PlateStatus.opnIssued:
      return const Color(0xFFF5A623); // Orange (brand accent)
  }
}

/// Human-readable label for a plate status.
String plateStatusLabel(PlateStatus status) {
  switch (status) {
    case PlateStatus.activeECoupon:
      return 'Active eCoupon';
    case PlateStatus.activeSeasonPass:
      return 'Active Season Pass';
    case PlateStatus.noPermitFound:
      return 'No Parking Permit Found';
    case PlateStatus.compoundIssued:
      return 'Compound Issued';
    case PlateStatus.opnIssued:
      return 'OPN Issued';
  }
}

/// Returns the polygon fill color for a zone severity.
Color zoneSeverityColor(ZoneSeverity severity) {
  switch (severity) {
    case ZoneSeverity.clear:
      return const Color(0xFF10B981); // Green
    case ZoneSeverity.moderate:
      return const Color(0xFFFBBF24); // Yellow
    case ZoneSeverity.high:
      return const Color(0xFFF59E0B); // Amber
    case ZoneSeverity.critical:
      return const Color(0xFFEF4444); // Red
  }
}

/// Opacity for zone polygon fill.
double zoneSeverityOpacity(ZoneSeverity severity) {
  switch (severity) {
    case ZoneSeverity.clear:
      return 0.15;
    case ZoneSeverity.moderate:
      return 0.20;
    case ZoneSeverity.high:
      return 0.25;
    case ZoneSeverity.critical:
      return 0.30;
  }
}

/// Human-readable severity label.
String zoneSeverityLabel(ZoneSeverity severity) {
  switch (severity) {
    case ZoneSeverity.clear:
      return 'Clear';
    case ZoneSeverity.moderate:
      return 'Moderate';
    case ZoneSeverity.high:
      return 'High';
    case ZoneSeverity.critical:
      return 'Critical';
  }
}

/// Color for patrol priority badges.
Color patrolPriorityColor(PatrolPriority priority) {
  switch (priority) {
    case PatrolPriority.critical:
      return const Color(0xFFEF4444);
    case PatrolPriority.high:
      return const Color(0xFFF59E0B);
    case PatrolPriority.medium:
      return const Color(0xFF3B82F6);
    case PatrolPriority.low:
      return const Color(0xFF10B981);
  }
}

// ─── Models ─────────────────────────────────────────────────────────────

/// An individual car plate marker on the map.
class PlateMarker {
  final String plateNumber;
  final PlateStatus status;
  final String zone;
  final Offset coordinates; // normalised 0..1
  final String dateTime;
  final String wardenPwid;
  final String wardenName;

  const PlateMarker({
    required this.plateNumber,
    required this.status,
    required this.zone,
    required this.coordinates,
    required this.dateTime,
    required this.wardenPwid,
    required this.wardenName,
  });
}

/// A polygon enforcement zone on the map.
class EnforcementZone {
  final String name;
  final List<Offset> polygonPoints; // normalised 0..1
  final Offset labelPosition; // centre of polygon for label
  final List<PlateMarker> plates;

  EnforcementZone({
    required this.name,
    required this.polygonPoints,
    required this.labelPosition,
    required this.plates,
  });

  int get totalPlates => plates.length;
  int get violationCount => plates.where((p) =>
      p.status == PlateStatus.noPermitFound ||
      p.status == PlateStatus.compoundIssued ||
      p.status == PlateStatus.opnIssued).length;

  ZoneSeverity get severity {
    if (violationCount >= 3) return ZoneSeverity.critical;
    if (violationCount >= 2) return ZoneSeverity.high;
    if (violationCount >= 1) return ZoneSeverity.moderate;
    return ZoneSeverity.clear;
  }

  int countByStatus(PlateStatus status) =>
      plates.where((p) => p.status == status).length;
}

/// AI patrol recommendation.
class PatrolRecommendation {
  final String zone;
  final PatrolPriority priority;
  final String reason;
  final double confidenceScore; // 0.0 – 1.0
  final String suggestedTime;
  final String icon;

  const PatrolRecommendation({
    required this.zone,
    required this.priority,
    required this.reason,
    required this.confidenceScore,
    required this.suggestedTime,
    this.icon = '🎯',
  });
}

// ─── Zone Definitions (Sibu Parking Sub-Zones) ─────────────────────────

/// Each named area is subdivided into smaller irregular parking zones.
/// These sub-zones have organic, non-rectangular polygon shapes to denote
/// individual parking spots/lots within a larger area. No individual zone
/// names are shown on the map — only the area name in the info panel.
final List<_ZoneTemplate> _zoneTemplates = [
  // ── Pusat Pedada — 3 sub-zones ────────────────────────────────────
  _ZoneTemplate(
    name: 'Pusat Pedada',
    polygon: [Offset(0.03, 0.32), Offset(0.11, 0.30), Offset(0.14, 0.38), Offset(0.10, 0.44), Offset(0.04, 0.42)],
    label: Offset(0.08, 0.37),
  ),
  _ZoneTemplate(
    name: 'Pusat Pedada',
    polygon: [Offset(0.14, 0.31), Offset(0.22, 0.33), Offset(0.21, 0.42), Offset(0.16, 0.45), Offset(0.13, 0.39)],
    label: Offset(0.17, 0.38),
  ),
  _ZoneTemplate(
    name: 'Pusat Pedada',
    polygon: [Offset(0.04, 0.45), Offset(0.12, 0.43), Offset(0.18, 0.46), Offset(0.16, 0.53), Offset(0.06, 0.52)],
    label: Offset(0.10, 0.48),
  ),

  // ── Dewan Suarah — 3 sub-zones ────────────────────────────────────
  _ZoneTemplate(
    name: 'Dewan Suarah',
    polygon: [Offset(0.25, 0.31), Offset(0.35, 0.30), Offset(0.37, 0.40), Offset(0.30, 0.43), Offset(0.24, 0.38)],
    label: Offset(0.30, 0.36),
  ),
  _ZoneTemplate(
    name: 'Dewan Suarah',
    polygon: [Offset(0.37, 0.31), Offset(0.46, 0.32), Offset(0.47, 0.42), Offset(0.40, 0.44), Offset(0.36, 0.40)],
    label: Offset(0.42, 0.37),
  ),
  _ZoneTemplate(
    name: 'Dewan Suarah',
    polygon: [Offset(0.26, 0.44), Offset(0.35, 0.43), Offset(0.42, 0.45), Offset(0.40, 0.54), Offset(0.28, 0.53)],
    label: Offset(0.34, 0.48),
  ),

  // ── Jalan Maju — 2 sub-zones ──────────────────────────────────────
  _ZoneTemplate(
    name: 'Jalan Maju',
    polygon: [Offset(0.51, 0.31), Offset(0.62, 0.30), Offset(0.64, 0.41), Offset(0.56, 0.44), Offset(0.50, 0.38)],
    label: Offset(0.57, 0.36),
  ),
  _ZoneTemplate(
    name: 'Jalan Maju',
    polygon: [Offset(0.55, 0.44), Offset(0.65, 0.42), Offset(0.70, 0.46), Offset(0.68, 0.54), Offset(0.53, 0.53)],
    label: Offset(0.62, 0.48),
  ),

  // ── KPJ Carpark — 2 sub-zones ─────────────────────────────────────
  _ZoneTemplate(
    name: 'KPJ Carpark',
    polygon: [Offset(0.75, 0.31), Offset(0.86, 0.30), Offset(0.88, 0.40), Offset(0.80, 0.43), Offset(0.74, 0.37)],
    label: Offset(0.81, 0.36),
  ),
  _ZoneTemplate(
    name: 'KPJ Carpark',
    polygon: [Offset(0.80, 0.44), Offset(0.92, 0.42), Offset(0.96, 0.47), Offset(0.93, 0.54), Offset(0.78, 0.53)],
    label: Offset(0.87, 0.48),
  ),

  // ── CBD — 4 sub-zones ─────────────────────────────────────────────
  _ZoneTemplate(
    name: 'CBD',
    polygon: [Offset(0.03, 0.06), Offset(0.15, 0.05), Offset(0.17, 0.14), Offset(0.10, 0.17), Offset(0.04, 0.13)],
    label: Offset(0.10, 0.11),
  ),
  _ZoneTemplate(
    name: 'CBD',
    polygon: [Offset(0.17, 0.05), Offset(0.28, 0.06), Offset(0.30, 0.16), Offset(0.22, 0.18), Offset(0.16, 0.14)],
    label: Offset(0.23, 0.12),
  ),
  _ZoneTemplate(
    name: 'CBD',
    polygon: [Offset(0.04, 0.17), Offset(0.14, 0.16), Offset(0.18, 0.19), Offset(0.16, 0.26), Offset(0.05, 0.27)],
    label: Offset(0.11, 0.22),
  ),
  _ZoneTemplate(
    name: 'CBD',
    polygon: [Offset(0.18, 0.18), Offset(0.30, 0.17), Offset(0.33, 0.22), Offset(0.31, 0.27), Offset(0.17, 0.26)],
    label: Offset(0.25, 0.22),
  ),

  // ── Jalan Sanyan — 2 sub-zones ────────────────────────────────────
  _ZoneTemplate(
    name: 'Jalan Sanyan',
    polygon: [Offset(0.38, 0.06), Offset(0.50, 0.05), Offset(0.52, 0.16), Offset(0.45, 0.19), Offset(0.37, 0.14)],
    label: Offset(0.45, 0.12),
  ),
  _ZoneTemplate(
    name: 'Jalan Sanyan',
    polygon: [Offset(0.40, 0.18), Offset(0.52, 0.17), Offset(0.58, 0.20), Offset(0.56, 0.27), Offset(0.38, 0.26)],
    label: Offset(0.48, 0.22),
  ),

  // ── Jalan Lanang — 2 sub-zones ────────────────────────────────────
  _ZoneTemplate(
    name: 'Jalan Lanang',
    polygon: [Offset(0.68, 0.06), Offset(0.82, 0.05), Offset(0.84, 0.15), Offset(0.76, 0.18), Offset(0.67, 0.14)],
    label: Offset(0.76, 0.11),
  ),
  _ZoneTemplate(
    name: 'Jalan Lanang',
    polygon: [Offset(0.76, 0.17), Offset(0.90, 0.16), Offset(0.96, 0.20), Offset(0.93, 0.27), Offset(0.74, 0.26)],
    label: Offset(0.85, 0.22),
  ),

  // ── Pasar Sentral — 3 sub-zones ───────────────────────────────────
  _ZoneTemplate(
    name: 'Pasar Sentral',
    polygon: [Offset(0.03, 0.58), Offset(0.16, 0.57), Offset(0.18, 0.66), Offset(0.12, 0.70), Offset(0.04, 0.67)],
    label: Offset(0.10, 0.63),
  ),
  _ZoneTemplate(
    name: 'Pasar Sentral',
    polygon: [Offset(0.18, 0.58), Offset(0.32, 0.57), Offset(0.34, 0.67), Offset(0.26, 0.71), Offset(0.17, 0.67)],
    label: Offset(0.26, 0.63),
  ),
  _ZoneTemplate(
    name: 'Pasar Sentral',
    polygon: [Offset(0.34, 0.58), Offset(0.46, 0.57), Offset(0.47, 0.66), Offset(0.42, 0.71), Offset(0.33, 0.68)],
    label: Offset(0.40, 0.63),
  ),
];

class _ZoneTemplate {
  final String name;
  final List<Offset> polygon;
  final Offset label;
  const _ZoneTemplate({required this.name, required this.polygon, required this.label});
}

// ─── Plate Pool (realistic Sarawak plates) ─────────────────────────────

const List<String> _platePool = [
  'QSA1234', 'QSB5678', 'QKA9012', 'QKB3456', 'QSC7890',
  'QSD2345', 'QSE6789', 'QKC0123', 'QKD4567', 'QSF8901',
  'QSG2345', 'QKE6789', 'QSH0123', 'QSJ4567', 'QKF8901',
  'QSK2345', 'QSL6789', 'QKG0123', 'QKH4567', 'QSM8901',
  'QSN1111', 'QSP2222', 'QKJ3333', 'QKK4444', 'QSQ5555',
  'QSR6666', 'QSS7777', 'QKL8888', 'QKM9999', 'QST1010',
  'QSU2020', 'QSV3030', 'QKN4040', 'QKP5050', 'QSW6060',
  'QSX7070', 'QSY8080', 'QKQ9090', 'QKR1122', 'QSZ3344',
  'QTA5566', 'QTB7788', 'QKS9900', 'QKT2211', 'QTC4433',
];

const List<String> _wardenPwids = ['8531', '2815', '4102', '6273', '3890', '7451'];
const List<String> _wardenNames = ['Ahmad', 'Sarah', 'Michael', 'Nurul', 'David', 'Siti'];

// ─── Plate Distribution Per Zone (weighted towards violations) ──────────

/// Each zone gets a weighted distribution of statuses.
/// Zones like CBD and Jalan Pedada have heavier violations.
final Map<String, List<PlateStatus>> _zoneStatusWeights = {
  'Pusat Pedada':  [PlateStatus.noPermitFound, PlateStatus.noPermitFound, PlateStatus.noPermitFound, PlateStatus.compoundIssued, PlateStatus.compoundIssued, PlateStatus.opnIssued, PlateStatus.activeECoupon],
  'Dewan Suarah':  [PlateStatus.noPermitFound, PlateStatus.noPermitFound, PlateStatus.compoundIssued, PlateStatus.opnIssued, PlateStatus.activeECoupon, PlateStatus.activeSeasonPass],
  'Jalan Maju':    [PlateStatus.noPermitFound, PlateStatus.compoundIssued, PlateStatus.activeECoupon, PlateStatus.activeECoupon, PlateStatus.activeSeasonPass],
  'KPJ Carpark':   [PlateStatus.activeSeasonPass, PlateStatus.activeSeasonPass, PlateStatus.activeECoupon, PlateStatus.noPermitFound],
  'CBD':           [PlateStatus.noPermitFound, PlateStatus.noPermitFound, PlateStatus.noPermitFound, PlateStatus.noPermitFound, PlateStatus.compoundIssued, PlateStatus.compoundIssued, PlateStatus.compoundIssued, PlateStatus.opnIssued, PlateStatus.opnIssued, PlateStatus.activeECoupon],
  'Jalan Sanyan':  [PlateStatus.noPermitFound, PlateStatus.noPermitFound, PlateStatus.compoundIssued, PlateStatus.activeECoupon, PlateStatus.activeSeasonPass],
  'Jalan Lanang':  [PlateStatus.activeECoupon, PlateStatus.activeSeasonPass, PlateStatus.activeSeasonPass, PlateStatus.noPermitFound],
  'Pasar Sentral': [PlateStatus.noPermitFound, PlateStatus.noPermitFound, PlateStatus.noPermitFound, PlateStatus.compoundIssued, PlateStatus.compoundIssued, PlateStatus.opnIssued, PlateStatus.activeECoupon, PlateStatus.activeECoupon],
};

// ─── Data Generator ────────────────────────────────────────────────────

/// Generates fresh enforcement zone data.
/// Call this on refresh to simulate new patrol data.
/// Sub-zones sharing the same area name split the status pool.
List<EnforcementZone> generateEnforcementData({int? seed}) {
  final rng = Random(seed);
  int plateIdx = 0;
  final now = DateTime.now();

  // Group templates by area name
  final areaGroups = <String, List<_ZoneTemplate>>{};
  for (final tmpl in _zoneTemplates) {
    areaGroups.putIfAbsent(tmpl.name, () => []).add(tmpl);
  }

  final zones = <EnforcementZone>[];

  for (final entry in areaGroups.entries) {
    final areaName = entry.key;
    final subTemplates = entry.value;
    final statusWeights = _zoneStatusWeights[areaName]!;
    final shuffled = List<PlateStatus>.from(statusWeights)..shuffle(rng);

    // Distribute plates round-robin across sub-zones
    final subPlates = List.generate(subTemplates.length, (_) => <PlateMarker>[]);
    int subIdx = 0;
    for (int i = 0; i < shuffled.length && plateIdx < _platePool.length; i++) {
      final tmpl = subTemplates[subIdx % subTemplates.length];
      final poly = tmpl.polygon;
      final minX = poly.map((p) => p.dx).reduce(min);
      final maxX = poly.map((p) => p.dx).reduce(max);
      final minY = poly.map((p) => p.dy).reduce(min);
      final maxY = poly.map((p) => p.dy).reduce(max);

      final x = minX + rng.nextDouble() * (maxX - minX) * 0.8 + (maxX - minX) * 0.1;
      final y = minY + rng.nextDouble() * (maxY - minY) * 0.8 + (maxY - minY) * 0.1;

      final hour = 7 + rng.nextInt(6);
      final minute = rng.nextInt(60);
      final timeStr = '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} '
          '${hour > 12 ? hour - 12 : hour}:${minute.toString().padLeft(2, '0')} ${hour >= 12 ? 'PM' : 'AM'}';

      final wardenIndex = rng.nextInt(_wardenPwids.length);

      subPlates[subIdx % subTemplates.length].add(PlateMarker(
        plateNumber: _platePool[plateIdx],
        status: shuffled[i],
        zone: areaName,
        coordinates: Offset(x, y),
        dateTime: timeStr,
        wardenPwid: _wardenPwids[wardenIndex],
        wardenName: _wardenNames[wardenIndex],
      ));
      plateIdx++;
      subIdx++;
    }

    // Create an EnforcementZone per sub-template
    for (int s = 0; s < subTemplates.length; s++) {
      zones.add(EnforcementZone(
        name: areaName,
        polygonPoints: subTemplates[s].polygon,
        labelPosition: subTemplates[s].label,
        plates: subPlates[s],
      ));
    }
  }

  return zones;
}

// ─── AI Patrol Recommendations (static prototype) ─────────────────────

/// Generates patrol recommendations based on zone data.
List<PatrolRecommendation> generatePatrolRecommendations(List<EnforcementZone> zones) {
  // Sort zones by violation count descending
  final sorted = List<EnforcementZone>.from(zones)
    ..sort((a, b) => b.violationCount.compareTo(a.violationCount));

  final recommendations = <PatrolRecommendation>[];

  if (sorted.isNotEmpty && sorted[0].violationCount >= 4) {
    final z = sorted[0];
    final noPermit = z.countByStatus(PlateStatus.noPermitFound);
    final pct = ((noPermit / z.totalPlates) * 100).round();
    recommendations.add(PatrolRecommendation(
      zone: z.name,
      priority: PatrolPriority.critical,
      reason: '$pct% of plates in ${z.name} have no parking permit. '
          '${z.violationCount} violations detected — highest concentration.',
      confidenceScore: 0.92,
      suggestedTime: '9:00 AM – 11:00 AM',
      icon: '🔴',
    ));
  }

  if (sorted.length > 1 && sorted[1].violationCount >= 3) {
    final z = sorted[1];
    final compounds = z.countByStatus(PlateStatus.compoundIssued);
    recommendations.add(PatrolRecommendation(
      zone: z.name,
      priority: PatrolPriority.high,
      reason: '${z.name} has $compounds compound(s) already issued and '
          '${z.violationCount} total violations. Recurrence pattern detected.',
      confidenceScore: 0.85,
      suggestedTime: '10:00 AM – 12:00 PM',
      icon: '🟡',
    ));
  }

  if (sorted.length > 2 && sorted[2].violationCount >= 2) {
    final z = sorted[2];
    recommendations.add(PatrolRecommendation(
      zone: z.name,
      priority: PatrolPriority.medium,
      reason: '${z.name} shows ${z.violationCount} violations with repeat offender plates. '
          'Monitor for escalation.',
      confidenceScore: 0.71,
      suggestedTime: '11:00 AM – 1:00 PM',
      icon: '🔵',
    ));
  }

  // Always add a general recommendation
  final clearZones = sorted.where((z) => z.severity == ZoneSeverity.clear).map((z) => z.name).toList();
  if (clearZones.isNotEmpty) {
    recommendations.add(PatrolRecommendation(
      zone: clearZones.join(', '),
      priority: PatrolPriority.low,
      reason: '${clearZones.length} zone(s) with minimal violations. '
          'Redirect resources to high-priority areas.',
      confidenceScore: 0.65,
      suggestedTime: 'Afternoon shift',
      icon: '🟢',
    ));
  }

  return recommendations;
}

// ─── Dashboard Aggregation Helpers ──────────────────────────────────────

/// Aggregate stats from zone data for dashboard cards.
class HeatmapStats {
  final int totalChecked;
  final int noPermitCount;
  final int compoundCount;
  final int opnCount;
  final int eCouponCount;
  final int seasonPassCount;

  HeatmapStats({
    required this.totalChecked,
    required this.noPermitCount,
    required this.compoundCount,
    required this.opnCount,
    required this.eCouponCount,
    required this.seasonPassCount,
  });

  factory HeatmapStats.fromZones(List<EnforcementZone> zones) {
    int total = 0, noPermit = 0, compound = 0, opn = 0, eCoupon = 0, season = 0;
    for (final z in zones) {
      for (final p in z.plates) {
        total++;
        switch (p.status) {
          case PlateStatus.noPermitFound:
            noPermit++;
          case PlateStatus.compoundIssued:
            compound++;
          case PlateStatus.opnIssued:
            opn++;
          case PlateStatus.activeECoupon:
            eCoupon++;
          case PlateStatus.activeSeasonPass:
            season++;
        }
      }
    }
    return HeatmapStats(
      totalChecked: total,
      noPermitCount: noPermit,
      compoundCount: compound,
      opnCount: opn,
      eCouponCount: eCoupon,
      seasonPassCount: season,
    );
  }

  int get totalViolations => noPermitCount + compoundCount + opnCount;
  double get violationRate => totalChecked > 0 ? totalViolations / totalChecked : 0;
}

/// All Sibu parking area names (unique) for filter dropdown.
final List<String> kHeatmapLocations = _zoneTemplates.map((t) => t.name).toSet().toList();
