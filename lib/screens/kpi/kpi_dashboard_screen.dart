import 'package:flutter/material.dart';
import 'widgets/kpi_summary_card.dart';
import 'widgets/kpi_period_selector.dart';
import 'widgets/kpi_bar_chart.dart';
import 'widgets/kpi_donut_chart.dart';
import 'widgets/kpi_progress_ring.dart';

class KpiDashboardScreen extends StatefulWidget {
  const KpiDashboardScreen({super.key});

  @override
  State<KpiDashboardScreen> createState() => _KpiDashboardScreenState();
}

class _KpiDashboardScreenState extends State<KpiDashboardScreen> {
  int _selectedPeriod = 0; // 0=Today, 1=Week, 2=Month, 3=Year
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  // Dropdown states
  String _selectedStaff = 'All Staff';
  String _selectedLocation = 'All Locations';

  final List<String> _staffList = ['All Staff', 'Mas Anak Mani', 'Ahmad Bin Ismail', 'Siti Binti Yusof'];
  final List<String> _locationList = ['All Locations', 'Jalan Pedada', 'Dewan Suarah', 'Jalan Maju', 'KPJ Carpark', 'Jalan Sanyan'];

  // Sort state
  bool _sortAscending = false;

  // ─── Dummy KPI Data by Period ──────────────────────────────────

