import 'package:flutter/material.dart';
import 'enforcement_heatmap_data.dart';
import 'widgets/heatmap_view_toggle.dart';
import 'widgets/heatmap_filter_bar.dart';
import 'widgets/heatmap_map_widget.dart';
import 'widgets/heatmap_info_panel.dart';
import 'widgets/heatmap_dashboard.dart';
import 'widgets/patrol_advisor_card.dart';

/// Main screen for the Enforcement Heatmap module.
///
/// Displays a custom-painted map of parking enforcement data with
/// zone/marker toggle, filters, dashboard analytics, and AI patrol
/// recommendations. Patrol data refreshes on demand via the refresh
/// button (simulates hourly data updates).
class EnforcementHeatmapScreen extends StatefulWidget {
  const EnforcementHeatmapScreen({super.key});

  @override
  State<EnforcementHeatmapScreen> createState() =>
      _EnforcementHeatmapScreenState();
}

class _EnforcementHeatmapScreenState extends State<EnforcementHeatmapScreen> {
  // ─── State ──────────────────────────────────────────────────────
  bool _isZoneView = true;
  String? _selectedLocation;
  DateTime _selectedDate = DateTime.now();
  final Set<PlateStatus> _activeStatusFilters = PlateStatus.values.toSet();
  final Set<ZoneSeverity> _activeZoneFilters = ZoneSeverity.values.toSet();
  int? _selectedZoneIndex;
  int? _selectedMarkerZoneIdx;
  int? _selectedMarkerPlateIdx;
  int _refreshSeed = 0;
  bool _isRefreshing = false;

  late List<EnforcementZone> _zones;
  late List<PatrolRecommendation> _recommendations;

  @override
  void initState() {
    super.initState();
    _generateData();
  }

  void _generateData() {
    _zones = generateEnforcementData(seed: _refreshSeed);
    _recommendations = generatePatrolRecommendations(_zones);
  }

