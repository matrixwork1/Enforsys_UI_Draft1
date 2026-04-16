import 'package:flutter/material.dart';
import '../models/models.dart';
import '../screens/offence/new_offence_screen.dart';
import 'create_opn_popup.dart';


/// Shows the "Recognized Car Plates" bottom sheet after camera capture.
void showRecognizedPlatesPopup(
  BuildContext context, {
  required String capturedImageUrl,
  required List<RecognizedPlateEntry> plates,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _RecognizedPlatesSheet(
      capturedImageUrl: capturedImageUrl,
      plates: plates,
    ),
  );
}

class _RecognizedPlatesSheet extends StatelessWidget {
  final String capturedImageUrl;
  final List<RecognizedPlateEntry> plates;

  const _RecognizedPlatesSheet({
    required this.capturedImageUrl,
    required this.plates,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
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

            // Captured image preview
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  capturedImageUrl,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image_outlined, color: Color(0xFF9CA3AF), size: 40),
                        SizedBox(height: 8),
                        Text(
                          'Captured Image',
                          style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Recognized Car Plates',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Plates list
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: plates.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                  color: Color(0xFFF3F4F6),
                ),
                itemBuilder: (context, index) {
                  final entry = plates[index];
                  return _buildPlateEntry(context, entry);
                },
              ),
            ),

            const SizedBox(height: 16),

            // Close button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
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
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPlateEntry(BuildContext context, RecognizedPlateEntry entry) {
    final config = _getEntryStatusConfig(entry.status);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Plate number
          Text(
            entry.plate,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 4),
          // Status row
          Row(
            children: [
              Icon(config.icon, size: 15, color: config.iconColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  config.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: config.color,
                  ),
                ),
              ),
            ],
          ),
          // Action button for violation statuses
          if (entry.status == ValidatorStatus.noPermitFound) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 42,
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
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.report_outlined, size: 18),
                label: const Text(
                  'Create Offence',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
          if (entry.status == ValidatorStatus.opnFound) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 42,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  showCreateOpnPopup(context, plateNumber: entry.plate);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.add_alert_outlined, size: 18),
                label: const Text(
                  'Create Over-Parking Notice',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Status config helper for recognized plates
class _EntryStatusConfig {
  final String label;
  final Color color;
  final IconData icon;
  final Color iconColor;

  const _EntryStatusConfig({
    required this.label,
    required this.color,
    required this.icon,
    required this.iconColor,
  });
}

_EntryStatusConfig _getEntryStatusConfig(ValidatorStatus status) {
  switch (status) {
    case ValidatorStatus.activeUserCoupon:
      return const _EntryStatusConfig(
        label: 'Active User Coupon',
        color: Color(0xFF10B981),
        icon: Icons.check_circle,
        iconColor: Color(0xFF10B981),
      );
    case ValidatorStatus.activeSeasonPass:
      return const _EntryStatusConfig(
        label: 'Active Season Pass',
        color: Color(0xFF10B981),
        icon: Icons.check_circle,
        iconColor: Color(0xFF10B981),
      );
    case ValidatorStatus.noPermitFound:
      return const _EntryStatusConfig(
        label: 'No Parking Permit Found',
        color: Color(0xFFEF4444),
        icon: Icons.cancel,
        iconColor: Color(0xFFEF4444),
      );
    case ValidatorStatus.compoundIssued:
      return const _EntryStatusConfig(
        label: 'Compound Issued',
        color: Color(0xFFF59E0B),
        icon: Icons.warning_rounded,
        iconColor: Color(0xFFF59E0B),
      );
    case ValidatorStatus.opnFound:
      return const _EntryStatusConfig(
        label: 'OPN Found',
        color: Color(0xFFEF4444),
        icon: Icons.notifications_active,
        iconColor: Color(0xFFEF4444),
      );
  }
}
