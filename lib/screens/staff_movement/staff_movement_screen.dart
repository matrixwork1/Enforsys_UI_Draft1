import 'package:flutter/material.dart';
import 'widgets/movement_map_widget.dart';
import 'widgets/movement_summary_stats.dart';
import 'widgets/movement_detail_card.dart';
import 'widgets/movement_log_timeline.dart';

class StaffMovementScreen extends StatefulWidget {
  const StaffMovementScreen({super.key});

  @override
  State<StaffMovementScreen> createState() => _StaffMovementScreenState();
}

class _StaffMovementScreenState extends State<StaffMovementScreen> {
  DateTime _selectedDate = DateTime.now();
  String _selectedStaff = 'Mas Anak Mani';

  final List<String> _staffList = [
    'Mas Anak Mani',
    'Ahmad Bin Ismail',
    'Siti Binti Yusof',
    'Bong Anak Lihan',
    'James Anak Bulan',
  ];

  // ─── Dummy Movement Data per Staff ─────────────────────────────

  Map<String, Map<String, dynamic>> get _staffMovementData => {
    'Mas Anak Mani': {
      'distance': '4.2 km',
      'onDuty': '6h 30m',
      'stops': 8,
      'currentFrom': 'Jalan Pedada',
      'currentTo': 'Dewan Suarah',
      'currentTime': '09:00 AM – 09:30 AM',
      'fromCoords': '2.3114° N, 111.8485° E',
      'toCoords': '2.3125° N, 111.8502° E',
      'mapPoints': [
        MapEntry('Jln Pedada', const Offset(0.15, 0.30)),
        MapEntry('Dewan Suarah', const Offset(0.35, 0.55)),
        MapEntry('Jln Maju', const Offset(0.55, 0.35)),
        MapEntry('Jln Sanyan', const Offset(0.72, 0.65)),
        MapEntry('KPJ Carpark', const Offset(0.85, 0.30)),
      ],
      'activeMapIndex': 1,
      'movements': [
        MovementLogEntry(timeRange: '08:00 AM', from: 'Clock In — Jalan Pedada', coords: '2.3114° N, 111.8485° E'),
        MovementLogEntry(timeRange: '08:30 AM – 09:00 AM', from: 'Jalan Pedada', to: 'Dewan Suarah', coords: '2.3125° N, 111.8502° E'),
        MovementLogEntry(timeRange: '09:00 AM – 09:30 AM', from: 'Dewan Suarah', to: 'Jalan Maju', coords: '2.3130° N, 111.8520° E'),
        MovementLogEntry(timeRange: '09:30 AM – 10:00 AM', from: 'Jalan Maju', to: 'Jalan Sanyan', coords: '2.3142° N, 111.8535° E'),
        MovementLogEntry(timeRange: '10:00 AM – 10:45 AM', from: 'Jalan Sanyan', isIdle: true, idleDuration: '45 min'),
        MovementLogEntry(timeRange: '10:45 AM – 11:15 AM', from: 'Jalan Sanyan', to: 'KPJ Carpark', coords: '2.3155° N, 111.8548° E'),
        MovementLogEntry(timeRange: '11:15 AM – 11:45 AM', from: 'KPJ Carpark', to: 'Jalan Pedada', coords: '2.3114° N, 111.8485° E'),
        MovementLogEntry(timeRange: '11:45 AM – 12:15 PM', from: 'Jalan Pedada', to: 'Dewan Suarah', coords: '2.3125° N, 111.8502° E'),
        MovementLogEntry(timeRange: '12:15 PM – 01:00 PM', from: 'Dewan Suarah', isIdle: true, idleDuration: '45 min (Lunch)'),
        MovementLogEntry(timeRange: '01:00 PM – 01:30 PM', from: 'Dewan Suarah', to: 'Jalan Maju', coords: '2.3130° N, 111.8520° E'),
        MovementLogEntry(timeRange: '01:30 PM – 02:00 PM', from: 'Jalan Maju', to: 'Jalan Sanyan', coords: '2.3142° N, 111.8535° E'),
        MovementLogEntry(timeRange: '02:00 PM – 02:30 PM', from: 'Jalan Sanyan', to: 'Jalan Pedada', coords: '2.3114° N, 111.8485° E'),
      ],
    },
    'Ahmad Bin Ismail': {
      'distance': '3.8 km',
      'onDuty': '5h 45m',
      'stops': 6,
      'currentFrom': 'KPJ Carpark',
      'currentTo': 'Jalan Chengal',
      'currentTime': '10:30 AM – 11:00 AM',
      'fromCoords': '2.3155° N, 111.8548° E',
      'toCoords': '2.3168° N, 111.8560° E',
      'mapPoints': [
        MapEntry('KPJ Carpark', const Offset(0.20, 0.40)),
        MapEntry('Jln Chengal', const Offset(0.45, 0.25)),
        MapEntry('Jln T. Osman', const Offset(0.65, 0.55)),
        MapEntry('P. Pedada', const Offset(0.80, 0.40)),
      ],
      'activeMapIndex': 0,
      'movements': [
        MovementLogEntry(timeRange: '08:30 AM', from: 'Clock In — KPJ Carpark', coords: '2.3155° N, 111.8548° E'),
        MovementLogEntry(timeRange: '09:00 AM – 09:30 AM', from: 'KPJ Carpark', to: 'Jalan Chengal', coords: '2.3168° N, 111.8560° E'),
        MovementLogEntry(timeRange: '09:30 AM – 10:00 AM', from: 'Jalan Chengal', to: 'Jalan Tunku Osman', coords: '2.3175° N, 111.8575° E'),
        MovementLogEntry(timeRange: '10:00 AM – 10:30 AM', from: 'Jalan Tunku Osman', to: 'Pusat Pedada', coords: '2.3180° N, 111.8590° E'),
        MovementLogEntry(timeRange: '10:30 AM – 11:15 AM', from: 'Pusat Pedada', isIdle: true, idleDuration: '45 min'),
        MovementLogEntry(timeRange: '11:15 AM – 11:45 AM', from: 'Pusat Pedada', to: 'KPJ Carpark', coords: '2.3155° N, 111.8548° E'),
      ],
    },
    'Siti Binti Yusof': {
      'distance': '5.1 km',
      'onDuty': '7h 15m',
      'stops': 10,
      'currentFrom': 'Jalan Maju',
      'currentTo': 'Jalan Chengal',
      'currentTime': '11:00 AM – 11:30 AM',
      'fromCoords': '2.3130° N, 111.8520° E',
      'toCoords': '2.3168° N, 111.8560° E',
      'mapPoints': [
        MapEntry('Jln Maju', const Offset(0.18, 0.50)),
        MapEntry('Jln Chengal', const Offset(0.38, 0.30)),
        MapEntry('Dewan Suarah', const Offset(0.58, 0.60)),
        MapEntry('Jln Pedada', const Offset(0.75, 0.35)),
        MapEntry('KPJ Carpark', const Offset(0.88, 0.55)),
      ],
      'activeMapIndex': 2,
      'movements': [
        MovementLogEntry(timeRange: '07:30 AM', from: 'Clock In — Jalan Maju', coords: '2.3130° N, 111.8520° E'),
        MovementLogEntry(timeRange: '08:00 AM – 08:30 AM', from: 'Jalan Maju', to: 'Jalan Chengal', coords: '2.3168° N, 111.8560° E'),
        MovementLogEntry(timeRange: '08:30 AM – 09:00 AM', from: 'Jalan Chengal', to: 'Dewan Suarah', coords: '2.3125° N, 111.8502° E'),
        MovementLogEntry(timeRange: '09:00 AM – 09:30 AM', from: 'Dewan Suarah', to: 'Jalan Pedada', coords: '2.3114° N, 111.8485° E'),
        MovementLogEntry(timeRange: '09:30 AM – 10:00 AM', from: 'Jalan Pedada', to: 'KPJ Carpark', coords: '2.3155° N, 111.8548° E'),
        MovementLogEntry(timeRange: '10:00 AM – 10:30 AM', from: 'KPJ Carpark', to: 'Jalan Maju', coords: '2.3130° N, 111.8520° E'),
        MovementLogEntry(timeRange: '10:30 AM – 11:00 AM', from: 'Jalan Maju', to: 'Jalan Chengal', coords: '2.3168° N, 111.8560° E'),
        MovementLogEntry(timeRange: '11:00 AM – 11:30 AM', from: 'Jalan Chengal', to: 'Dewan Suarah', coords: '2.3125° N, 111.8502° E'),
      ],
    },
    'Bong Anak Lihan': {
      'distance': '2.9 km',
      'onDuty': '4h 00m',
      'stops': 5,
      'currentFrom': 'Dewan Suarah',
      'currentTo': 'Jalan Pedada',
      'currentTime': '09:30 AM – 10:00 AM',
      'fromCoords': '2.3125° N, 111.8502° E',
      'toCoords': '2.3114° N, 111.8485° E',
      'mapPoints': [
        MapEntry('Dewan Suarah', const Offset(0.25, 0.35)),
        MapEntry('Jln Pedada', const Offset(0.50, 0.55)),
        MapEntry('Jln Sanyan', const Offset(0.75, 0.35)),
      ],
      'activeMapIndex': 0,
      'movements': [
        MovementLogEntry(timeRange: '09:00 AM', from: 'Clock In — Dewan Suarah', coords: '2.3125° N, 111.8502° E'),
        MovementLogEntry(timeRange: '09:30 AM – 10:00 AM', from: 'Dewan Suarah', to: 'Jalan Pedada', coords: '2.3114° N, 111.8485° E'),
        MovementLogEntry(timeRange: '10:00 AM – 10:30 AM', from: 'Jalan Pedada', to: 'Jalan Sanyan', coords: '2.3142° N, 111.8535° E'),
        MovementLogEntry(timeRange: '10:30 AM – 11:30 AM', from: 'Jalan Sanyan', isIdle: true, idleDuration: '1 hr'),
        MovementLogEntry(timeRange: '11:30 AM – 12:00 PM', from: 'Jalan Sanyan', to: 'Dewan Suarah', coords: '2.3125° N, 111.8502° E'),
      ],
    },
    'James Anak Bulan': {
      'distance': '3.5 km',
      'onDuty': '5h 30m',
      'stops': 7,
      'currentFrom': 'Pusat Pedada',
      'currentTo': 'Jalan Maju',
      'currentTime': '10:00 AM – 10:30 AM',
      'fromCoords': '2.3180° N, 111.8590° E',
      'toCoords': '2.3130° N, 111.8520° E',
      'mapPoints': [
        MapEntry('P. Pedada', const Offset(0.20, 0.30)),
        MapEntry('Jln Maju', const Offset(0.45, 0.60)),
        MapEntry('Jln Pedada', const Offset(0.65, 0.35)),
        MapEntry('Dewan Suarah', const Offset(0.85, 0.55)),
      ],
      'activeMapIndex': 1,
      'movements': [
        MovementLogEntry(timeRange: '08:00 AM', from: 'Clock In — Pusat Pedada', coords: '2.3180° N, 111.8590° E'),
        MovementLogEntry(timeRange: '08:30 AM – 09:00 AM', from: 'Pusat Pedada', to: 'Jalan Maju', coords: '2.3130° N, 111.8520° E'),
        MovementLogEntry(timeRange: '09:00 AM – 09:30 AM', from: 'Jalan Maju', to: 'Jalan Pedada', coords: '2.3114° N, 111.8485° E'),
        MovementLogEntry(timeRange: '09:30 AM – 10:00 AM', from: 'Jalan Pedada', to: 'Dewan Suarah', coords: '2.3125° N, 111.8502° E'),
        MovementLogEntry(timeRange: '10:00 AM – 10:30 AM', from: 'Dewan Suarah', to: 'Pusat Pedada', coords: '2.3180° N, 111.8590° E'),
        MovementLogEntry(timeRange: '10:30 AM – 11:00 AM', from: 'Pusat Pedada', to: 'Jalan Maju', coords: '2.3130° N, 111.8520° E'),
        MovementLogEntry(timeRange: '11:00 AM – 11:30 AM', from: 'Jalan Maju', to: 'Dewan Suarah', coords: '2.3125° N, 111.8502° E'),
      ],
    },
  };

