import 'package:flutter/material.dart';
import 'widgets/kpi_summary_card.dart';
import 'widgets/kpi_period_selector.dart';
import 'widgets/kpi_bar_chart.dart';
import 'widgets/kpi_donut_chart.dart';
import 'widgets/kpi_progress_ring.dart';
import 'widgets/kpi_incentive_tier.dart';
import 'widgets/kpi_conversion_card.dart';
import 'widgets/kpi_averages_section.dart';

class KpiDashboardScreen extends StatefulWidget {
  const KpiDashboardScreen({super.key});
  @override
  State<KpiDashboardScreen> createState() => _KpiDashboardScreenState();
}

class _KpiDashboardScreenState extends State<KpiDashboardScreen> {
  int _selectedPeriod = 2;
  DateTime _startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _endDate = DateTime.now();
  String _selectedStaff = 'Mas Anak Mani';
  String _selectedLocation = 'All Locations';
  bool _sortAscending = false;
  bool _showConversionPercentage = true;
  IncentiveTier? _selectedGoalTier;
  String _teamSearchQuery = '';
  String _teamSelectedMonth = 'May 2026';

  final List<String> _staffList = ['All Staff', 'Mas Anak Mani', 'Ahmad Bin Ismail', 'Siti Binti Yusof', 'Betty Anak Darin'];
  final List<String> _locationList = [
    'All Locations', 'Central Business District (CBD)', 'Dewan Suarah', 'Jalan Central',
    'Jalan Chengal', 'Jalan Kampung Nyabor', 'Jalan Lanang', 'Jalan Maju',
    'Jalan Oya', 'Jalan Pedada', 'Jalan Sanyan', 'Jalan Tunku Osman',
    'Jalan Tuanku Osman', 'Jalan Wong Nai Siong', 'KPJ Carpark',
    'Pasar Sentral Sibu', 'Pusat Pedada', 'Sibu Town Square',
  ];

  // Per-staff KPI data keyed by staff name, then by period
  static final _staffKpiData = <String, Map<int, Map<String, dynamic>>>{
    // GOLD tier — Overperforming (342 compounds, 156 OPNs)
    'Mas Anak Mani': _buildStaffPeriods(
      today: (img: 47, comp: 12, opn: 8, rev: 'RM 480'),
      week: (img: 312, comp: 78, opn: 45, rev: 'RM 3,120'),
      month: (img: 1284, comp: 342, opn: 156, rev: 'RM 13,680'),
      year: (img: 15408, comp: 4104, opn: 1872, rev: 'RM 164,160'),
    ),
    // SILVER tier — On Track (180 compounds, 72 OPNs)
    'Ahmad Bin Ismail': _buildStaffPeriods(
      today: (img: 38, comp: 8, opn: 4, rev: 'RM 320'),
      week: (img: 198, comp: 42, opn: 18, rev: 'RM 1,680'),
      month: (img: 820, comp: 180, opn: 72, rev: 'RM 7,200'),
      year: (img: 9840, comp: 2160, opn: 864, rev: 'RM 86,400'),
    ),
    // BRONZE tier — Underperforming (95 compounds, 38 OPNs)
    'Siti Binti Yusof': _buildStaffPeriods(
      today: (img: 22, comp: 4, opn: 2, rev: 'RM 160'),
      week: (img: 115, comp: 22, opn: 10, rev: 'RM 880'),
      month: (img: 480, comp: 95, opn: 38, rev: 'RM 3,800'),
      year: (img: 5760, comp: 1140, opn: 456, rev: 'RM 45,600'),
    ),
    // PLATINUM tier — Max (420 compounds, 210 OPNs)
    'Betty Anak Darin': _buildStaffPeriods(
      today: (img: 58, comp: 16, opn: 10, rev: 'RM 640'),
      week: (img: 380, comp: 98, opn: 52, rev: 'RM 3,920'),
      month: (img: 1580, comp: 420, opn: 210, rev: 'RM 16,800'),
      year: (img: 18960, comp: 5040, opn: 2520, rev: 'RM 201,600'),
    ),
  };