  final Map<int, Map<String, dynamic>> _kpiData = {
    0: {
      'vehiclesScanned': 47,
      'vehiclesDelta': '+8%',
      'vehiclesPositive': true,
      'vehiclesSparkline': [30.0, 35.0, 28.0, 40.0, 38.0, 42.0, 47.0],
      'compoundsIssued': 12,
      'compoundsDelta': '+15%',
      'compoundsPositive': true,
      'compoundsSparkline': [8.0, 6.0, 10.0, 9.0, 11.0, 10.0, 12.0],
      'opnsIssued': 68,
      'opnsDelta': '+5%',
      'opnsPositive': true,
      'opnsSparkline': [50.0, 55.0, 60.0, 58.0, 62.0, 65.0, 68.0],
      'revenueCollected': 'RM 480',
      'revenueDelta': '+22%',
      'revenuePositive': true,
      'revenueSparkline': [300.0, 350.0, 280.0, 400.0, 380.0, 420.0, 480.0],
      'dailyTarget': 47,
      'dailyGoal': 60,
      'topLocations': [
        MapEntry('Jalan Pedada', 18),
        MapEntry('Dewan Suarah', 12),
        MapEntry('Jalan Maju', 9),
        MapEntry('KPJ Carpark', 5),
        MapEntry('Jalan Sanyan', 3),
      ],
      'offenceBreakdown': [
        DonutSegment(label: 'Overparking', value: 38, color: Color(0xFFF5A623)),
        DonutSegment(label: 'No Coupon', value: 18, color: Color(0xFF3B82F6)),
        DonutSegment(label: 'Exp. Coupon', value: 8, color: Color(0xFFEF4444)),
        DonutSegment(label: 'Other', value: 4, color: Color(0xFF8B5CF6)),
      ],
    },
    1: {
      'vehiclesScanned': 312,
      'vehiclesDelta': '+12%',
      'vehiclesPositive': true,
      'vehiclesSparkline': [40.0, 45.0, 38.0, 50.0, 48.0, 44.0, 47.0],
      'compoundsIssued': 78,
      'compoundsDelta': '-3%',
      'compoundsPositive': false,
      'compoundsSparkline': [14.0, 12.0, 10.0, 13.0, 9.0, 11.0, 9.0],
      'opnsIssued': 445,
      'opnsDelta': '+9%',
      'opnsPositive': true,
      'opnsSparkline': [58.0, 62.0, 65.0, 60.0, 66.0, 68.0, 66.0],
      'revenueCollected': 'RM 3,120',
      'revenueDelta': '+18%',
      'revenuePositive': true,
      'revenueSparkline': [380.0, 420.0, 460.0, 400.0, 480.0, 500.0, 480.0],
      'dailyTarget': 312,
      'dailyGoal': 420,
      'topLocations': [
        MapEntry('Jalan Pedada', 85),
        MapEntry('Dewan Suarah', 72),
        MapEntry('Jalan Maju', 58),
        MapEntry('KPJ Carpark', 52),
        MapEntry('Jalan Sanyan', 45),
      ],
      'offenceBreakdown': [
        DonutSegment(label: 'Overparking', value: 180, color: Color(0xFFF5A623)),
        DonutSegment(label: 'No Coupon', value: 95, color: Color(0xFF3B82F6)),
        DonutSegment(label: 'Exp. Coupon', value: 52, color: Color(0xFFEF4444)),
        DonutSegment(label: 'Other', value: 18, color: Color(0xFF8B5CF6)),
      ],
    },
    2: {
      'vehiclesScanned': 1284,
      'vehiclesDelta': '+6%',
      'vehiclesPositive': true,
      'vehiclesSparkline': [280.0, 310.0, 290.0, 340.0, 360.0, 350.0, 354.0],
      'compoundsIssued': 342,
      'compoundsDelta': '+10%',
      'compoundsPositive': true,
      'compoundsSparkline': [70.0, 80.0, 75.0, 85.0, 90.0, 88.0, 94.0],
      'opnsIssued': 1856,
      'opnsDelta': '-2%',
      'opnsPositive': false,
      'opnsSparkline': [480.0, 460.0, 470.0, 450.0, 468.0, 458.0, 470.0],
      'revenueCollected': 'RM 13,680',
      'revenueDelta': '+14%',
      'revenuePositive': true,
      'revenueSparkline': [3000.0, 3200.0, 3100.0, 3400.0, 3500.0, 3480.0, 3600.0],
      'dailyTarget': 1284,
      'dailyGoal': 1500,
      'topLocations': [
        MapEntry('Jalan Pedada', 320),
        MapEntry('Dewan Suarah', 285),
        MapEntry('Jalan Maju', 240),
        MapEntry('KPJ Carpark', 228),
        MapEntry('Jalan Sanyan', 211),
      ],
      'offenceBreakdown': [
        DonutSegment(label: 'Overparking', value: 780, color: Color(0xFFF5A623)),
        DonutSegment(label: 'No Coupon', value: 380, color: Color(0xFF3B82F6)),
        DonutSegment(label: 'Exp. Coupon', value: 220, color: Color(0xFFEF4444)),
        DonutSegment(label: 'Other', value: 76, color: Color(0xFF8B5CF6)),
      ],
    },
    3: {
      'vehiclesScanned': 15408,
      'vehiclesDelta': '+20%',
      'vehiclesPositive': true,
      'vehiclesSparkline': [1100.0, 1200.0, 1150.0, 1250.0, 1300.0, 1280.0, 1328.0],
      'compoundsIssued': 4104,
      'compoundsDelta': '+7%',
      'compoundsPositive': true,
      'compoundsSparkline': [300.0, 320.0, 310.0, 350.0, 360.0, 340.0, 374.0],
      'opnsIssued': 22272,
      'opnsDelta': '+11%',
      'opnsPositive': true,
      'opnsSparkline': [1700.0, 1800.0, 1750.0, 1850.0, 1900.0, 1880.0, 1942.0],
      'revenueCollected': 'RM 164,160',
      'revenueDelta': '+25%',
      'revenuePositive': true,
      'revenueSparkline': [12000.0, 13000.0, 12500.0, 13500.0, 14000.0, 13800.0, 14330.0],
      'dailyTarget': 15408,
      'dailyGoal': 18000,
      'topLocations': [
        MapEntry('Jalan Pedada', 3840),
        MapEntry('Dewan Suarah', 3420),
        MapEntry('Jalan Maju', 2880),
        MapEntry('KPJ Carpark', 2736),
        MapEntry('Jalan Sanyan', 2532),
      ],
      'offenceBreakdown': [
        DonutSegment(label: 'Overparking', value: 9360, color: Color(0xFFF5A623)),
        DonutSegment(label: 'No Coupon', value: 4560, color: Color(0xFF3B82F6)),
        DonutSegment(label: 'Exp. Coupon', value: 2640, color: Color(0xFFEF4444)),
        DonutSegment(label: 'Other', value: 912, color: Color(0xFF8B5CF6)),
      ],
    },
  };

  Map<String, dynamic> get _currentData => _kpiData[_selectedPeriod]!;

