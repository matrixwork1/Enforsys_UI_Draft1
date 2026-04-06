import 'package:flutter/material.dart';
import '../../widgets/full_screen_image_viewer.dart';

class OPNDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const OPNDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Dummy Data Extraction
    final String createdAt = data['createdAt'] ?? '2026-03-31, 9:51 AM';
    final String vehicleNo = data['vehicleNo'] ?? 'JUD8898';
    final String parkingArea = data['parkingArea'] ?? 'Jalan Pedada';
    final String couponExpire = data['couponExpire'] ?? '2026-03-31, 8:00 AM';
    final String totalSession = data['totalSession'] ?? '1';
    final String totalAmount = data['totalAmount'] ?? 'RM 3.00';
    final String overparkUntil = data['overparkUntil'] ?? '9:00 AM';
    final String sessionAmount = data['sessionAmount'] ?? 'RM 3.00';
    final String imageUrl = data['imageUrl'] ?? 'https://picsum.photos/seed/${vehicleNo.replaceAll(' ', '')}/400/300';

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Over-Parking Notice',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Information Section
            _buildSectionHeader('Information', null),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF3F4F6)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                children: [
                  _buildRow('Created At', createdAt),
                  _buildDivider(),
                  _buildRow('Vehicle No.', vehicleNo),
                  _buildDivider(),
                  _buildRow('Parking Area', parkingArea),
                  _buildDivider(),
                  _buildRow('Coupon Expire', couponExpire),
                  _buildDivider(),
                  _buildRow('Total Session', totalSession),
                  _buildDivider(),
                  _buildRow('Total Amount', totalAmount),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // OPN Session Section
            _buildSectionHeader('OPN Session', totalSession),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF3F4F6)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                children: [
                  _buildRow('Overpark Until', overparkUntil),
                  _buildDivider(),
                  _buildRow('Amount', sessionAmount),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Attachments Section
            _buildSectionHeader('Attachments', null),
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
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FullScreenImageViewer(
                        imageUrl: imageUrl,
                        heroTag: 'opn_detail_$vehicleNo',
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: 'opn_detail_$vehicleNo',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 220,
                        width: double.infinity,
                        color: const Color(0xFFE5E7EB),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Action Section
            _buildSectionHeader('Action', null),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF3F4F6)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {}, // Action goes here
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.print_disabled_outlined, color: Color(0xFF9CA3AF), size: 36),
                      SizedBox(height: 8),
                      Text(
                        'PRINT',
                        style: TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String? badgeValue) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 12.0),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
            ),
          ),
          if (badgeValue != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xFFEF4444), // Red pill
                shape: BoxShape.circle,
              ),
              child: Text(
                badgeValue,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6), indent: 16, endIndent: 16);
  }
}