  /// Builds all 4 period entries for a staff member.
  static Map<int, Map<String, dynamic>> _buildStaffPeriods({
    required ({int img, int comp, int opn, String rev}) today,
    required ({int img, int comp, int opn, String rev}) week,
    required ({int img, int comp, int opn, String rev}) month,
    required ({int img, int comp, int opn, String rev}) year,
  }) {
    Map<String, dynamic> entry(int images, String imgD, int comp, String compD, bool compPos,
        int opns, String opnD, bool opnPos, String rev, String revD, int target, int goal,
        double avgI, double avgC, double avgO) => {
      'imagesTaken': images, 'imagesDelta': imgD, 'imagesPositive': true,
      'imagesSparkline': List.generate(7, (i) => (images * (0.7 + i * 0.05))),
      'compoundsIssued': comp, 'compoundsDelta': compD, 'compoundsPositive': compPos,
      'compoundsSparkline': List.generate(7, (i) => (comp * (0.7 + i * 0.05))),
      'opnsIssued': opns, 'opnsDelta': opnD, 'opnsPositive': opnPos,
      'opnsSparkline': List.generate(7, (i) => (opns * (0.7 + i * 0.05))),
      'revenueCollected': rev, 'revenueDelta': revD, 'revenuePositive': true,
      'revenueSparkline': List.generate(7, (i) => (target * (0.7 + i * 0.05))),
      'dailyTarget': target, 'dailyGoal': goal,
      'avgDailyImages': avgI, 'avgDailyCompounds': avgC, 'avgDailyOPNs': avgO,
      'topLocations': [
        MapEntry('Jalan Pedada', (comp * 0.26).round()),
        MapEntry('Dewan Suarah', (comp * 0.21).round()),
        MapEntry('Jalan Maju', (comp * 0.18).round()),
        MapEntry('KPJ Carpark', (comp * 0.16).round()),
        MapEntry('Jalan Sanyan', (comp * 0.13).round()),
      ],
      'offenceBreakdown': [
        DonutSegment(label: 'Overparking', value: (opns * 0.55).round(), color: const Color(0xFFF5A623)),
        DonutSegment(label: 'No Coupon', value: (opns * 0.25).round(), color: const Color(0xFF3B82F6)),
        DonutSegment(label: 'Exp. Coupon', value: (opns * 0.13).round(), color: const Color(0xFFEF4444)),
        DonutSegment(label: 'Other', value: (opns * 0.07).round(), color: const Color(0xFF8B5CF6)),
      ],
    };
    return {
      0: entry(today.img, '+8%', today.comp, '+15%', true, today.opn, '+5%', true,
          today.rev, '+22%', today.img, (today.img * 1.3).round(), today.img.toDouble(), today.comp.toDouble(), today.opn.toDouble()),
      1: entry(week.img, '+12%', week.comp, '-3%', false, week.opn, '+9%', true,
          week.rev, '+18%', week.img, (week.img * 1.3).round(), week.img / 7, week.comp / 7, week.opn / 7),
      2: entry(month.img, '+6%', month.comp, '+10%', true, month.opn, '-2%', false,
          month.rev, '+14%', month.img, (month.img * 1.2).round(), month.img / 30, month.comp / 30, month.opn / 30),
      3: entry(year.img, '+20%', year.comp, '+7%', true, year.opn, '+11%', true,
          year.rev, '+25%', year.img, (year.img * 1.15).round(), year.img / 365, year.comp / 365, year.opn / 365),
    };
  }

  Map<String, dynamic> get _currentData {
    if (_selectedStaff == 'All Staff') return _aggregatedData;
    return _staffKpiData[_selectedStaff]![_selectedPeriod]!;
  }

