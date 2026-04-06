import 'package:flutter/material.dart';
import '../../widgets/full_screen_image_viewer.dart';

class OffenceDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const OffenceDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Extracting data or using fallbacks
    final String dateTime = data['dateTime'] ?? '2026/03/27, 10:49 AM';
    final String offenceNo = data['offenceNo'] ?? 'C2603271252864';
    final String offenceType = data['offenceType'] ?? '10 (1) Without displaying coupon(s)';
    final String fineAmount = data['fineAmount'] ?? 'RM 10.00';
    final String paymentStatus = data['paymentStatus'] ?? 'Pending Payment';
    final String attendant = data['attendant'] ?? 'MAS ANAK MANI';
    final String plateNo = data['plateNo'] ?? 'ABC09';
    final String vehicleType = data['vehicleType'] ?? 'Car';
    final String vehicleName = data['vehicleName'] ?? 'ATOS';
    final String parkingArea = data['parkingArea'] ?? 'Dewan Suarah';
    final String parkingSpaceNo = data['parkingSpaceNo'] ?? '9';
    final String lastUpdate = data['lastUpdate'] ?? '2026/03/27, 10:48 AM';
    final String imageUrl = data['imageUrl'] ?? 'https://picsum.photos/seed/${plateNo.replaceAll(' ', '')}/400/300';

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // Clean, minimalist background
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Offence Detail',
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF3F4F6)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailItem(
                    icon: Icons.calendar_month_outlined,
                    label: 'Offence DateTime',
                    value: dateTime,
                  ),
                  _buildDivider(),
                  _buildDetailItem(
                    icon: Icons.receipt_long_outlined,
                    label: 'Offence No.',
                    value: offenceNo,
                  ),
                  _buildDivider(),
                  _buildDetailItem(
                    icon: Icons.warning_amber_rounded,
                    label: 'Offence Type',
                    value: offenceType,
                  ),
                  _buildDivider(),
                  _buildDetailItem(
                    icon: Icons.attach_money_rounded,
                    label: 'Fine Amount',
                    value: fineAmount,
                  ),
                  _buildDivider(),
                  _buildDetailItem(
                    icon: Icons.pending_actions_outlined,
                    label: 'Payment Status',
                    value: paymentStatus,
                  ),
                  _buildDivider(),
                  _buildDetailItem(
                    icon: Icons.person_outline,
                    label: 'Attendant',
                    value: attendant,
                  ),
                  
                  // Section break line
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),
                  ),
                  
                  _buildDetailItem(
                    icon: Icons.tag,
                    label: 'Plate No.',
                    value: plateNo,
                  ),
                  _buildDivider(),
                  _buildDetailItem(
                    icon: Icons.directions_car_outlined,
                    label: 'Vehicle Type',
                    value: vehicleType,
                  ),
                  _buildDivider(),
                  _buildDetailItem(
                    icon: Icons.directions_car,
                    label: 'Vehicle Name',
                    value: vehicleName,
                  ),
                  _buildDivider(),
                  _buildDetailItem(
                    icon: Icons.location_on_outlined,
                    label: 'Parking Area',
                    value: parkingArea,
                  ),
                  _buildDivider(),
                  _buildDetailItem(
                    icon: Icons.local_parking_outlined,
                    label: 'Parking Space No.',
                    value: parkingSpaceNo,
                  ),
                  _buildDivider(),
                  _buildDetailItem(
                    icon: Icons.history,
                    label: 'Last Update',
                    value: lastUpdate,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Attachment Section
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF3F4F6)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
              padding: const EdgeInsets.all(16.0),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.image_outlined, color: Color(0xFFF5A623), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Attachment',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => FullScreenImageViewer(
                            imageUrl: imageUrl,
                            heroTag: 'offence_detail_$plateNo',
                          ),
                        ),
                      );
                    },
                    child: Hero(
                      tag: 'offence_detail_$plateNo',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrl,
                          width: 140,
                          height: 140,
                          fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 140,
                          height: 140,
                          color: const Color(0xFFE5E7EB),
                          child: const Icon(Icons.image_not_supported, color: Color(0xFF9CA3AF), size: 40),
                        ),
                      ),
                    ),
                  ),
                ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFF3F4F6))),
          ),
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Color(0xFF6B7280)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.print_disabled_outlined, color: Color(0xFF4B5563), size: 20),
                SizedBox(width: 8),
                Text(
                  'No Printer Connected',
                  style: TextStyle(
                    color: Color(0xFF4B5563),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem({required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFF5A623), size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6), indent: 54);
  }
}
