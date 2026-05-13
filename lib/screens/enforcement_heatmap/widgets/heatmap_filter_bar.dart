import 'package:flutter/material.dart';
import '../enforcement_heatmap_data.dart';

/// Filter bar for the heatmap module.
/// Contains: Location dropdown, Date picker, Status filter chips.
/// Styled to match CompoundsPage filter patterns (solid-fill chips,
/// prominent borders, proper height).
class HeatmapFilterBar extends StatelessWidget {
  final String? selectedLocation;
  final ValueChanged<String?> onLocationChanged;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;
  final Set<PlateStatus> activeStatusFilters;
  final ValueChanged<PlateStatus> onStatusToggled;

  const HeatmapFilterBar({
    super.key,
    required this.selectedLocation,
    required this.onLocationChanged,
    required this.selectedDate,
    required this.onDateChanged,
    required this.activeStatusFilters,
    required this.onStatusToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row 1: Location + Date
        Row(
          children: [
            // Location dropdown
            Expanded(
              flex: 3,
              child: Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String?>(
                    value: selectedLocation,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded,
                        color: Color(0xFF9CA3AF), size: 18),
                    hint: const Text('All Zones',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1F2937))),
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1F2937)),
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('All Zones'),
                      ),
                      ...kHeatmapLocations.map((loc) => DropdownMenuItem(
                            value: loc,
                            child: Text(loc,
                                overflow: TextOverflow.ellipsis),
                          )),
                    ],
                    onChanged: onLocationChanged,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Date picker
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () => _pickDate(context),
                child: Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.date_range_rounded,
                          size: 16, color: Color(0xFF9CA3AF)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _formatDate(selectedDate),
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1F2937)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Row 2: Status filter chips — solid fill like CompoundsPage _FilterChip
        SizedBox(
          width: double.infinity,
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: PlateStatus.values.map((status) {
              final isActive = activeStatusFilters.contains(status);
              final color = plateStatusColor(status);
              return GestureDetector(
                onTap: () => onStatusToggled(status),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isActive ? color : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isActive ? color : const Color(0xFFE5E7EB),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    _shortLabel(status),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isActive
                          ? Colors.white
                          : const Color(0xFF6B7280),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      builder: (c, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFFF5A623),
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: Color(0xFF1F2937),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) onDateChanged(picked);
  }

  String _formatDate(DateTime d) {
    const m = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${d.day.toString().padLeft(2, '0')} ${m[d.month - 1]} ${d.year}';
  }

  String _shortLabel(PlateStatus status) {
    switch (status) {
      case PlateStatus.activeECoupon:
        return 'eCoupon';
      case PlateStatus.activeSeasonPass:
        return 'Season';
      case PlateStatus.noPermitFound:
        return 'No Permit';
      case PlateStatus.compoundIssued:
        return 'Compound';
      case PlateStatus.opnIssued:
        return 'OPN';
    }
  }
}