  Map<String, dynamic> get _aggregatedData {
    final all = _staffKpiData.values.map((s) => s[_selectedPeriod]!).toList();
    int sumInt(String k) => all.fold<int>(0, (s, d) => s + (d[k] as int));
    double sumDbl(String k) => all.fold<double>(0, (s, d) => s + (d[k] as num).toDouble());
    final img = sumInt('imagesTaken'), comp = sumInt('compoundsIssued'), opn = sumInt('opnsIssued');
    return {
      'imagesTaken': img, 'imagesDelta': '+10%', 'imagesPositive': true,
      'imagesSparkline': List.generate(7, (i) => img * (0.7 + i * 0.05)),
      'compoundsIssued': comp, 'compoundsDelta': '+8%', 'compoundsPositive': true,
      'compoundsSparkline': List.generate(7, (i) => comp * (0.7 + i * 0.05)),
      'opnsIssued': opn, 'opnsDelta': '+6%', 'opnsPositive': true,
      'opnsSparkline': List.generate(7, (i) => opn * (0.7 + i * 0.05)),
      'revenueCollected': 'RM ${(img * 10).toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
      'revenueDelta': '+15%', 'revenuePositive': true,
      'revenueSparkline': List.generate(7, (i) => img * 10 * (0.7 + i * 0.05)),
      'dailyTarget': img, 'dailyGoal': (img * 1.2).round(),
      'avgDailyImages': sumDbl('avgDailyImages') / all.length,
      'avgDailyCompounds': sumDbl('avgDailyCompounds') / all.length,
      'avgDailyOPNs': sumDbl('avgDailyOPNs') / all.length,
      'topLocations': [
        MapEntry('Jalan Pedada', (comp * 0.26).round()),
        MapEntry('Dewan Suarah', (comp * 0.21).round()),
        MapEntry('Jalan Maju', (comp * 0.18).round()),
        MapEntry('KPJ Carpark', (comp * 0.16).round()),
        MapEntry('Jalan Sanyan', (comp * 0.13).round()),
      ],
      'offenceBreakdown': [
        DonutSegment(label: 'Overparking', value: (opn * 0.55).round(), color: const Color(0xFFF5A623)),
        DonutSegment(label: 'No Coupon', value: (opn * 0.25).round(), color: const Color(0xFF3B82F6)),
        DonutSegment(label: 'Exp. Coupon', value: (opn * 0.13).round(), color: const Color(0xFFEF4444)),
        DonutSegment(label: 'Other', value: (opn * 0.07).round(), color: const Color(0xFF8B5CF6)),
      ],
    };
  }

  StaffMonthlyData? get _monthlyData => _selectedStaff == 'All Staff' ? null : kStaffMonthlyData[_selectedStaff];

  String _formatDate(DateTime d) {
    const m = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${m[d.month-1]} ${d.day.toString().padLeft(2,'0')}, ${d.year}';
  }
  String get _dateRangeLabel => _startDate == _endDate ? _formatDate(_startDate) : '${_formatDate(_startDate)}  →  ${_formatDate(_endDate)}';

  Future<void> _selectDateRange(BuildContext ctx) async {
    final picked = await showDateRangePicker(context: ctx, firstDate: DateTime(2020), lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      builder: (c, child) => Theme(data: ThemeData.light().copyWith(colorScheme: const ColorScheme.light(primary: Color(0xFFF5A623), onPrimary: Colors.white, surface: Colors.white, onSurface: Color(0xFF1F2937))), child: child!));
    if (picked != null) setState(() { _startDate = picked.start; _endDate = picked.end; });
  }

