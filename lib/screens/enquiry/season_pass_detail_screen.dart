import 'package:flutter/material.dart';

class SeasonPassDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const SeasonPassDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final String plate = data['plate'] ?? 'AAA123';
    final String passNo = data['passNo'] ?? 'SP2604010001';
    final String location = data['location'] ?? 'Pusat Pedada';
    final String period = data['period'] ?? 'Apr 2026';
    final String amount = data['amount'] ?? 'RM 42.40';
    final String status = data['status'] ?? 'Active';
    final String startDate = data['startDate'] ?? '2026-04-01';
    final String endDate = data['endDate'] ?? '2026-04-30';
    final String vehicleType = data['vehicleType'] ?? 'Car';

    final bool isActive = status == 'Active';

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Season Pass Detail',
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
        actions: [
          IconButton(
            icon: const Icon(Icons.download_outlined, color: Colors.black87, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isActive ? const Color(0xFF10B981).withValues(alpha: 0.3) : const Color(0xFFEF4444).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isActive ? Icons.check_circle : Icons.cancel,
                    color: isActive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isActive ? 'Active Season Pass' : 'Expired Season Pass',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isActive ? const Color(0xFF059669) : const Color(0xFFDC2626),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Main info card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFF3F4F6)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: const Icon(Icons.account_balance, color: Color(0xFFF5A623), size: 20),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SIBU MUNICIPAL COUNCIL',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                              SizedBox(height: 1),
                              Text(
                                'SEASON PARKING PASS',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF6B7280),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFF3F4F6)),

                  _buildDetailRow('Pass No.', passNo),
                  _buildDivider(),
                  _buildDetailRow('Vehicle No.', plate),
                  _buildDivider(),
                  _buildDetailRow('Vehicle Type', vehicleType),
                  _buildDivider(),
                  _buildDetailRow('Parking Area', location),
                  _buildDivider(),
                  _buildDetailRow('Period', period),
                  _buildDivider(),
                  _buildDetailRow('Start Date', startDate),
                  _buildDivider(),
                  _buildDetailRow('End Date', endDate),

                  // Separator
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),
                  ),

                  _buildDetailRow('Total Amount', amount, isLabel: true),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Pass validity info
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 10),
              child: Text(
                'Pass Validity',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFF3F4F6)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildDetailRow('Valid From', startDate, isLabel: true),
                  _buildDivider(),
                  _buildDetailRow('Valid Until', endDate, isLabel: true),
                  _buildDivider(),
                  _buildDetailRow('Status', status, isLabel: true),
                  _buildDivider(),
                  _buildDetailRow('Amount Paid', amount, isLabel: true),
                  const SizedBox(height: 4),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isLabel = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isLabel ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1F2937),
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 1, color: Color(0xFFF9FAFB), indent: 16, endIndent: 16);
  }
}