  // ─── Helpers ───────────────────────────────────────────────────

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}';
  }

  String get _dateRangeLabel {
    if (_startDate.year == _endDate.year &&
        _startDate.month == _endDate.month &&
        _startDate.day == _endDate.day) {
      return _formatDate(_startDate);
    }
    return '${_formatDate(_startDate)}  →  ${_formatDate(_endDate)}';
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
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
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  // ─── Build ─────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final data = _currentData;
    final topLocations = List<MapEntry<String, int>>.from(data['topLocations']);

    // Apply sort
    if (_sortAscending) {
      topLocations.sort((a, b) => a.value.compareTo(b.value));
    } else {
      topLocations.sort((a, b) => b.value.compareTo(a.value));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'KPI Dashboard',
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
            // Staff and Location filters
            Row(
              children: [
                Expanded(
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
                        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280), size: 18),
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1F2937)),
                        items: _staffList.map((staff) {
                          return DropdownMenuItem(value: staff, child: Text(staff, overflow: TextOverflow.ellipsis));
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedStaff = value);
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
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
                        value: _selectedLocation,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280), size: 18),
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1F2937)),
                        items: _locationList.map((loc) {
                          return DropdownMenuItem(value: loc, child: Text(loc, overflow: TextOverflow.ellipsis));
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedLocation = value);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Period selector + date picker
            KpiPeriodSelector(
              selectedIndex: _selectedPeriod,
              onSelected: (index) {
                setState(() {
                  _selectedPeriod = index;
                  // Update date range based on selection
                  final now = DateTime.now();
                  switch (index) {
                    case 0:
                      _startDate = now;
                      _endDate = now;
                      break;
                    case 1:
                      _startDate = now.subtract(Duration(days: now.weekday - 1));
                      _endDate = now;
                      break;
                    case 2:
                      _startDate = DateTime(now.year, now.month, 1);
                      _endDate = now;
                      break;
                    case 3:
                      _startDate = DateTime(now.year, 1, 1);
                      _endDate = now;
                      break;
                  }
                });
              },
              onCustomDateTap: () => _selectDateRange(context),
              dateRangeLabel: _dateRangeLabel,
            ),
            const SizedBox(height: 16),

            // Summary metric cards — 2x2 grid
            Row(
              children: [
                Expanded(
                  child: KpiSummaryCard(
                    title: 'Vehicles Scanned',
                    value: '${data['vehiclesScanned']}',
                    delta: data['vehiclesDelta'],
                    isPositive: data['vehiclesPositive'],
                    icon: Icons.directions_car_outlined,
                    accentColor: const Color(0xFF3B82F6),
                    sparklineData: List<double>.from(data['vehiclesSparkline']),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: KpiSummaryCard(
                    title: 'Compounds Issued',
                    value: '${data['compoundsIssued']}',
                    delta: data['compoundsDelta'],
                    isPositive: data['compoundsPositive'],
                    icon: Icons.receipt_long_outlined,
                    accentColor: const Color(0xFFF5A623),
                    sparklineData: List<double>.from(data['compoundsSparkline']),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: KpiSummaryCard(
                    title: 'OPNs Issued',
                    value: '${data['opnsIssued']}',
                    delta: data['opnsDelta'],
                    isPositive: data['opnsPositive'],
                    icon: Icons.description_outlined,
                    accentColor: const Color(0xFF10B981),
                    sparklineData: List<double>.from(data['opnsSparkline']),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: KpiSummaryCard(
                    title: 'Revenue Collected',
                    value: data['revenueCollected'],
                    delta: data['revenueDelta'],
                    isPositive: data['revenuePositive'],
                    icon: Icons.payments_outlined,
                    accentColor: const Color(0xFF8B5CF6),
                    sparklineData: List<double>.from(data['revenueSparkline']),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Daily Target Progress Ring
            KpiProgressRing(
              current: data['dailyTarget'],
              target: data['dailyGoal'],
              label: _selectedPeriod == 0
                  ? 'Daily Target'
                  : _selectedPeriod == 1
                      ? 'Weekly Target'
                      : _selectedPeriod == 2
                          ? 'Monthly Target'
                          : 'Yearly Target',
            ),
            const SizedBox(height: 16),

            // Top Locations Bar Chart
            KpiBarChart(
              data: topLocations,
              sortAscending: _sortAscending,
              onSortToggle: () {
                setState(() {
                  _sortAscending = !_sortAscending;
                });
              },
            ),
            const SizedBox(height: 16),

            // Offence Breakdown Donut Chart
            KpiDonutChart(
              segments: List<DonutSegment>.from(data['offenceBreakdown']),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