  void _showGoalPicker() {
    final monthly = _monthlyData;
    if (monthly == null) return;
    final currentTier = getCurrentTier(monthly.monthlyCompounds, monthly.monthlyOPNs);
    final currentIdx = kTiers.indexOf(currentTier);
    final availableTiers = kTiers.where((t) => kTiers.indexOf(t) > currentIdx).toList();
    if (availableTiers.isEmpty) return;

    showModalBottomSheet(context: context, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => Padding(padding: const EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Set Incentive Goal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1F2937))),
        const SizedBox(height: 4),
        const Text('Choose your target tier for this month', style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
        const SizedBox(height: 16),
        ...availableTiers.map((tier) => ListTile(
          leading: Icon(tier.icon, color: tier.color),
          title: Text(tier.name, style: TextStyle(fontWeight: FontWeight.w600, color: tier.color)),
          subtitle: Text('≥${tier.minCompounds} compounds & ≥${tier.minOPNs} OPNs → RM ${tier.bonusRM}', style: const TextStyle(fontSize: 11)),
          trailing: const Icon(Icons.chevron_right, size: 20),
          onTap: () { Navigator.pop(ctx); setState(() => _selectedGoalTier = tier.tier); },
        )),
        const SizedBox(height: 12),
      ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = _currentData;
    final monthly = _monthlyData;
    final isAllStaff = _selectedStaff == 'All Staff';
    final topLoc = List<MapEntry<String, int>>.from(data['topLocations']);
    _sortAscending ? topLoc.sort((a,b) => a.value.compareTo(b.value)) : topLoc.sort((a,b) => b.value.compareTo(a.value));

    final int images = data['imagesTaken'], compounds = data['compoundsIssued'], opns = data['opnsIssued'];

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20), onPressed: () => Navigator.of(context).pop()),
        title: const Text('KPI Dashboard', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 18)),
        centerTitle: true, backgroundColor: Colors.white, elevation: 0, surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Staff + Location filters
          Row(children: [
            Expanded(child: _buildDropdown(_selectedStaff, _staffList, (v) => setState(() { _selectedStaff = v; _selectedGoalTier = null; }))),
            const SizedBox(width: 10),
            Expanded(child: _buildDropdown(_selectedLocation, _locationList, (v) => setState(() => _selectedLocation = v))),
          ]),
          const SizedBox(height: 16),

          // Period selector
          KpiPeriodSelector(selectedIndex: _selectedPeriod,
            onSelected: (i) => setState(() {
              _selectedPeriod = i;
              final now = DateTime.now();
              switch(i) { case 0: _startDate = _endDate = now; case 1: _startDate = now.subtract(Duration(days: now.weekday-1)); _endDate = now;
                case 2: _startDate = DateTime(now.year, now.month, 1); _endDate = now; case 3: _startDate = DateTime(now.year, 1, 1); _endDate = now; }
            }),
            onCustomDateTap: () => _selectDateRange(context), dateRangeLabel: _dateRangeLabel),
          const SizedBox(height: 16),

          // 4 Summary cards
          Row(children: [
            Expanded(child: KpiSummaryCard(title: 'Images Taken', value: '$images', delta: data['imagesDelta'], isPositive: data['imagesPositive'],
              icon: Icons.camera_alt_outlined, accentColor: const Color(0xFF3B82F6), sparklineData: List<double>.from(data['imagesSparkline']))),
            const SizedBox(width: 10),
            Expanded(child: KpiSummaryCard(title: 'Compounds Issued', value: '$compounds', delta: data['compoundsDelta'], isPositive: data['compoundsPositive'],
              icon: Icons.receipt_long_outlined, accentColor: const Color(0xFFF5A623), sparklineData: List<double>.from(data['compoundsSparkline']))),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: KpiSummaryCard(title: 'OPNs Issued', value: '$opns', delta: data['opnsDelta'], isPositive: data['opnsPositive'],
              icon: Icons.description_outlined, accentColor: const Color(0xFF8B5CF6), sparklineData: List<double>.from(data['opnsSparkline']))),
            const SizedBox(width: 10),
            Expanded(child: KpiSummaryCard(title: 'Revenue Collected', value: data['revenueCollected'], delta: data['revenueDelta'], isPositive: data['revenuePositive'],
              icon: Icons.payments_outlined, accentColor: const Color(0xFF10B981), sparklineData: List<double>.from(data['revenueSparkline']))),
          ]),
          const SizedBox(height: 16),

          // Daily Averages (ABOVE Incentive Tier for All Staff)
          if (isAllStaff) ...[
            KpiAveragesSection(
              avgDailyImages: (data['avgDailyImages'] as num).toDouble(),
              avgDailyCompounds: (data['avgDailyCompounds'] as num).toDouble(),
              avgDailyOPNs: (data['avgDailyOPNs'] as num).toDouble(),
              showImages: true, showCompounds: true, showOPNs: true,
              onToggleImages: (_) {}, onToggleCompounds: (_) {}, onToggleOPNs: (_) {},
            ),
            const SizedBox(height: 16),
          ],

          // Incentive Tier — BELOW the 4 cards (or below Averages for All Staff), uses MONTHLY totals only
          if (!isAllStaff && monthly != null)
            KpiIncentiveTier(
              monthlyCompounds: monthly.monthlyCompounds,
              monthlyOPNs: monthly.monthlyOPNs,
              goalTier: _selectedGoalTier ?? monthly.goalTier,
              onSetGoal: _showGoalPicker,
            )
          else if (isAllStaff)
            _buildAllStaffIncentiveSummary(),
          const SizedBox(height: 16),

          // Conversion Rate
          KpiConversionCard(imagesTaken: images, compounds: compounds, opns: opns,
            showPercentage: _showConversionPercentage, onToggle: () => setState(() => _showConversionPercentage = !_showConversionPercentage)),
          const SizedBox(height: 16),

          // Target Progress Ring
          KpiProgressRing(current: data['dailyTarget'], target: data['dailyGoal'],
            label: ['Daily Target', 'Weekly Target', 'Monthly Target', 'Yearly Target'][_selectedPeriod]),
          const SizedBox(height: 16),

          // Daily Averages (BELOW Progress Ring for individual staff)
          if (!isAllStaff) ...[
            KpiAveragesSection(
              avgDailyImages: (data['avgDailyImages'] as num).toDouble(),
              avgDailyCompounds: (data['avgDailyCompounds'] as num).toDouble(),
              avgDailyOPNs: (data['avgDailyOPNs'] as num).toDouble(),
              showImages: true, showCompounds: true, showOPNs: true,
              onToggleImages: (_) {}, onToggleCompounds: (_) {}, onToggleOPNs: (_) {},
            ),
            const SizedBox(height: 16),
          ],

          // Bar Chart + Donut
          KpiBarChart(data: topLoc, sortAscending: _sortAscending, onSortToggle: () => setState(() => _sortAscending = !_sortAscending)),
          const SizedBox(height: 16),
          KpiDonutChart(segments: List<DonutSegment>.from(data['offenceBreakdown'])),
          const SizedBox(height: 24),
        ]),
      ),
    );
  }

  Widget _buildAllStaffIncentiveSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [
          Text('Team Incentive Overview', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE5E7EB))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                const Icon(Icons.search, size: 16, color: Color(0xFF9CA3AF)),
                const SizedBox(width: 8),
                Expanded(child: TextField(
                  onChanged: (v) => setState(() => _teamSearchQuery = v),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                    hintText: 'Search Name/PWID...',
                    hintStyle: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                  ),
                  style: const TextStyle(fontSize: 12),
                )),
              ]),
            )
          ),
          const SizedBox(width: 8),
          Container(
            height: 36, padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE5E7EB))),
            child: DropdownButtonHideUnderline(child: DropdownButton<String>(
              value: _teamSelectedMonth,
              icon: const Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFF6B7280)),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF4B5563)),
              items: ['May 2026', 'April 2026', 'March 2026'].map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
              onChanged: (v) => setState(() => _teamSelectedMonth = v!),
            )),
          ),
        ]),
        const SizedBox(height: 12),
        ...kStaffMonthlyData.entries.where((e) {
          if (_teamSearchQuery.isEmpty) return true;
          final q = _teamSearchQuery.toLowerCase();
          return e.value.name.toLowerCase().contains(q) || e.value.pwid.toLowerCase().contains(q);
        }).map((e) {
          final d = e.value;
          final tier = getCurrentTier(d.monthlyCompounds, d.monthlyOPNs);
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: tier.color.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: tier.color.withValues(alpha: 0.15)),
            ),
            child: Row(children: [
              Icon(tier.icon, size: 18, color: tier.color),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(color: const Color(0xFFF5A623).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(4)),
                      child: Text(d.pwid, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFFD4891A))),
                    ),
                    Expanded(child: Text(d.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1F2937)), overflow: TextOverflow.ellipsis)),
                  ],
                ),
                const SizedBox(height: 2),
                Text('${d.monthlyCompounds} compounds · ${d.monthlyOPNs} OPNs', style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
              ])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(tier.name, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: tier.color)),
                Text('RM ${tier.bonusRM}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF4B5563))),
              ]),
            ]),
          );
        }),
        const Divider(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Total Team Incentive', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1F2937))),
          Text('RM ${kStaffMonthlyData.values.where((d) {
            if (_teamSearchQuery.isEmpty) return true;
            final q = _teamSearchQuery.toLowerCase();
            return d.name.toLowerCase().contains(q) || d.pwid.toLowerCase().contains(q);
          }).fold<int>(0, (s, d) => s + getCurrentTier(d.monthlyCompounds, d.monthlyOPNs).bonusRM)}',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFFF5A623))),
        ]),
      ]),
    );
  }

  Widget _buildDropdown(String value, List<String> items, ValueChanged<String> onChanged) {
    return Container(height: 44, padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: value, isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280), size: 18),
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1F2937)),
        items: items.map((v) => DropdownMenuItem(value: v, child: Text(v, overflow: TextOverflow.ellipsis))).toList(),
        onChanged: (v) { if (v != null) onChanged(v); })));
  }
}