  Map<String, dynamic> get _currentMovement => _staffMovementData[_selectedStaff]!;

  // ─── Helpers ───────────────────────────────────────────────────

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[date.weekday - 1]}, ${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFF5A623),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF1F2937),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // ─── Build ─────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final data = _currentMovement;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Staff Movement',
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Staff selector + Date picker row
            Row(
              children: [
                // Staff dropdown
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedStaff,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280), size: 20),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1F2937),
                        ),
                        items: _staffList.map((staff) {
                          return DropdownMenuItem(
                            value: staff,
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3F4F6),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.person, size: 14, color: Color(0xFF9CA3AF)),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    staff,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedStaff = value;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Date picker
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined, color: Color(0xFF6B7280), size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF4B5563),
                                ),
                              ),
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down, color: Color(0xFF6B7280), size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Full date label
            Text(
              _formatDate(_selectedDate),
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF9CA3AF),
              ),
            ),
            const SizedBox(height: 16),

            // Map
            MovementMapWidget(
              points: List<MapEntry<String, Offset>>.from(data['mapPoints']),
              activeIndex: data['activeMapIndex'],
            ),
            const SizedBox(height: 16),

            // Summary Stats
            MovementSummaryStats(
              distance: data['distance'],
              onDuty: data['onDuty'],
              stops: data['stops'],
            ),
            const SizedBox(height: 16),

            // Movement Detail Card
            MovementDetailCard(
              fromLocation: data['currentFrom'],
              toLocation: data['currentTo'],
              timeRange: data['currentTime'],
              fromCoords: data['fromCoords'],
              toCoords: data['toCoords'],
            ),
            const SizedBox(height: 16),

            // Movement Log Timeline
            MovementLogTimeline(
              entries: List<MovementLogEntry>.from(data['movements']),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
