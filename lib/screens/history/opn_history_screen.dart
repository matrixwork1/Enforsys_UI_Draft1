import 'package:flutter/material.dart';
import '../offence/opn_detail_screen.dart';
import '../../widgets/full_screen_image_viewer.dart';

class OpnHistoryScreen extends StatefulWidget {
  const OpnHistoryScreen({super.key});

  @override
  State<OpnHistoryScreen> createState() => _OpnHistoryScreenState();
}

class _OpnHistoryScreenState extends State<OpnHistoryScreen> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 1));
  DateTime _endDate = DateTime.now();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, String>> _allOpns = [
    {'plate': 'BKA1190', 'time': '11:32 AM', 'desc': '04 - Parking outside marked space', 'loc': 'Jalan Tun Abang Haji Openg'},
    {'plate': 'JQK102', 'time': '09:20 AM', 'desc': '08 - Parking in loading zone', 'loc': 'Jalan Maju'},
    {'plate': 'VAD8818', 'time': '08:45 AM', 'desc': '10 (1) Without displaying coupon(s)', 'loc': 'Jalan Sanyan'},
    {'plate': 'WA9100P', 'time': '08:12 AM', 'desc': '04 - Parking outside marked space', 'loc': 'Jalan Tunku Osman'},
  ];

  List<Map<String, String>> get _filteredOpns {
    if (_searchQuery.isEmpty) return _allOpns;
    return _allOpns.where((item) {
      return item['plate']!.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
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
            colorScheme: const ColorScheme.light(primary: Colors.teal),
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
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredOpns;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'OPN History',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Date Range Bar
          InkWell(
            onTap: () => _selectDateRange(context),
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0), // More compact vertical
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.calendar_today_outlined, color: Color(0xFF6B7280), size: 18),
                  const SizedBox(width: 8.0),
                  Text(_formatDate(_startDate), style: const TextStyle(fontSize: 14, color: Color(0xFF4B5563))),
                  const SizedBox(width: 8.0),
                  const Icon(Icons.arrow_forward, color: Color(0xFF9CA3AF), size: 16),
                  const SizedBox(width: 8.0),
                  Text(_formatDate(_endDate), style: const TextStyle(fontSize: 14, color: Color(0xFF4B5563))),
                  const Spacer(),
                  const Icon(Icons.arrow_drop_down, color: Colors.black),
                ],
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),
          
          // Search Bar Area
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Compact padding
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40, // Reduced height
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) {
                        setState(() { _searchQuery = val; });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search by Vehicle Plate No.',
                        hintStyle: const TextStyle(
                          color: Color(0xFF9CA3AF), 
                          fontStyle: FontStyle.italic, 
                          fontSize: 13,
                        ),
                        prefixIcon: const Icon(Icons.directions_car_outlined, color: Color(0xFF9CA3AF), size: 18),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 11.0),
                        isDense: true,
                        // Clear icon if text exists
                        suffixIcon: _searchQuery.isNotEmpty 
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 16, color: Colors.grey),
                              onPressed: () {
                                _searchController.clear();
                                setState(() { _searchQuery = ''; });
                              },
                            )
                          : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                SizedBox(
                  height: 40, // Match search field height
                  child: ElevatedButton.icon(
                    onPressed: () {
                       FocusScope.of(context).unfocus();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF5A623),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.search, color: Colors.white, size: 16),
                    label: const Text('Search', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
          
          // List View
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final item = filteredList[index];
                return _buildOpnCard(
                  context: context,
                  plate: item['plate']!,
                  location: item['loc']!,
                  noticeDescription: item['desc']!,
                  time: item['time']!,
                  index: index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpnCard({
    required BuildContext context,
    required String plate,
    required String location,
    required String noticeDescription,
    required String time,
    required int index,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OPNDetailScreen(
              data: {
                'vehicleNo': plate,
                'parkingArea': location,
                'createdAt': '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')} $time',
                'overparkUntil': '',
                'sessionCount': '1',
                'imageUrl': 'https://picsum.photos/seed/${plate.replaceAll(' ', '')}/400/300',
                'desc': noticeDescription,
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vehicle Image Thumbnail
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FullScreenImageViewer(
                      imageUrl: 'https://picsum.photos/seed/${plate.replaceAll(' ', '')}/400/300',
                      heroTag: 'opn_thumbnail_$plate',
                    ),
                  ),
                );
              },
              child: Hero(
                tag: 'opn_thumbnail_$plate',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: Image.network(
                    'https://picsum.photos/seed/${plate.replaceAll(' ', '')}/100/100',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 50,
                      height: 50,
                      color: const Color(0xFFE5E7EB),
                      child: const Icon(Icons.directions_car, color: Color(0xFF9CA3AF), size: 24),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plate,
                    style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    '$location • ${_formatDate(DateTime.now())} $time',
                    style: const TextStyle(fontSize: 12.0, color: Color(0xFF6B7280)),
                  ),
                  const SizedBox(height: 2.0),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6.0),
                      Expanded(
                        child: Text(
                          noticeDescription,
                          style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500, color: Colors.black87),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8.0),
            const Icon(Icons.chevron_right, color: Colors.black26, size: 20),
          ],
        ),
      ),
    );
  }
}
