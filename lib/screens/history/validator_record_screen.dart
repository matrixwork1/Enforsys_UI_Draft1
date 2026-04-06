import 'package:flutter/material.dart';
import '../offence/new_offence_screen.dart';

class ValidatorRecordScreen extends StatefulWidget {
  const ValidatorRecordScreen({super.key});

  @override
  State<ValidatorRecordScreen> createState() => _ValidatorRecordScreenState();
}

class _ValidatorRecordScreenState extends State<ValidatorRecordScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, String>> _allRecords = [
    {
      'plate': 'QAX3967',
      'distance': '62 m',
      'permitStatus': 'No Parking Permit Found',
      'hasPermit': 'false',
      'loc': 'Jalan Pedada',
      'time': '2026-03-30, 10:51 AM'
    },
    {
      'plate': 'QAX3967',
      'distance': '106 m',
      'permitStatus': 'No Parking Permit Found',
      'hasPermit': 'false',
      'loc': 'Jalan Pedada',
      'time': '2026-03-30, 10:48 AM'
    },
    {
      'plate': 'QM1Q',
      'distance': '20 m',
      'permitStatus': 'No Parking Permit Found',
      'hasPermit': 'false',
      'loc': 'Jalan Pedada',
      'time': '2026-03-30, 10:46 AM'
    },
    {
      'plate': 'QM1O',
      'distance': '20 m',
      'permitStatus': 'No Parking Permit Found',
      'hasPermit': 'false',
      'loc': 'Jalan Pedada',
      'time': '2026-03-30, 10:45 AM'
    },
    {
      'plate': 'VJK1992',
      'distance': '106 m',
      'permitStatus': 'No Parking Permit Found',
      'hasPermit': 'false',
      'loc': 'Jalan Pedada',
      'time': '2026-03-30, 10:40 AM'
    },
  ];

  List<Map<String, String>> get _filteredRecords {
    if (_searchQuery.isEmpty) return _allRecords;
    return _allRecords.where((item) {
      return item['plate']!.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredRecords;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Validator Record',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          // Elegant Search Bar Area
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Enter Plate Number to Search',
                  hintStyle: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontStyle: FontStyle.italic,
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(Icons.directions_car, color: Colors.black87, size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
                  isDense: true,
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 8.0),

          // List View
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final item = filteredList[index];
                final isNoPermit = item['hasPermit'] == 'false';
                
                return _buildValidatorRecordCard(
                  plate: item['plate']!,
                  distance: item['distance']!,
                  permitStatus: item['permitStatus']!,
                  isNoPermit: isNoPermit,
                  location: item['loc']!,
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

  Widget _buildValidatorRecordCard({
    required String plate,
    required String distance,
    required String permitStatus,
    required bool isNoPermit,
    required String location,
    required String time,
    required int index,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left content side
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Network Thumbnail Image
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            'https://loremflickr.com/100/100/car?lock=${plate.hashCode + index}',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 80,
                              height: 80,
                              color: const Color(0xFFE5E7EB),
                              child: const Icon(Icons.directions_car, color: Color(0xFF9CA3AF), size: 36),
                            ),
                          ),
                        ),
                        // Expand Icon Overlay
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.open_in_full, size: 12, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12.0),
                    // Information Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plate,
                            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                          const SizedBox(height: 6.0),
                          _buildInfoRow(Icons.directions_walk, distance, color: Colors.black87),
                          const SizedBox(height: 4.0),
                          _buildInfoRow(
                            isNoPermit ? Icons.cancel : Icons.check_circle, 
                            permitStatus, 
                            color: isNoPermit ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                            isBoldIcon: true,
                          ),
                          const SizedBox(height: 4.0),
                          _buildInfoRow(Icons.location_on, location, color: Colors.black87),
                          const SizedBox(height: 4.0),
                          _buildInfoRow(Icons.access_time, time, color: Colors.black87),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Vertical Divider
            const VerticalDivider(width: 1, thickness: 1, color: Color(0xFFE5E7EB)),
            
            // Right Action Buttons Side
            SizedBox(
              width: 60,
              child: Column(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const NewOffenceScreen()),
                        );
                      },
                      borderRadius: const BorderRadius.only(topRight: Radius.circular(12)),
                      child: const Center(
                        child: Icon(Icons.edit_document, color: Colors.black87, size: 26),
                      ),
                    ),
                  ),
                  const Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      borderRadius: const BorderRadius.only(bottomRight: Radius.circular(12)),
                      child: const Center(
                        child: Icon(Icons.map_outlined, color: Color(0xFFF5A623), size: 26),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {required Color color, bool isBoldIcon = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6.0),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12.0, 
              color: isBoldIcon ? Colors.black : Colors.black87,
              fontWeight: isBoldIcon ? FontWeight.w600 : FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
