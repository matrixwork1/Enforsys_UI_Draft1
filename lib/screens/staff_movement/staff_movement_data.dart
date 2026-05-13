import 'package:flutter/material.dart';

/// Status levels for map pin visual hierarchy.
enum StaffStatus { active, lunch, warningInactive, criticalInactive, offDuty }

/// Represents a single staff member (Parking Warden / Attendant).
class StaffMember {
  final String pwid;
  final String name;
  final String area;
  final bool isActive;
  final String latestAddress;
  final String latestTimestamp;
  final List<StaffMovement> movements;
  final Offset mapPosition; // normalised 0..1
  final DateTime lastPingTime;
  final int imagesCount;
  final int compoundsCount;
  final int opnsCount;

  const StaffMember({
    required this.pwid,
    required this.name,
    required this.area,
    this.isActive = true,
    required this.latestAddress,
    required this.latestTimestamp,
    required this.movements,
    required this.mapPosition,
    required this.lastPingTime,
    this.imagesCount = 0,
    this.compoundsCount = 0,
    this.opnsCount = 0,
  });

  /// Compute the staff status based on last ping time.
  StaffStatus getStatus(DateTime now) {
    if (!isActive) return StaffStatus.offDuty;

    final hour = now.hour;
    final isLunchHour = hour == 12; // 12:00 PM – 12:59 PM

    if (isLunchHour) return StaffStatus.lunch;

    final diff = now.difference(lastPingTime);
    if (diff.inMinutes >= 60) return StaffStatus.criticalInactive;
    if (diff.inMinutes >= 30) return StaffStatus.warningInactive;
    return StaffStatus.active;
  }

  /// Human-readable inactivity label.
  String getInactivityLabel(DateTime now) {
    if (!isActive) return 'Off-Duty';
    final hour = now.hour;
    if (hour == 12) return 'On Lunch';
    final diff = now.difference(lastPingTime);
    if (diff.inMinutes < 30) return 'Active';
    if (diff.inHours >= 1) {
      final h = diff.inHours;
      final m = diff.inMinutes % 60;
      return 'Inactive ${h}h ${m}m';
    }
    return 'Inactive ${diff.inMinutes}m';
  }
}

/// Returns the color for a given staff status.
Color statusColor(StaffStatus status) {
  switch (status) {
    case StaffStatus.active:
      return const Color(0xFF10B981); // Green
    case StaffStatus.lunch:
      return const Color(0xFF3B82F6); // Blue
    case StaffStatus.warningInactive:
      return const Color(0xFFF59E0B); // Amber
    case StaffStatus.criticalInactive:
      return const Color(0xFFEF4444); // Red
    case StaffStatus.offDuty:
      return const Color(0xFF9CA3AF); // Grey
  }
}

/// Returns background tint color for cards/rows.
Color statusBgTint(StaffStatus status) {
  switch (status) {
    case StaffStatus.criticalInactive:
      return const Color(0xFFFEF2F2); // Light red
    case StaffStatus.warningInactive:
      return const Color(0xFFFEF3C7); // Light amber
    case StaffStatus.lunch:
      return const Color(0xFFEFF6FF); // Light blue
    case StaffStatus.active:
    case StaffStatus.offDuty:
      return Colors.white;
  }
}

/// A single GPS-captured location for a staff member.
class StaffMovement {
  final String dateTime;
  final String address;
  final Offset mapPosition; // normalised 0..1

  const StaffMovement({
    required this.dateTime,
    required this.address,
    required this.mapPosition,
  });
}

/// All Sibu location areas for the dropdown filter.
final List<String> kSibuLocations = [
  'Central Business District (CBD)',
  'Dewan Suarah',
  'Jalan Central',
  'Jalan Chengal',
  'Jalan Kampung Nyabor',
  'Jalan Lanang',
  'Jalan Maju',
  'Jalan Oya',
  'Jalan Pedada',
  'Jalan Sanyan',
  'Jalan Tunku Osman',
  'Jalan Tuanku Osman',
  'Jalan Wong Nai Siong',
  'KPJ Carpark',
  'Pasar Sentral Sibu',
  'Pusat Pedada',
  'Sibu Town Square',
];

// ─── Dummy Data ─────────────────────────────────────────────────────

final DateTime _now = DateTime.now();

