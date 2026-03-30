import 'package:flutter/material.dart';
import '../../widgets/custom_action_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
              _buildTopIconWithBadge(Icons.notifications_none),
              const SizedBox(width: 16.0),
              _buildTopIconWithBadge(Icons.settings_outlined),
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
          _buildActionRow(),
          const SizedBox(height: 16.0),
          const Text(
            'Today\'s Record',
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 8.0),
          _buildRecordSection(),
          // Padding at bottom so records don't hide behind floating FAB completely
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
          Stack(
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
        ],
      ),
    );
  }

  Widget _buildTopIconWithBadge(IconData icon) {
    return Stack(
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
            child: const TextField(
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
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
            onPressed: () {},
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

  Widget _buildActionRow() {
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
            ),
          ),
          const SizedBox(width: 8.0),
          const Expanded(
            child: CustomActionCard(
              icon: Icon(Icons.history, size: 36, color: Colors.black),
              title: 'OPN\nHistory',
              subtitle: 'Past OPNs',
            ),
          ),
          const SizedBox(width: 8.0),
          const Expanded(
            child: CustomActionCard(
              icon: Icon(Icons.search_off_rounded, size: 36, color: Colors.black),
              title: 'Offence\nHistory',
              subtitle: 'Past offences',
            ),
          ),
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
              const Expanded(
                child: Center(
                  child: Text(
                    'OPN',
                    style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal, color: Colors.black87),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Offence',
                            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                          const SizedBox(height: 4),
                          Container(width: 36, height: 2, color: Colors.black),
                        ],
                      ),
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
              const Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.refresh, color: Colors.black, size: 22),
                ),
              )
            ],
          ),
          const SizedBox(height: 12.0),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6,
            itemBuilder: (context, index) {
              final plates = ['ABC09', 'QWE1234', 'XYZ987', 'BBM445', 'KLT880', 'WXX111'];
              final times = [
                '2026-03-27 10:48',
                '2026-03-27 11:20',
                '2026-03-27 12:45',
                '2026-03-27 13:10',
                '2026-03-27 14:05',
                '2026-03-27 15:00'
              ];
              
              return Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFEEEEEE)),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                             Text(plates[index], style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600)),
                             const SizedBox(height: 4),
                             Text('Dewan Suarah, ${times[index]}', style: const TextStyle(fontSize: 11.0, color: Color(0xFF666666))),
                        ],
                      ),
                    ),
                    const Align(
                       alignment: Alignment.centerRight,
                       child: Padding(
                         padding: EdgeInsets.only(top: 8.0),
                         child: Icon(Icons.print_disabled_outlined, color: Colors.grey, size: 22),
                       ),
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
