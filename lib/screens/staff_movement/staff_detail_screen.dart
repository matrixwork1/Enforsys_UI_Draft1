import 'package:flutter/material.dart';
import 'staff_movement_data.dart';
import 'widgets/movement_map_widget.dart';
import 'widgets/movement_bottom_sheet.dart';

/// Screen 2: Individual staff movement detail.
/// Full-screen map showing one staff member's movement path + draggable bottom sheet.
class StaffDetailScreen extends StatefulWidget {
  final StaffMember staff;
  const StaffDetailScreen({super.key, required this.staff});

  @override
  State<StaffDetailScreen> createState() => _StaffDetailScreenState();
}

class _StaffDetailScreenState extends State<StaffDetailScreen> {
  int _selectedMovementIndex = 0;

  @override
  Widget build(BuildContext context) {
    final movements = widget.staff.movements;
    final mapPoints = movements.asMap().entries.map((e) {
      // Use index as label for movement sequence
      return MapEntry('${e.key + 1}', e.value.mapPosition);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.staff.name,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF5A623).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'ID: ${widget.staff.pwid}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFFD4891A),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map fills the background
          Column(
            children: [
              // Info card overlay on map
              Expanded(
                child: Stack(
                  children: [
                    // Map
                    Positioned.fill(
                      child: Container(
                        margin: const EdgeInsets.all(0),
                        child: MovementMapWidget(
                          points: mapPoints,
                          activeIndex: _selectedMovementIndex,
                        ),
                      ),
                    ),

                    // Latest location info window
                    if (movements.isNotEmpty)
                      Positioned(
                        top: 12,
                        left: 16,
                        right: 16,
                        child: _buildInfoWindow(movements[_selectedMovementIndex]),
                      ),

                    // Movement index selector chips
                    if (movements.length > 1)
                      Positioned(
                        bottom: 12,
                        left: 0,
                        right: 0,
                        child: _buildMovementChips(movements),
                      ),
                  ],
                ),
              ),
            ],
          ),

          // Draggable bottom sheet
          MovementBottomSheet(staff: widget.staff),
        ],
      ),
    );
  }

  Widget _buildInfoWindow(StaffMovement movement) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFF5A623),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  movement.dateTime,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              movement.address,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovementChips(List<StaffMovement> movements) {
    return SizedBox(
      height: 28,
      child: Center(
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: movements.length > 8 ? 8 : movements.length,
          separatorBuilder: (_, a) => const SizedBox(width: 4),
          itemBuilder: (context, index) {
            final isSelected = index == _selectedMovementIndex;
            return GestureDetector(
              onTap: () => setState(() => _selectedMovementIndex = index),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFF5A623) : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? const Color(0xFFF5A623) : const Color(0xFFD1D5DB),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : const Color(0xFF6B7280),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
