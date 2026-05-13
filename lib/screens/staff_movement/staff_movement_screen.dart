import 'package:flutter/material.dart';
import 'staff_movement_data.dart';
import 'staff_detail_screen.dart';
import 'map_tracker_screen.dart';
import 'widgets/staff_search_filter_bar.dart';
import 'widgets/staff_card.dart';

/// Screen 1: All Attendants hub with search button + dropdown filter.
class StaffMovementScreen extends StatefulWidget {
  const StaffMovementScreen({super.key});

  @override
  State<StaffMovementScreen> createState() => _StaffMovementScreenState();
}

class _StaffMovementScreenState extends State<StaffMovementScreen> {
  String _searchQuery = '';
  String? _selectedLocation;
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

  int get _activeCount => kDummyStaff.where((s) => s.getStatus(_now) == StaffStatus.active).length;
  int get _alertCount => kDummyStaff.where((s) {
    final st = s.getStatus(_now);
    return st == StaffStatus.criticalInactive || st == StaffStatus.warningInactive;
  }).length;

  @override
  Widget build(BuildContext context) {
    final staff = _filteredStaff;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('All Attendants',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 18)),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        children: [
          // Search + Location dropdown
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: StaffSearchFilterBar(
              hintText: 'Search by name or PWID...',
              onSearchSubmitted: (q) => setState(() => _searchQuery = q),
              locationOptions: kSibuLocations,
              selectedLocation: _selectedLocation,
              onLocationChanged: (v) => setState(() => _selectedLocation = v),
            ),
          ),
          const SizedBox(height: 12),

          // Status summary + Map Tracker card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const MapTrackerScreen()),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1F2937), Color(0xFF374151)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1F2937).withValues(alpha: 0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.map_outlined, size: 22, color: Colors.white),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Today's Live Tracker",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              _buildMiniStat('$_activeCount Active', const Color(0xFF10B981)),
                              const SizedBox(width: 10),
                              if (_alertCount > 0)
                                _buildMiniStat('$_alertCount Alerts', const Color(0xFFEF4444)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, size: 22, color: Color(0xFF9CA3AF)),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Staff count label
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  '${staff.length} attendant${staff.length != 1 ? 's' : ''}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF9CA3AF)),
                ),
                if (_searchQuery.isNotEmpty || _selectedLocation != null) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => setState(() { _searchQuery = ''; _selectedLocation = null; }),
                    child: const Text('Clear filters', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFFF5A623))),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 6),

          // Staff list
          Expanded(
            child: staff.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off, size: 48, color: Color(0xFFD1D5DB)),
                        SizedBox(height: 12),
                        Text('No attendants found', style: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF))),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: staff.length,
                    separatorBuilder: (_, a) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      return StaffCard(
                        staff: staff[index],
                        now: _now,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => StaffDetailScreen(staff: staff[index])),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6, height: 6,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
      ],
    );
  }
}
