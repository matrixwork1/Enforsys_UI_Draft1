import 'package:flutter/material.dart';
import '../../widgets/elderly_keyboard/elderly_text_field.dart';
import '../../widgets/custom_action_card.dart';
import '../history/offence_list_screen.dart';
import '../history/opn_history_screen.dart';
import '../history/validator_record_screen.dart';
import '../notifications/notification_screen.dart';
import '../settings/settings_screen.dart';
import '../printer/thermal_printer_screen.dart';
import '../offence/opn_detail_screen.dart';
import '../offence/offence_detail_screen.dart';
import '../enquiry/car_plate_enquiry_screen.dart';
import '../kpi/kpi_dashboard_screen.dart';
import '../staff_movement/staff_movement_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isShowingOffence = true;
  final TextEditingController _plateSearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildTopIconWithBadge(Icons.notifications_none, onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const NotificationScreen()),
                );
              }),
              const SizedBox(width: 16.0),
              _buildTopIconWithBadge(
                Icons.settings_outlined,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const SettingsScreen()),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          _buildHeader(),
          const SizedBox(height: 12.0),
          _buildSearchBar(),
          const SizedBox(height: 16.0),
          const Text(
            'Action',
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 8.0),
          _buildActionRow(context),
          const SizedBox(height: 8.0),
          _buildActionRowTwo(context),
          const SizedBox(height: 16.0),
          const Text(
            'Today\'s Record',
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 8.0),
          _buildRecordSection(),
          // Padding at bottom so records don't hide behind floating FAB completely
          if (MediaQuery.of(context).viewInsets.bottom == 0)
            const SizedBox(height: 80.0),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
             decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20.0),
             ),
             child: const Icon(Icons.person, color: Colors.grey, size: 24),
          ),
          const SizedBox(width: 12.0),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MAS ANAK MANI',
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(height: 2.0),
                Text(
                  'ATTENDANT',
                  style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic, color: Color(0xFF888888)),
                ),
              ],
            ),
          ),
          // My Printer Icon moved here with red dot
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ThermalPrinterScreen()),
              );
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.print_outlined, size: 24, color: Colors.black87),
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopIconWithBadge(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(icon, size: 28, color: Colors.black87),
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

   Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: ElderlyTextField(
              controller: _plateSearchController,
              textCapitalization: TextCapitalization.characters,
              textAlignVertical: TextAlignVertical.center,
              onSubmitted: (_) => _navigateToEnquiry(),
              decoration: const InputDecoration(
                hintText: 'Enquiry car plate no.',
                hintStyle: TextStyle(color: Color(0xFFBDBDBD), fontStyle: FontStyle.italic, fontSize: 13),
                prefixIcon: Icon(Icons.directions_car_outlined, color: Color(0xFFBDBDBD), size: 18),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12.0),
        SizedBox(
          height: 40,
          child: ElevatedButton.icon(
            onPressed: _navigateToEnquiry,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF888888),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 0,
            ),
            icon: const Icon(Icons.search, color: Colors.white, size: 18),
            label: const Text('Search', style: TextStyle(color: Colors.white, fontSize: 13)),
          ),
        ),
      ],
    );
  }

  void _navigateToEnquiry() {
    final text = _plateSearchController.text.trim();
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
    FocusScope.of(context).unfocus();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CarPlateEnquiryScreen(plateNumber: text.toUpperCase()),
      ),
    );
  }

  Widget _buildActionRow(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: CustomActionCard(
              icon: const Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.hourglass_empty, size: 36, color: Colors.black),
                  Positioned(
                    bottom: 0,
                    right: -4,
                    child: Icon(Icons.document_scanner_outlined, size: 20, color: Color(0xFFF5A623)),
                  ),
                ],
              ),
              title: 'Validator\nRecord',
              subtitle: 'Check history',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ValidatorRecordScreen()),
                );
              },
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: CustomActionCard(
              icon: const Icon(Icons.history, size: 36, color: Colors.black),
              title: 'OPN\nHistory',
              subtitle: 'Past OPNs',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const OpnHistoryScreen()),
                );
              },
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: CustomActionCard(
              icon: const Icon(Icons.search_off_rounded, size: 36, color: Colors.black),
              title: 'Offence\nHistory',
              subtitle: 'Past offences',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const OffenceListScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionRowTwo(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: CustomActionCard(
              icon: const Icon(Icons.bar_chart_rounded, size: 36, color: Colors.black),
              title: 'KPI\nDashboard',
              subtitle: 'View metrics',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const KpiDashboardScreen()),
                );
              },
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: CustomActionCard(
              icon: const Icon(Icons.person_pin_circle_outlined, size: 36, color: Colors.black),
              title: 'Staff\nMovement',
              subtitle: 'Track activity',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const StaffMovementScreen()),
                );
              },
            ),
          ),
          const SizedBox(width: 8.0),
          // Empty spacer to keep 3-column grid alignment
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  Widget _buildRecordSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isShowingOffence = false;
                    });
                  },
                  child: Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'OPN',
                              style: TextStyle(
                                fontSize: 15.0, 
                                fontWeight: !_isShowingOffence ? FontWeight.bold : FontWeight.normal, 
                                color: !_isShowingOffence ? Colors.black : Colors.black87
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (!_isShowingOffence)
                              Container(width: 36, height: 2, color: Colors.black),
                          ],
                        ),
                        if (!_isShowingOffence)
                          Positioned(
                            right: -12,
                            top: -4,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color(0xFFF05252),
                                shape: BoxShape.circle,
                              ),
                              child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isShowingOffence = true;
                    });
                  },
                  child: Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Offence',
                              style: TextStyle(
                                fontSize: 15.0, 
                                fontWeight: _isShowingOffence ? FontWeight.bold : FontWeight.normal, 
                                color: _isShowingOffence ? Colors.black : Colors.black87
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (_isShowingOffence)
                              Container(width: 36, height: 2, color: Colors.black),
                          ],
                        ),
                        if (_isShowingOffence)
                          Positioned(
                            right: -12,
                            top: -4,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color(0xFFF05252),
                                shape: BoxShape.circle,
                              ),
                              child: const Text('6', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.refresh, color: Colors.black, size: 22),
                ),
              )
            ],
          ),
          const SizedBox(height: 12.0),
          _isShowingOffence ? _buildOffenceList() : _buildOpnList(),
        ],
      ),
    );
  }

  Widget _buildOffenceList() {
    final List<Map<String, dynamic>> offences = [
      {'plateNo': 'ABC09', 'parkingArea': 'Dewan Suarah', 'dateTime': '2026/03/27, 10:48 AM', 'imageUrl': 'https://loremflickr.com/100/100/car?lock=1'},
      {'plateNo': 'QWE1234', 'parkingArea': 'Jalan Sanyan', 'dateTime': '2026/03/27, 11:20 AM', 'imageUrl': 'https://loremflickr.com/100/100/car?lock=2'},
      {'plateNo': 'XYZ987', 'parkingArea': 'Jalan Maju', 'dateTime': '2026/03/27, 12:45 PM', 'imageUrl': 'https://loremflickr.com/100/100/car?lock=3'},
    ];
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: offences.length,
      itemBuilder: (context, index) {
        final data = offences[index];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => OffenceDetailScreen(data: data)),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
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
                  // Image
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        data['imageUrl'],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 80,
                          height: 80,
                          color: const Color(0xFFF3F4F6),
                          child: const Icon(Icons.directions_car, color: Color(0xFF9CA3AF), size: 32),
                        ),
                      ),
                    ),
                  ),
                  
                  // Info
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            data['plateNo'],
                            style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${data['parkingArea']} • ${data['dateTime'].replaceAll(',', '')}',
                            style: const TextStyle(fontSize: 12.0, color: Color(0xFF6B7280)),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF5A623),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Expanded(
                                child: Text(
                                  'Pending Payment',
                                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500, color: Colors.black87),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Print Block
                  Container(
                    width: 80,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.print_disabled_outlined, color: Color(0xFF9CA3AF), size: 28),
                        SizedBox(height: 6),
                        Text(
                          'PRINT',
                          style: TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOpnList() {
    final List<Map<String, dynamic>> opns = [
      {'vehicleNo': 'JUD8898', 'parkingArea': 'Jalan Pedada', 'createdAt': '2026-03-31 09:50:25', 'overparkUntil': '9:00 AM', 'sessionCount': '1', 'imageUrl': 'https://loremflickr.com/100/100/car?lock=10'},
      {'vehicleNo': 'BBM445', 'parkingArea': 'Jalan Maju', 'createdAt': '2026-03-31 10:15:20', 'overparkUntil': '10:00 AM', 'sessionCount': '2', 'imageUrl': 'https://loremflickr.com/100/100/car?lock=11'},
      {'vehicleNo': 'WXX111', 'parkingArea': 'Dewan Suarah', 'createdAt': '2026-03-31 11:30:10', 'overparkUntil': '11:00 AM', 'sessionCount': '1', 'imageUrl': 'https://loremflickr.com/100/100/car?lock=12'},
    ];
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: opns.length,
      itemBuilder: (context, index) {
        final data = opns[index];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => OPNDetailScreen(data: data)),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
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
                  // Image
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        data['imageUrl'],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 80,
                          height: 80,
                          color: const Color(0xFFF3F4F6),
                          child: const Icon(Icons.directions_car, color: Color(0xFF9CA3AF), size: 32),
                        ),
                      ),
                    ),
                  ),
                  
                  // Info
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                data['vehicleNo'],
                                style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black),
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
                                      data['sessionCount'] ?? '1',
                                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.receipt_long, color: Colors.white, size: 10),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${data['parkingArea']} • ${data['createdAt']}',
                            style: const TextStyle(fontSize: 12.0, color: Color(0xFF6B7280)),
                          ),
                          const SizedBox(height: 4),
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
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Valid until ${data['overparkUntil']}',
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
                  ),
                  
                  // Print Block
                  Container(
                    width: 70,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.print_disabled_outlined, color: Color(0xFF9CA3AF), size: 28),
                        SizedBox(height: 6),
                        Text(
                          'PRINT',
                          style: TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