final List<StaffMember> kDummyStaff = [
  // ACTIVE — pinged 8 min ago
  StaffMember(
    pwid: '8531', name: 'BETTY ANAK DARIN', area: 'Jalan Pedada',
    latestAddress: '12, Lorong Taman Seduan 8, 96000, Sibu, Sarawak',
    latestTimestamp: '13/05/2026 12:22 PM',
    mapPosition: const Offset(0.38, 0.42),
    lastPingTime: _now.subtract(const Duration(minutes: 8)),
    imagesCount: 47, compoundsCount: 12, opnsCount: 68,
    movements: [
      StaffMovement(dateTime: '13/05/2026 09:07 AM', address: '12, Lorong Taman Seduan 8, 96000, Sibu', mapPosition: const Offset(0.38, 0.42)),
      StaffMovement(dateTime: '13/05/2026 08:45 AM', address: '5, Jalan Pedada, 96000, Sibu', mapPosition: const Offset(0.35, 0.38)),
      StaffMovement(dateTime: '13/05/2026 08:30 AM', address: 'Dewan Suarah Carpark, 96000, Sibu', mapPosition: const Offset(0.42, 0.55)),
      StaffMovement(dateTime: '13/05/2026 08:15 AM', address: '3, Lorong Taman Seduan 5, 96000, Sibu', mapPosition: const Offset(0.30, 0.48)),
      StaffMovement(dateTime: '13/05/2026 08:00 AM', address: '12, Lorong Taman Seduan 8, 96000, Sibu', mapPosition: const Offset(0.38, 0.42)),
    ],
  ),
  // LUNCH — it's 12:30 PM, lunch hour
  StaffMember(
    pwid: '2815', name: 'MAS ANAK MANI', area: 'Dewan Suarah',
    latestAddress: '12, Lorong Taman Seduan 8, 96000, Sibu, Sarawak',
    latestTimestamp: '13/05/2026 12:00 PM',
    mapPosition: const Offset(0.52, 0.48),
    lastPingTime: _now.subtract(const Duration(minutes: 30)),
    imagesCount: 35, compoundsCount: 8, opnsCount: 42,
    movements: [
      StaffMovement(dateTime: '13/05/2026 09:45 AM', address: '12, Lorong Taman Seduan 8, 96000, Sibu', mapPosition: const Offset(0.52, 0.48)),
      StaffMovement(dateTime: '13/05/2026 09:08 AM', address: '12, Lorong Taman Seduan 8, 96000, Sibu', mapPosition: const Offset(0.50, 0.46)),
      StaffMovement(dateTime: '13/05/2026 08:30 AM', address: '8, Jalan Sanyan, 96000, Sibu', mapPosition: const Offset(0.60, 0.58)),
    ],
  ),
  // CRITICAL — pinged 95 min ago
  StaffMember(
    pwid: '4102', name: 'AHMAD BIN ISMAIL', area: 'KPJ Carpark',
    latestAddress: 'KPJ Specialist Hospital Carpark, 96000, Sibu, Sarawak',
    latestTimestamp: '13/05/2026 10:55 AM',
    mapPosition: const Offset(0.72, 0.35),
    lastPingTime: _now.subtract(const Duration(minutes: 95)),
    imagesCount: 22, compoundsCount: 5, opnsCount: 31,
    movements: [
      StaffMovement(dateTime: '13/05/2026 08:50 AM', address: 'KPJ Specialist Hospital Carpark, 96000, Sibu', mapPosition: const Offset(0.72, 0.35)),
      StaffMovement(dateTime: '13/05/2026 08:30 AM', address: 'Jalan Chengal, 96000, Sibu', mapPosition: const Offset(0.68, 0.30)),
      StaffMovement(dateTime: '13/05/2026 08:15 AM', address: 'Jalan Tunku Osman, 96000, Sibu', mapPosition: const Offset(0.75, 0.40)),
      StaffMovement(dateTime: '13/05/2026 08:00 AM', address: 'KPJ Specialist Hospital Carpark, 96000, Sibu', mapPosition: const Offset(0.72, 0.35)),
    ],
  ),
  // ACTIVE — pinged 5 min ago
  StaffMember(
    pwid: '6273', name: 'SITI BINTI YUSOF', area: 'Jalan Maju',
    latestAddress: '15, Jalan Maju, 96000, Sibu, Sarawak',
    latestTimestamp: '13/05/2026 12:25 PM',
    mapPosition: const Offset(0.25, 0.58),
    lastPingTime: _now.subtract(const Duration(minutes: 5)),
    imagesCount: 53, compoundsCount: 14, opnsCount: 75,
    movements: [
      StaffMovement(dateTime: '13/05/2026 10:15 AM', address: '15, Jalan Maju, 96000, Sibu', mapPosition: const Offset(0.25, 0.58)),
      StaffMovement(dateTime: '13/05/2026 09:00 AM', address: 'Dewan Suarah, 96000, Sibu', mapPosition: const Offset(0.30, 0.52)),
      StaffMovement(dateTime: '13/05/2026 08:45 AM', address: 'Jalan Pedada, 96000, Sibu', mapPosition: const Offset(0.35, 0.45)),
      StaffMovement(dateTime: '13/05/2026 08:30 AM', address: 'Jalan Chengal, 96000, Sibu', mapPosition: const Offset(0.28, 0.62)),
      StaffMovement(dateTime: '13/05/2026 08:00 AM', address: '15, Jalan Maju, 96000, Sibu', mapPosition: const Offset(0.25, 0.58)),
    ],
  ),
  // WARNING — pinged 45 min ago
  StaffMember(
    pwid: '3890', name: 'BONG ANAK LIHAN', area: 'Jalan Sanyan',
    latestAddress: '22, Jalan Sanyan, 96000, Sibu, Sarawak',
    latestTimestamp: '13/05/2026 11:45 AM',
    mapPosition: const Offset(0.60, 0.62),
    lastPingTime: _now.subtract(const Duration(minutes: 45)),
    imagesCount: 18, compoundsCount: 3, opnsCount: 20,
    movements: [
      StaffMovement(dateTime: '13/05/2026 08:40 AM', address: '22, Jalan Sanyan, 96000, Sibu', mapPosition: const Offset(0.60, 0.62)),
      StaffMovement(dateTime: '13/05/2026 08:20 AM', address: 'Dewan Suarah, 96000, Sibu', mapPosition: const Offset(0.55, 0.55)),
      StaffMovement(dateTime: '13/05/2026 08:00 AM', address: 'Jalan Pedada, 96000, Sibu', mapPosition: const Offset(0.50, 0.50)),
    ],
  ),
  // ACTIVE — pinged 12 min ago
  StaffMember(
    pwid: '7451', name: 'JAMES ANAK BULAN', area: 'Pusat Pedada',
    latestAddress: 'Pusat Pedada, Jalan Pedada, 96000, Sibu, Sarawak',
    latestTimestamp: '13/05/2026 12:18 PM',
    mapPosition: const Offset(0.18, 0.35),
    lastPingTime: _now.subtract(const Duration(minutes: 12)),
    imagesCount: 61, compoundsCount: 18, opnsCount: 82,
    movements: [
      StaffMovement(dateTime: '13/05/2026 10:10 AM', address: 'Pusat Pedada, Jalan Pedada, 96000, Sibu', mapPosition: const Offset(0.18, 0.35)),
      StaffMovement(dateTime: '13/05/2026 09:00 AM', address: 'Jalan Maju, 96000, Sibu', mapPosition: const Offset(0.22, 0.42)),
      StaffMovement(dateTime: '13/05/2026 08:45 AM', address: 'Jalan Pedada, 96000, Sibu', mapPosition: const Offset(0.28, 0.38)),
      StaffMovement(dateTime: '13/05/2026 08:00 AM', address: 'Pusat Pedada, Jalan Pedada, 96000, Sibu', mapPosition: const Offset(0.18, 0.35)),
    ],
  ),
  StaffMember(
    pwid: '1624', name: 'NORA ANAK DING', area: 'Jalan Chengal',
    isActive: false,
    latestAddress: '7, Jalan Chengal, 96000, Sibu, Sarawak',
    latestTimestamp: '10/05/2026 04:50 PM',
    mapPosition: const Offset(0.82, 0.55),
    lastPingTime: DateTime(2026, 5, 10, 16, 50),
    imagesCount: 0, compoundsCount: 0, opnsCount: 0,
    movements: [
      StaffMovement(dateTime: '10/05/2026 04:50 PM', address: '7, Jalan Chengal, 96000, Sibu', mapPosition: const Offset(0.82, 0.55)),
      StaffMovement(dateTime: '10/05/2026 04:30 PM', address: 'KPJ Carpark, 96000, Sibu', mapPosition: const Offset(0.78, 0.48)),
    ],
  ),
  // LUNCH — it's 12:30 PM
  StaffMember(
    pwid: '5937', name: 'WONG MEI LIN', area: 'Jalan Tunku Osman',
    latestAddress: '30, Jalan Tunku Osman, 96000, Sibu, Sarawak',
    latestTimestamp: '13/05/2026 12:00 PM',
    mapPosition: const Offset(0.45, 0.28),
    lastPingTime: _now.subtract(const Duration(minutes: 30)),
    imagesCount: 39, compoundsCount: 10, opnsCount: 55,
    movements: [
      StaffMovement(dateTime: '13/05/2026 10:10 AM', address: '30, Jalan Tunku Osman, 96000, Sibu', mapPosition: const Offset(0.45, 0.28)),
      StaffMovement(dateTime: '13/05/2026 08:50 AM', address: 'Jalan Chengal, 96000, Sibu', mapPosition: const Offset(0.48, 0.32)),
      StaffMovement(dateTime: '13/05/2026 08:30 AM', address: 'KPJ Carpark, 96000, Sibu', mapPosition: const Offset(0.52, 0.38)),
      StaffMovement(dateTime: '13/05/2026 08:00 AM', address: '30, Jalan Tunku Osman, 96000, Sibu', mapPosition: const Offset(0.45, 0.28)),
    ],
  ),
  // ─── New Staff ────────────────────────────────────────────────
  // WARNING — pinged 38 min ago
  StaffMember(
    pwid: '9104', name: 'LING SIAW PING', area: 'Central Business District (CBD)',
    latestAddress: 'CBD Lot 15, Jalan Channel, 96000, Sibu, Sarawak',
    latestTimestamp: '13/05/2026 11:52 AM',
    mapPosition: const Offset(0.48, 0.15),
    lastPingTime: _now.subtract(const Duration(minutes: 38)),
    imagesCount: 44, compoundsCount: 11, opnsCount: 63,
    movements: [
      StaffMovement(dateTime: '13/05/2026 10:05 AM', address: 'CBD Lot 15, Jalan Channel, 96000, Sibu', mapPosition: const Offset(0.48, 0.15)),
      StaffMovement(dateTime: '13/05/2026 09:30 AM', address: 'CBD Lot 8, 96000, Sibu', mapPosition: const Offset(0.45, 0.18)),
      StaffMovement(dateTime: '13/05/2026 08:00 AM', address: 'CBD Main Road, 96000, Sibu', mapPosition: const Offset(0.50, 0.12)),
    ],
  ),
  // ACTIVE — pinged 20 min ago
  StaffMember(
    pwid: '8207', name: 'RAZAK BIN ABDULLAH', area: 'Jalan Kampung Nyabor',
    latestAddress: '5, Jalan Kampung Nyabor, 96000, Sibu, Sarawak',
    latestTimestamp: '13/05/2026 12:10 PM',
    mapPosition: const Offset(0.15, 0.70),
    lastPingTime: _now.subtract(const Duration(minutes: 20)),
    imagesCount: 30, compoundsCount: 7, opnsCount: 38,
    movements: [
      StaffMovement(dateTime: '13/05/2026 09:50 AM', address: '5, Jalan Kampung Nyabor, 96000, Sibu', mapPosition: const Offset(0.15, 0.70)),
      StaffMovement(dateTime: '13/05/2026 09:15 AM', address: 'Jalan Kampung Nyabor, 96000, Sibu', mapPosition: const Offset(0.18, 0.68)),
      StaffMovement(dateTime: '13/05/2026 08:00 AM', address: 'Jalan Kampung Nyabor, 96000, Sibu', mapPosition: const Offset(0.15, 0.70)),
    ],
  ),
  // CRITICAL — pinged 75 min ago
  StaffMember(
    pwid: '6518', name: 'DAYANG ANAK KELVIN', area: 'Jalan Lanang',
    latestAddress: '18, Jalan Lanang, 96000, Sibu, Sarawak',
    latestTimestamp: '13/05/2026 11:15 AM',
    mapPosition: const Offset(0.85, 0.25),
    lastPingTime: _now.subtract(const Duration(minutes: 75)),
    imagesCount: 25, compoundsCount: 6, opnsCount: 28,
    movements: [
      StaffMovement(dateTime: '13/05/2026 09:30 AM', address: '18, Jalan Lanang, 96000, Sibu', mapPosition: const Offset(0.85, 0.25)),
      StaffMovement(dateTime: '13/05/2026 08:45 AM', address: 'Jalan Lanang, 96000, Sibu', mapPosition: const Offset(0.82, 0.28)),
      StaffMovement(dateTime: '13/05/2026 08:00 AM', address: '18, Jalan Lanang, 96000, Sibu', mapPosition: const Offset(0.85, 0.25)),
    ],
  ),
  // WARNING — pinged 32 min ago
  StaffMember(
    pwid: '3341', name: 'CHEN WEI HONG', area: 'Jalan Wong Nai Siong',
    latestAddress: '10, Jalan Wong Nai Siong, 96000, Sibu, Sarawak',
    latestTimestamp: '13/05/2026 11:58 AM',
    mapPosition: const Offset(0.32, 0.20),
    lastPingTime: _now.subtract(const Duration(minutes: 32)),
    imagesCount: 58, compoundsCount: 15, opnsCount: 70,
    movements: [
      StaffMovement(dateTime: '13/05/2026 10:12 AM', address: '10, Jalan Wong Nai Siong, 96000, Sibu', mapPosition: const Offset(0.32, 0.20)),
      StaffMovement(dateTime: '13/05/2026 09:40 AM', address: 'Jalan Wong Nai Siong, 96000, Sibu', mapPosition: const Offset(0.30, 0.22)),
      StaffMovement(dateTime: '13/05/2026 08:50 AM', address: 'CBD, 96000, Sibu', mapPosition: const Offset(0.35, 0.18)),
      StaffMovement(dateTime: '13/05/2026 08:00 AM', address: '10, Jalan Wong Nai Siong, 96000, Sibu', mapPosition: const Offset(0.32, 0.20)),
    ],
  ),
  // CRITICAL — pinged 80 min ago
  StaffMember(
    pwid: '4756', name: 'ROSLI BIN HASSAN', area: 'Pasar Sentral Sibu',
    latestAddress: 'Pasar Sentral Sibu, 96000, Sibu, Sarawak',
    latestTimestamp: '13/05/2026 11:10 AM',
    mapPosition: const Offset(0.68, 0.72),
    lastPingTime: _now.subtract(const Duration(minutes: 80)),
    imagesCount: 41, compoundsCount: 9, opnsCount: 52,
    movements: [
      StaffMovement(dateTime: '13/05/2026 09:55 AM', address: 'Pasar Sentral Sibu, 96000, Sibu', mapPosition: const Offset(0.68, 0.72)),
      StaffMovement(dateTime: '13/05/2026 09:20 AM', address: 'Pasar Sentral Sibu, 96000, Sibu', mapPosition: const Offset(0.70, 0.70)),
      StaffMovement(dateTime: '13/05/2026 08:00 AM', address: 'Pasar Sentral Sibu, 96000, Sibu', mapPosition: const Offset(0.68, 0.72)),
    ],
  ),
  // ACTIVE — pinged 15 min ago
  StaffMember(
    pwid: '2093', name: 'NURUL BINTI OMAR', area: 'Sibu Town Square',
    latestAddress: 'Sibu Town Square, 96000, Sibu, Sarawak',
    latestTimestamp: '13/05/2026 12:15 PM',
    mapPosition: const Offset(0.55, 0.82),
    lastPingTime: _now.subtract(const Duration(minutes: 15)),
    imagesCount: 36, compoundsCount: 8, opnsCount: 45,
    movements: [
      StaffMovement(dateTime: '13/05/2026 10:00 AM', address: 'Sibu Town Square, 96000, Sibu', mapPosition: const Offset(0.55, 0.82)),
      StaffMovement(dateTime: '13/05/2026 09:10 AM', address: 'Sibu Town Square, 96000, Sibu', mapPosition: const Offset(0.53, 0.80)),
      StaffMovement(dateTime: '13/05/2026 08:00 AM', address: 'Sibu Town Square, 96000, Sibu', mapPosition: const Offset(0.55, 0.82)),
    ],
  ),
  StaffMember(
    pwid: '7782', name: 'DANIEL ANAK MUSA', area: 'Jalan Oya',
    isActive: false,
    latestAddress: '3, Jalan Oya, 96000, Sibu, Sarawak',
    latestTimestamp: '12/05/2026 05:00 PM',
    mapPosition: const Offset(0.90, 0.68),
    lastPingTime: DateTime(2026, 5, 12, 17, 0),
    imagesCount: 0, compoundsCount: 0, opnsCount: 0,
    movements: [
      StaffMovement(dateTime: '12/05/2026 05:00 PM', address: '3, Jalan Oya, 96000, Sibu', mapPosition: const Offset(0.90, 0.68)),
      StaffMovement(dateTime: '12/05/2026 04:30 PM', address: 'Jalan Oya, 96000, Sibu', mapPosition: const Offset(0.88, 0.70)),
    ],
  ),
];
