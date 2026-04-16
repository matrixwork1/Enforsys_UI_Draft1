import 'package:flutter/material.dart';
import '../../widgets/elderly_keyboard/elderly_text_field.dart';
import '../../shared/shared.dart';
import '../../widgets/full_screen_image_viewer.dart';
import 'coupon_detail_screen.dart';
import 'season_pass_detail_screen.dart';
import '../offence/offence_detail_screen.dart';
import '../offence/opn_detail_screen.dart';

class CarPlateEnquiryScreen extends StatefulWidget {
  final String plateNumber;

  const CarPlateEnquiryScreen({super.key, required this.plateNumber});

  @override
  State<CarPlateEnquiryScreen> createState() => _CarPlateEnquiryScreenState();
}

class _CarPlateEnquiryScreenState extends State<CarPlateEnquiryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _searchController;
  late String _currentPlate;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  // ─── Dummy Data ────────────────────────────────────────────────

  final List<Map<String, dynamic>> _parkingData = [
    {'dateRange': '09:12 AM - 09:42 AM', 'location': 'Jalan Chengal', 'sessions': '1 Session', 'amount': 'RM 0.42', 'status': 'Active', 'couponNo': 'UC2604062252898', 'date': '04/06/2026', 'paymentMethod': 'eWallet Credits', 'purchaseAt': '2026-04-06 9:11 AM', 'refNo': '9a57495db4', 'duration': '30 minutes'},
    {'dateRange': '03:17 PM - 03:47 PM', 'location': 'Jalan Chengal', 'sessions': '1 Session', 'amount': 'RM 0.42', 'status': 'Expired', 'couponNo': 'UC2604022252896', 'date': '04/02/2026', 'paymentMethod': 'eWallet Credits', 'purchaseAt': '2026-04-02 3:16 PM', 'refNo': '0c94ac2e1c', 'duration': '30 minutes'},
    {'dateRange': '02:31 PM - 03:01 PM', 'location': 'KPJ Carpark', 'sessions': '1 Session', 'amount': 'RM 0.42', 'status': 'Active', 'couponNo': 'UC2604022252890', 'date': '04/02/2026', 'paymentMethod': 'eWallet Credits', 'purchaseAt': '2026-04-02 2:30 PM', 'refNo': 'ab12cd34ef', 'duration': '30 minutes'},
    {'dateRange': '08:10 AM - 08:40 AM', 'location': 'Jalan Pedada', 'sessions': '1 Session', 'amount': 'RM 0.42', 'status': 'Expired', 'couponNo': 'UC2604022252888', 'date': '04/02/2026', 'paymentMethod': 'eWallet Credits', 'purchaseAt': '2026-04-02 8:09 AM', 'refNo': 'ff56gh78ij', 'duration': '30 minutes'},
    {'dateRange': '10:00 AM - 10:30 AM', 'location': 'Dewan Suarah', 'sessions': '1 Session', 'amount': 'RM 0.42', 'status': 'Active', 'couponNo': 'UC2603312252880', 'date': '03/31/2026', 'paymentMethod': 'eWallet Credits', 'purchaseAt': '2026-03-31 9:59 AM', 'refNo': 'kl90mn12op', 'duration': '30 minutes'},
    {'dateRange': '11:15 AM - 11:45 AM', 'location': 'Jalan Sanyan', 'sessions': '2 Sessions', 'amount': 'RM 0.84', 'status': 'Expired', 'couponNo': 'UC2603312252878', 'date': '03/31/2026', 'paymentMethod': 'eWallet Credits', 'purchaseAt': '2026-03-31 11:14 AM', 'refNo': 'qr34st56uv', 'duration': '30 minutes'},
    {'dateRange': '01:45 PM - 02:15 PM', 'location': 'Jalan Maju', 'sessions': '1 Session', 'amount': 'RM 0.42', 'status': 'Active', 'couponNo': 'UC2603302252870', 'date': '03/30/2026', 'paymentMethod': 'eWallet Credits', 'purchaseAt': '2026-03-30 1:44 PM', 'refNo': 'wx78yz90ab', 'duration': '30 minutes'},
    {'dateRange': '04:00 PM - 04:30 PM', 'location': 'Jalan Tunku Osman', 'sessions': '1 Session', 'amount': 'RM 0.42', 'status': 'Expired', 'couponNo': 'UC2603302252868', 'date': '03/30/2026', 'paymentMethod': 'eWallet Credits', 'purchaseAt': '2026-03-30 3:59 PM', 'refNo': 'cd12ef34gh', 'duration': '30 minutes'},
  ];

  final List<Map<String, dynamic>> _seasonPassData = [
    {'plate': '', 'period': 'Apr 2026', 'location': 'Pusat Pedada', 'amount': 'RM 42.40', 'status': 'Active', 'passNo': 'SP2604010001', 'startDate': '2026-04-01', 'endDate': '2026-04-30', 'vehicleType': 'Car'},
    {'plate': '', 'period': 'Apr 2026', 'location': 'Dewan Suarah', 'amount': 'RM 42.40', 'status': 'Active', 'passNo': 'SP2604010002', 'startDate': '2026-04-01', 'endDate': '2026-04-30', 'vehicleType': 'Car'},
    {'plate': '', 'period': 'Mar 2026', 'location': 'Jalan Pedada', 'amount': 'RM 42.40', 'status': 'Expired', 'passNo': 'SP2603010001', 'startDate': '2026-03-01', 'endDate': '2026-03-31', 'vehicleType': 'Car'},
    {'plate': '', 'period': 'Mar 2026', 'location': 'KPJ Carpark', 'amount': 'RM 42.40', 'status': 'Expired', 'passNo': 'SP2603010002', 'startDate': '2026-03-01', 'endDate': '2026-03-31', 'vehicleType': 'Motorcycle'},
    {'plate': '', 'period': 'Feb 2026', 'location': 'Jalan Sanyan', 'amount': 'RM 42.40', 'status': 'Expired', 'passNo': 'SP2602010001', 'startDate': '2026-02-01', 'endDate': '2026-02-28', 'vehicleType': 'Car'},
    {'plate': '', 'period': 'Feb 2026', 'location': 'Jalan Maju', 'amount': 'RM 42.40', 'status': 'Expired', 'passNo': 'SP2602010002', 'startDate': '2026-02-01', 'endDate': '2026-02-28', 'vehicleType': 'Car'},
    {'plate': '', 'period': 'Jan 2026', 'location': 'Jalan Chengal', 'amount': 'RM 42.40', 'status': 'Expired', 'passNo': 'SP2601010001', 'startDate': '2026-01-01', 'endDate': '2026-01-31', 'vehicleType': 'Car'},
    {'plate': '', 'period': 'Jan 2026', 'location': 'Dewan Suarah', 'amount': 'RM 42.40', 'status': 'Expired', 'passNo': 'SP2601010002', 'startDate': '2026-01-01', 'endDate': '2026-01-31', 'vehicleType': 'Motorcycle'},
  ];

  final List<Map<String, dynamic>> _offenceData = [
    {'plate': '', 'dateTime': '2026-04-02 14:29:33', 'location': 'Jalan Pedada', 'code': '10 (1) Without displaying coupon(s)', 'status': 'Unpaid', 'offenceNo': 'C2604021452864', 'fineAmount': 'RM 10.00'},
    {'plate': '', 'dateTime': '2026-04-01 10:15:22', 'location': 'Dewan Suarah', 'code': '04 - Parking outside marked space', 'status': 'Paid', 'offenceNo': 'C2604011015222', 'fineAmount': 'RM 10.00'},
    {'plate': '', 'dateTime': '2026-03-31 09:45:10', 'location': 'Jalan Maju', 'code': '08 - Parking in loading zone', 'status': 'Unpaid', 'offenceNo': 'C2603310945100', 'fineAmount': 'RM 10.00'},
    {'plate': '', 'dateTime': '2026-03-30 15:20:55', 'location': 'Jalan Sanyan', 'code': '10 (1) Without displaying coupon(s)', 'status': 'Paid', 'offenceNo': 'C2603301520550', 'fineAmount': 'RM 10.00'},
    {'plate': '', 'dateTime': '2026-03-29 08:30:40', 'location': 'KPJ Carpark', 'code': '04 - Parking outside marked space', 'status': 'Unpaid', 'offenceNo': 'C2603290830400', 'fineAmount': 'RM 10.00'},
    {'plate': '', 'dateTime': '2026-03-28 11:50:18', 'location': 'Jalan Pedada', 'code': '08 - Parking in loading zone', 'status': 'Paid', 'offenceNo': 'C2603281150180', 'fineAmount': 'RM 10.00'},
    {'plate': '', 'dateTime': '2026-03-27 14:05:33', 'location': 'Jalan Tunku Osman', 'code': '10 (1) Without displaying coupon(s)', 'status': 'Unpaid', 'offenceNo': 'C2603271405330', 'fineAmount': 'RM 10.00'},
    {'plate': '', 'dateTime': '2026-03-26 09:22:17', 'location': 'Jalan Chengal', 'code': '04 - Parking outside marked space', 'status': 'Paid', 'offenceNo': 'C2603260922170', 'fineAmount': 'RM 10.00'},
  ];

  final List<Map<String, dynamic>> _opnData = [
    {'plate': '', 'dateTime': '2026-03-09 11:04:42', 'location': 'Jalan Pedada', 'time': '10:48 AM', 'sessions': '1', 'status': 'Paid'},
    {'plate': '', 'dateTime': '2026-03-08 09:30:15', 'location': 'Dewan Suarah', 'time': '09:15 AM', 'sessions': '2', 'status': 'Unpaid'},
    {'plate': '', 'dateTime': '2026-03-07 14:20:30', 'location': 'Jalan Maju', 'time': '02:00 PM', 'sessions': '1', 'status': 'Paid'},
    {'plate': '', 'dateTime': '2026-03-06 08:45:10', 'location': 'KPJ Carpark', 'time': '08:30 AM', 'sessions': '1', 'status': 'Unpaid'},
    {'plate': '', 'dateTime': '2026-03-05 16:10:55', 'location': 'Jalan Sanyan', 'time': '04:00 PM', 'sessions': '3', 'status': 'Paid'},
    {'plate': '', 'dateTime': '2026-03-04 11:30:22', 'location': 'Jalan Chengal', 'time': '11:15 AM', 'sessions': '1', 'status': 'Unpaid'},
    {'plate': '', 'dateTime': '2026-03-03 10:05:40', 'location': 'Jalan Tunku Osman', 'time': '09:50 AM', 'sessions': '2', 'status': 'Paid'},
    {'plate': '', 'dateTime': '2026-03-02 13:40:18', 'location': 'Pusat Pedada', 'time': '01:25 PM', 'sessions': '1', 'status': 'Unpaid'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _currentPlate = widget.plateNumber;
    _searchController = TextEditingController(text: _currentPlate);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
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

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}';
  }

  void _performSearch() {
    final text = _searchController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a car plate number'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF4B5563),
        ),
      );
      return;
    }
    setState(() {
      _currentPlate = text.toUpperCase();
    });
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Car Plate Enquiry',
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar inside page
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: ElderlyTextField(
                      controller: _searchController,
                      textCapitalization: TextCapitalization.characters,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      onSubmitted: (_) => _performSearch(),
                      decoration: const InputDecoration(
                        hintText: 'Enter car plate no.',
                        hintStyle: TextStyle(
                          color: Color(0xFFBDBDBD),
                          fontStyle: FontStyle.italic,
                          fontSize: 13,
                        ),
                        prefixIcon: Icon(Icons.directions_car_outlined, color: Color(0xFF9CA3AF), size: 18),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 11),
                        isDense: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: _performSearch,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF5A623),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.search, color: Colors.white, size: 16),
                    label: const Text('Search', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),

          // Date range picker
          InkWell(
            onTap: () => _selectDateRange(context),
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(26, 10, 16, 10), // Adjusted left padding to align with car icon
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, color: Color(0xFF6B7280), size: 18),
                  const SizedBox(width: 14), // Increased spacing
                  Text(
                    _formatDate(_startDate),
                    style: const TextStyle(fontSize: 13, color: Color(0xFF4B5563), fontWeight: FontWeight.w500),
                  ),
                  if (_startDate != _endDate || _startDate.day != _endDate.day) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(Icons.arrow_forward, color: Color(0xFF9CA3AF), size: 14),
                    ),
                    Text(
                      _formatDate(_endDate),
                      style: const TextStyle(fontSize: 13, color: Color(0xFF4B5563), fontWeight: FontWeight.w500),
                    ),
                  ],
                  const Spacer(),
                  const Icon(Icons.arrow_drop_down, color: Color(0xFF6B7280), size: 22),
                ],
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),

          // Enquiry result title
          Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Text(
              'Enquiry result for: $_currentPlate',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
          ),

          // Tab bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              isScrollable: false, // Changed to false to fit all tabs at once
              labelColor: const Color(0xFFF5A623),
              unselectedLabelColor: const Color(0xFF6B7280),
              labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              indicatorColor: const Color(0xFFF5A623),
              indicatorWeight: 2.5,
              indicatorSize: TabBarIndicatorSize.label,
              dividerColor: const Color(0xFFE5E7EB),
              labelPadding: const EdgeInsets.symmetric(horizontal: 4), // Reduced horizontal padding
              padding: const EdgeInsets.symmetric(horizontal: 8),
              tabs: [
                _buildTabWithBadge('Parking', _parkingData.length),
                _buildTabWithBadge('Season Pass', _seasonPassData.length),
                _buildTabWithBadge('Offence', _offenceData.where((e) => e['status'] == 'Unpaid').length),
                _buildTabWithBadge('OPN', _opnData.where((e) => e['status'] == 'Unpaid').length),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildParkingTab(),
                _buildSeasonPassTab(),
                _buildOffenceTab(),
                _buildOpnTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Tab Badge ────────────────────────────────────────────────

  Widget _buildTabWithBadge(String label, int count) {
    return Tab(
      child: Badge(
        label: Text(
          '$count',
          style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
        ),
        isLabelVisible: count > 0,
        backgroundColor: const Color(0xFFEF4444),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        offset: const Offset(12, -4), // Adjusts badge position to overlay slightly
        child: Text(
          label,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }


  // ─── Parking Tab ──────────────────────────────────────────────

  Widget _buildParkingTab() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _parkingData.length,
      itemBuilder: (context, index) {
        final item = _parkingData[index];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CouponDetailScreen(
                  data: {
                    ...item,
                    'vehicleNo': _currentPlate,
                  },
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFF3F4F6)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${item['date']} ${item['dateRange']}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2937)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['location'],
                        style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item['sessions'],
                        style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    StatusChip(status: item['status']),
                    const SizedBox(height: 8),
                    Text(
                      item['amount'],
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2937)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─── Season Pass Tab ──────────────────────────────────────────

  Widget _buildSeasonPassTab() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _seasonPassData.length,
      itemBuilder: (context, index) {
        final item = _seasonPassData[index];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SeasonPassDetailScreen(
                  data: {
                    ...item,
                    'plate': _currentPlate,
                  },
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFF3F4F6)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentPlate,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${item['period']} · ${item['location']}',
                        style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    StatusChip(status: item['status']),
                    const SizedBox(height: 8),
                    Text(
                      item['amount'],
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1F2937)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─── Offence Tab ──────────────────────────────────────────────

  Widget _buildOffenceTab() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _offenceData.length,
      itemBuilder: (context, index) {
        final item = _offenceData[index];
        final String imageUrl = 'https://picsum.photos/seed/${_currentPlate}off$index/400/300';
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => OffenceDetailScreen(
                  data: {
                    'plateNo': _currentPlate,
                    'dateTime': item['dateTime'],
                    'parkingArea': item['location'],
                    'offenceNo': item['offenceNo'],
                    'offenceType': item['code'],
                    'fineAmount': item['fineAmount'],
                    'paymentStatus': item['status'],
                    'imageUrl': imageUrl,
                  },
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFF3F4F6)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Thumbnail
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FullScreenImageViewer(
                          imageUrl: imageUrl,
                          heroTag: 'enquiry_offence_$index',
                        ),
                      ),
                    );
                  },
                  child: Hero(
                    tag: 'enquiry_offence_$index',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'https://picsum.photos/seed/${_currentPlate}off$index/100/100',
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 56,
                          height: 56,
                          color: const Color(0xFFF3F4F6),
                          child: const Icon(Icons.directions_car, color: Color(0xFF9CA3AF), size: 24),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentPlate,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item['dateTime'],
                        style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item['location'],
                        style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item['code'],
                        style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                StatusChip(status: item['status']),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─── OPN Tab ──────────────────────────────────────────────────

  Widget _buildOpnTab() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _opnData.length,
      itemBuilder: (context, index) {
        final item = _opnData[index];
        final String imageUrl = 'https://picsum.photos/seed/${_currentPlate}opn$index/400/300';
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => OPNDetailScreen(
                  data: {
                    'vehicleNo': _currentPlate,
                    'parkingArea': item['location'],
                    'createdAt': item['dateTime'],
                    'overparkUntil': item['time'],
                    'sessionCount': item['sessions'],
                    'imageUrl': imageUrl,
                  },
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFF3F4F6)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Thumbnail
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FullScreenImageViewer(
                          imageUrl: imageUrl,
                          heroTag: 'enquiry_opn_$index',
                        ),
                      ),
                    );
                  },
                  child: Hero(
                    tag: 'enquiry_opn_$index',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'https://picsum.photos/seed/${_currentPlate}opn$index/100/100',
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 56,
                          height: 56,
                          color: const Color(0xFFF3F4F6),
                          child: const Icon(Icons.directions_car, color: Color(0xFF9CA3AF), size: 24),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            _currentPlate,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5A623),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item['sessions'],
                                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 3),
                                const Icon(Icons.receipt_long, color: Colors.white, size: 10),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item['dateTime'],
                        style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.timer_off_outlined, color: Color(0xFFF5A623), size: 13),
                          const SizedBox(width: 4),
                          Text(
                            item['time'],
                            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item['location'],
                              style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                StatusChip(status: item['status']),
              ],
            ),
          ),
        );
      },
    );
  }
}
