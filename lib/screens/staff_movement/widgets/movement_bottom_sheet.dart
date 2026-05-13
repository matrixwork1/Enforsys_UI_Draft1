import 'package:flutter/material.dart';
import '../staff_movement_data.dart';

/// Draggable bottom sheet for individual staff movement log.
class MovementBottomSheet extends StatefulWidget {
  final StaffMember staff;
  const MovementBottomSheet({super.key, required this.staff});

  @override
  State<MovementBottomSheet> createState() => _MovementBottomSheetState();
}

class _MovementBottomSheetState extends State<MovementBottomSheet> {
  String _selectedDate = '';
  String _selectedTimeFilter = 'All';
  final List<String> _timeFilters = ['All', 'Morning', 'Afternoon'];

  @override
  void initState() {
    super.initState();
    if (widget.staff.movements.isNotEmpty) {
      _selectedDate = widget.staff.movements.first.dateTime.split(' ')[0];
    }
  }

  List<StaffMovement> get _filteredMovements {
    var list = widget.staff.movements;
    if (_selectedDate.isNotEmpty) {
      list = list.where((m) => m.dateTime.startsWith(_selectedDate)).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.35,
      minChildSize: 0.15,
      maxChildSize: 0.85,
      snap: true,
      snapSizes: const [0.15, 0.35, 0.60, 0.85],
      builder: (context, scrollController) {
        final movements = _filteredMovements;
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [BoxShadow(color: Color(0x1A000000), blurRadius: 20, offset: Offset(0, -4))],
          ),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.zero,
            children: [
              _buildDragHandle(),
              _buildDateSelector(context, movements.length),
              _buildTimeFilterChips(),
              const SizedBox(height: 4),
              _buildTableHeader(),
              ...List.generate(movements.length, (i) => _buildTableRow(movements[i], i, i == movements.length - 1)),
              if (movements.isEmpty) _buildEmptyState(),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDragHandle() => Center(
    child: Container(
      margin: const EdgeInsets.only(top: 10, bottom: 6),
      width: 40, height: 4,
      decoration: BoxDecoration(color: const Color(0xFFD1D5DB), borderRadius: BorderRadius.circular(2)),
    ),
  );

  Widget _buildDateSelector(BuildContext context, int count) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: Row(
      children: [
        GestureDetector(
          onTap: () => _pickDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_today_outlined, size: 15, color: Color(0xFF6B7280)),
                const SizedBox(width: 8),
                Text(_selectedDate.isEmpty ? 'Select date' : _selectedDate,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2937))),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_drop_down, size: 18, color: Color(0xFF6B7280)),
              ],
            ),
          ),
        ),
        const Spacer(),
        Text('$count records', style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
      ],
    ),
  );

  Widget _buildTimeFilterChips() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    child: SizedBox(
      height: 30,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _timeFilters.length,
        separatorBuilder: (_, a) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final f = _timeFilters[index];
          final sel = _selectedTimeFilter == f;
          return GestureDetector(
            onTap: () => setState(() => _selectedTimeFilter = f),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: sel ? const Color(0xFFF5A623) : const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: sel ? const Color(0xFFF5A623) : const Color(0xFFE5E7EB)),
              ),
              child: Text(f, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                color: sel ? Colors.white : const Color(0xFF6B7280))),
            ),
          );
        },
      ),
    ),
  );

  Widget _buildTableHeader() => Container(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: const BoxDecoration(
      color: Color(0xFFF9FAFB),
      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
    ),
    child: const Row(
      children: [
        SizedBox(width: 140, child: Text('Date/Time', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF6B7280)))),
        Expanded(child: Text('Address', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF6B7280)))),
      ],
    ),
  );

  Widget _buildTableRow(StaffMovement m, int index, bool isLast) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      color: index.isEven ? Colors.white : const Color(0xFFFDFDFD),
      borderRadius: isLast ? const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)) : null,
      border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Row(children: [
            Container(width: 6, height: 6, margin: const EdgeInsets.only(right: 8, top: 4),
              decoration: BoxDecoration(shape: BoxShape.circle,
                color: index == 0 ? const Color(0xFFF5A623) : const Color(0xFFD1D5DB))),
            Expanded(child: Text(m.dateTime, style: TextStyle(fontSize: 12,
              fontWeight: index == 0 ? FontWeight.w600 : FontWeight.w400, color: const Color(0xFF4B5563)))),
          ]),
        ),
        Expanded(child: Text(m.address, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
          maxLines: 2, overflow: TextOverflow.ellipsis)),
      ],
    ),
  );

  Widget _buildEmptyState() => const Padding(
    padding: EdgeInsets.all(24),
    child: Center(child: Text('No movement records found', style: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)))),
  );

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context, initialDate: DateTime.now(),
      firstDate: DateTime(2020), lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(colorScheme: const ColorScheme.light(
          primary: Color(0xFFF5A623), onPrimary: Colors.white, surface: Colors.white, onSurface: Color(0xFF1F2937))),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() { _selectedDate = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}'; });
    }
  }
}