  /// Simulate a patrol data refresh with animation.
  Future<void> _onRefresh() async {
    setState(() => _isRefreshing = true);
    // Brief delay to show refresh animation
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() {
      _refreshSeed++;
      _selectedZoneIndex = null;
      _selectedMarkerZoneIdx = null;
      _selectedMarkerPlateIdx = null;
      _generateData();
      _isRefreshing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Patrol data refreshed — ${_zones.fold<int>(0, (s, z) => s + z.totalPlates)} plates loaded',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF10B981),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /// Get filtered zones based on location selection.
  List<EnforcementZone> get _filteredZones {
    if (_selectedLocation == null) return _zones;
    return _zones.where((z) => z.name == _selectedLocation).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredZones = _filteredZones;
    final stats = HeatmapStats.fromZones(filteredZones);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.black87, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Enforcement Heatmap',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          // Refresh button
          IconButton(
            onPressed: _isRefreshing ? null : _onRefresh,
            icon: AnimatedRotation(
              turns: _isRefreshing ? 1 : 0,
              duration: const Duration(milliseconds: 600),
              child: Icon(
                Icons.refresh,
                color: _isRefreshing
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF1F2937),
                size: 22,
              ),
            ),
            tooltip: 'Refresh patrol data',
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Quick Stats Row ──────────────────────────────────
            _buildQuickStats(stats),
            const SizedBox(height: 14),

            // ── Filters ─────────────────────────────────────────
            HeatmapFilterBar(
              isZoneView: _isZoneView,
              selectedLocation: _selectedLocation,
              onLocationChanged: (v) => setState(() {
                _selectedLocation = v;
                _selectedZoneIndex = null;
                _selectedMarkerZoneIdx = null;
                _selectedMarkerPlateIdx = null;
              }),
              selectedDate: _selectedDate,
              onDateChanged: (d) => setState(() => _selectedDate = d),
              activeStatusFilters: _activeStatusFilters,
              onStatusToggled: (status) => setState(() {
                if (_activeStatusFilters.contains(status)) {
                  // Don't allow deselecting all
                  if (_activeStatusFilters.length > 1) {
                    _activeStatusFilters.remove(status);
                  }
                } else {
                  _activeStatusFilters.add(status);
                }
              }),
              activeZoneFilters: _activeZoneFilters,
              onZoneFilterToggled: (severity) => setState(() {
                if (_activeZoneFilters.contains(severity)) {
                  if (_activeZoneFilters.length > 1) {
                    _activeZoneFilters.remove(severity);
                  }
                } else {
                  _activeZoneFilters.add(severity);
                }
              }),
            ),
            const SizedBox(height: 14),

            // ── View Toggle ─────────────────────────────────────
            HeatmapViewToggle(
              isZoneView: _isZoneView,
              onToggle: (isZone) => setState(() {
                _isZoneView = isZone;
                _selectedZoneIndex = null;
                _selectedMarkerZoneIdx = null;
                _selectedMarkerPlateIdx = null;
              }),
            ),
            const SizedBox(height: 12),

            // ── Map ─────────────────────────────────────────────
            HeatmapMapWidget(
              zones: filteredZones,
              showZones: _isZoneView,
              activeStatusFilters: _activeStatusFilters,
              activeZoneFilters: _activeZoneFilters,
              selectedZoneIndex: _selectedZoneIndex,
              selectedMarkerZoneIdx: _selectedMarkerZoneIdx,
              selectedMarkerPlateIdx: _selectedMarkerPlateIdx,
              onZoneTap: (idx) {
                setState(() => _selectedZoneIndex = idx);
                if (idx < filteredZones.length) {
                  HeatmapInfoPanel.showZoneDetails(
                      context, filteredZones[idx]);
                }
              },
              onMarkerTap: (zoneIdx, plateIdx) {
                setState(() {
                  _selectedMarkerZoneIdx = zoneIdx;
                  _selectedMarkerPlateIdx = plateIdx;
                });
                if (zoneIdx < filteredZones.length &&
                    plateIdx < filteredZones[zoneIdx].plates.length) {
                  HeatmapInfoPanel.showMarkerDetails(
                      context, filteredZones[zoneIdx].plates[plateIdx]);
                }
              },
            ),
            const SizedBox(height: 10),

            // ── Legend ──────────────────────────────────────────
            _buildLegend(),
            const SizedBox(height: 20),

            // ── Dashboard ───────────────────────────────────────
            HeatmapDashboard(zones: filteredZones),
            const SizedBox(height: 20),

            // ── AI Patrol Advisor ────────────────────────────────
            PatrolAdvisorCard(recommendations: _recommendations),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ─── Quick Stats ────────────────────────────────────────────────

  Widget _buildQuickStats(HeatmapStats stats) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.map_outlined,
                size: 22, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Patrol Overview',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildMiniStat(
                        '${stats.totalChecked} Checked',
                        const Color(0xFF93C5FD)),
                    const SizedBox(width: 10),
                    _buildMiniStat(
                        '${stats.totalViolations} Violations',
                        const Color(0xFFFCA5A5)),
                    const SizedBox(width: 10),
                    _buildMiniStat(
                        '${(stats.violationRate * 100).round()}% Rate',
                        const Color(0xFFFCD34D)),
                  ],
                ),
              ],
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
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  // ─── Legend ──────────────────────────────────────────────────────

  Widget _buildLegend() {
    if (_isZoneView) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Wrap(
          spacing: 14,
          runSpacing: 6,
          children: [
            _buildLegendItem('Critical (≥3)', const Color(0xFFEF4444)),
            _buildLegendItem('High (2)', const Color(0xFFF59E0B)),
            _buildLegendItem('Moderate (1)', const Color(0xFFFBBF24)),
            _buildLegendItem('Clear (0)', const Color(0xFF10B981)),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Wrap(
          spacing: 12,
          runSpacing: 6,
          children: [
            _buildLegendItem('No Permit', const Color(0xFFEF4444)),
            _buildLegendItem('Compound', const Color(0xFFF59E0B)),
            _buildLegendItem('OPN', const Color(0xFFF5A623)),
            _buildLegendItem('eCoupon', const Color(0xFF10B981)),
            _buildLegendItem('Season', const Color(0xFF3B82F6)),
          ],
        ),
      );
    }
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
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
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}
