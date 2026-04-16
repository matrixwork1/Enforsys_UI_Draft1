import 'package:flutter/material.dart';
import '../models/models.dart';
import '../screens/enquiry/car_plate_enquiry_screen.dart';
import '../screens/offence/new_offence_screen.dart';
import 'full_screen_image_viewer.dart';
import 'create_opn_popup.dart';


/// Shows the "Singular Validator Result" bottom sheet popup.
void showValidatorResultPopup(BuildContext context, ValidatorResultData data) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _ValidatorResultSheet(data: data),
  );
}

class _ValidatorResultSheet extends StatelessWidget {
  final ValidatorResultData data;

  const _ValidatorResultSheet({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD1D5DB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            // Title
            const Text(
              'Singular Validator Result',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 4),
            const Divider(color: Color(0xFFF3F4F6), thickness: 1),

            // Car info card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // Thumbnail
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => FullScreenImageViewer(
                              imageUrl: data.imageUrl,
                              heroTag: 'validator_popup_${data.plate}',
                            ),
                          ),
                        );
                      },
                      child: Hero(
                        tag: 'validator_popup_${data.plate}',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            data.imageUrl,
                            width: 72,
                            height: 72,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.directions_car, color: Color(0xFF9CA3AF), size: 28),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.plate,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF111827),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 13, color: Color(0xFF9CA3AF)),
                              const SizedBox(width: 4),
                              Text(
                                'Parking Area',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            data.parkingArea,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF374151),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 13, color: Color(0xFF9CA3AF)),
                              const SizedBox(width: 4),
                              Text(
                                'Checked At',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            data.checkedAt,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF374151),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Status area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: _buildStatusSection(data.status),
            ),

            const SizedBox(height: 12),

            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildActionButtons(context, data),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSection(ValidatorStatus status) {
    final statusConfig = _getStatusConfig(status);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Text(
            statusConfig.label,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: statusConfig.color,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: statusConfig.bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              statusConfig.icon,
              color: statusConfig.iconColor,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, ValidatorResultData data) {
    final status = data.status;
    return Column(
      children: [
        // Enquiry button — always shown
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop(); // Close bottom sheet
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CarPlateEnquiryScreen(plateNumber: data.plate),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF5A623),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.info_outline, size: 20),
            label: const Text(
              'Enquiry',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ),

        // Create Offence button — for No Parking Permit Found
        if (status == ValidatorStatus.noPermitFound) ...[
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const NewOffenceScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.report_outlined, size: 20),
              label: const Text(
                'Create Offence',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],

        // Create OPN button — for OPN Found
        if (status == ValidatorStatus.opnFound) ...[
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                showCreateOpnPopup(context, plateNumber: data.plate);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.add_alert_outlined, size: 20),
              label: const Text(
                'Create OPN',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],

        // Close button — always shown
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF6B7280),
              side: const BorderSide(color: Color(0xFFD1D5DB)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.close, size: 18),
            label: const Text(
              'Close',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }
}

/// Config helper for status display
class _StatusConfig {
  final String label;
  final Color color;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  const _StatusConfig({
    required this.label,
    required this.color,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });
}

_StatusConfig _getStatusConfig(ValidatorStatus status) {
  switch (status) {
    case ValidatorStatus.activeUserCoupon:
      return const _StatusConfig(
        label: 'Active User Coupon',
        color: Color(0xFF10B981),
        icon: Icons.check_circle,
        iconColor: Colors.white,
        bgColor: Color(0xFF10B981),
      );
    case ValidatorStatus.activeSeasonPass:
      return const _StatusConfig(
        label: 'Active Season Pass',
        color: Color(0xFF10B981),
        icon: Icons.check_circle,
        iconColor: Colors.white,
        bgColor: Color(0xFF10B981),
      );
    case ValidatorStatus.noPermitFound:
      return const _StatusConfig(
        label: 'No Parking Permit Found',
        color: Color(0xFFEF4444),
        icon: Icons.cancel,
        iconColor: Colors.white,
        bgColor: Color(0xFFEF4444),
      );
    case ValidatorStatus.compoundIssued:
      return _StatusConfig(
        label: 'Compound Issued',
        color: const Color(0xFFF59E0B),
        icon: Icons.warning_rounded,
        iconColor: Colors.amber[900]!,
        bgColor: const Color(0xFFFEF3C7),
      );
    case ValidatorStatus.opnFound:
      return const _StatusConfig(
        label: 'OPN Found',
        color: Color(0xFFEF4444),
        icon: Icons.notifications_active,
        iconColor: Colors.white,
        bgColor: Color(0xFFEF4444),
      );
  }
}
