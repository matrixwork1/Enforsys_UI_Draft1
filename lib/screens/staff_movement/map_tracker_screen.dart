import 'package:flutter/material.dart';
import 'staff_movement_data.dart';
import 'staff_detail_screen.dart';
import 'widgets/movement_map_widget.dart';
import 'widgets/staff_search_filter_bar.dart';
import 'widgets/staff_location_table.dart';

/// Screen 3: Map Tracker with status-colored PWID pins, dropdown filter, search button.
class MapTrackerScreen extends StatefulWidget {
  const MapTrackerScreen({super.key});

  @override
  State<MapTrackerScreen> createState() => _MapTrackerScreenState();
}

class _MapTrackerScreenState extends State<MapTrackerScreen> {
  String _searchQuery = '';
  String? _selectedLocation;
  int? _selectedStaffIndex;
  final DateTime _now = DateTime.now();

  List<StaffMember> get _filteredStaff {
    var list = kDummyStaff;
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((s) =>
        s.name.toLowerCase().contains(q) ||
        s.pwid.toLowerCase().contains(q)
      ).toList();
    }
    if (_selectedLocation != null) {
      list = list.where((s) => s.area == _selectedLocation).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final staff = _filteredStaff;
    final mapPoints = staff.map((s) => MapEntry(s.pwid, s.mapPosition)).toList();
    final mapColors = staff.map((s) => statusColor(s.getStatus(_now))).toList();
    final today = DateTime.now();
    final dateLabel = '${today.day.toString().padLeft(2, '0')}/${today.month.toString().padLeft(2, '0')}/${today.year}';

    final activeCount = staff.where((s) => s.getStatus(_now) == StaffStatus.active).length;
    final alertCount = staff.where((s) {
      final st = s.getStatus(_now);
      return st == StaffStatus.criticalInactive || st == StaffStatus.warningInactive;
    }).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Map Tracker',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 18)),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          // Status badges
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildAppBarBadge('$activeCount', const Color(0xFF10B981)),
                  const SizedBox(width: 6),
                  if (alertCount > 0) _buildAppBarBadge('$alertCount', const Color(0xFFEF4444)),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date + count
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFF6B7280)),
                  const SizedBox(width: 6),
                  Text("Today's Date: $dateLabel", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF4B5563))),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text('${staff.length} staff', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF4B5563))),
                  ),
                ],
              ),
            ),

            // Map with status-colored PWID pins
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Stack(
                children: [
                  MovementMapWidget(
                    points: mapPoints,
                    activeIndex: -1,
                    showPwidLabels: true,
                    selectedIndex: _selectedStaffIndex,
                    statusColors: mapColors,
                  ),
                  if (_selectedStaffIndex != null && _selectedStaffIndex! < staff.length)
                    Positioned(
                      top: 8, left: 12, right: 12,
                      child: _buildSelectedInfoWindow(staff[_selectedStaffIndex!]),
                    ),
                ],
              ),
            ),

            // Legend
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Wrap(
                spacing: 14,
                runSpacing: 6,
                children: [
                  _buildLegendItem('Active', const Color(0xFF10B981)),
                  _buildLegendItem('Warning', const Color(0xFFF59E0B)),
                  _buildLegendItem('Critical', const Color(0xFFEF4444)),
                  _buildLegendItem('Lunch', const Color(0xFF3B82F6)),
                  _buildLegendItem('Off-Duty', const Color(0xFF9CA3AF)),
                ],
              ),
            ),

            const SizedBox(height: 10),

            const SizedBox(height: 10),

            // Search + Location dropdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: StaffSearchFilterBar(
                hintText: 'Search staff by name or PWID...',
                onSearchSubmitted: (q) => setState(() {
                  _searchQuery = q;
                  _selectedStaffIndex = null;
                }),
                locationOptions: kSibuLocations,
                selectedLocation: _selectedLocation,
                onLocationChanged: (v) => setState(() {
                  _selectedLocation = v;
                  _selectedStaffIndex = null;
                }),
              ),
            ),

            const SizedBox(height: 12),

            // Staff location table
            StaffLocationTable(
              staff: staff,
              now: _now,
              onStaffTap: (s) => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => StaffDetailScreen(staff: s)),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarBadge(String count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
          const SizedBox(width: 4),
          Text(count, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
      ],
    );
  }

  Widget _buildSelectedInfoWindow(StaffMember staff) {
    final status = staff.getStatus(_now);
    final color = statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(10),
        border: Border(left: BorderSide(color: color, width: 3)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFF5A623).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(staff.pwid, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFD4891A))),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(staff.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1F2937))),
                const SizedBox(height: 2),
                Text(staff.latestAddress, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Container(
            width: 10, height: 10,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
        ],
      ),
    );
  }
}
