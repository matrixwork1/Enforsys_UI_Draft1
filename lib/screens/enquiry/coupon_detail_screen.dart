import 'package:flutter/material.dart';

class CouponDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const CouponDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final String vehicleNo = data['vehicleNo'] ?? 'AAA123';
    final String couponNo = data['couponNo'] ?? 'UC2604062252898';
    final String location = data['location'] ?? 'Jalan Chengal';
    final String dateRange = data['dateRange'] ?? '9:12 AM - 9:42 AM';
    final String duration = data['duration'] ?? '30 minutes';
    final String amount = data['amount'] ?? 'RM 0.42';
    final String status = data['status'] ?? 'Active';
    final String paymentMethod = data['paymentMethod'] ?? 'eWallet Credits';
    final String purchaseAt = data['purchaseAt'] ?? '2026-04-06 9:11 AM';
    final String refNo = data['refNo'] ?? '9a57495db4';

    final bool isActive = status == 'Active';

    // Parse time range
    final parts = dateRange.split(' - ');
    final String startTime = parts.isNotEmpty ? parts[0].trim() : '';
    final String endTime = parts.length > 1 ? parts[1].trim() : '';

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Coupon Detail',
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
            // Main coupon card
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
                  // Header — Council name
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: Row(
                      children: [
                        // Council logo placeholder
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
                                'E-PARKING COUPON',
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

                  // Detail rows
                  _buildDetailRow(
                    'Status',
                    '',
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isActive ? Icons.check_circle : Icons.cancel,
                          color: isActive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isActive ? 'Parking' : 'End',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isActive ? const Color(0xFF059669) : const Color(0xFF1F2937),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildDivider(),
                  _buildDetailRow('Coupon No.', couponNo),
                  _buildDivider(),
                  _buildDetailRow('Vehicle No.', vehicleNo),
                  _buildDivider(),
                  _buildDetailRow('Parking Area', location),
                  _buildDivider(),
                  _buildDetailRow('Parking Range', '$startTime  -  $endTime'),
                  _buildDivider(),
                  _buildDetailRow('Overall Duration', duration),
                  _buildDivider(),
                  _buildDetailRow('Extend', '-'),

                  // Separator
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),
                  ),

                  // Payment section
                  _buildDetailRow('Payment Method', paymentMethod, isLabel: true),
                  _buildDivider(),
                  _buildDetailRow('Purchase at', purchaseAt, isLabel: true),
                  _buildDivider(),
                  _buildDetailRow('Reference No.', refNo, isLabel: true),
                  _buildDivider(),
                  _buildDetailRow('Total Amount', amount, isLabel: true),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Started Coupon section
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 10),
              child: Text(
                'Started Coupon',
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
                  _buildDetailRow('Start Time', startTime, isLabel: true),
                  _buildDivider(),
                  _buildDetailRow('End Time', endTime, isLabel: true),
                  _buildDivider(),
                  _buildDetailRow('Duration', duration, isLabel: true),
                  _buildDivider(),
                  _buildDetailRow('Price', amount, isLabel: true),
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

  Widget _buildDetailRow(String label, String value, {bool isLabel = false, Widget? trailing}) {
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
          if (trailing != null)
            trailing
          else
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
