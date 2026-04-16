import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Reusable status chip for Active/Expired/Paid/Unpaid states.
/// Extracted from car_plate_enquiry_screen.dart where it was duplicated
/// as _buildStatusChip, and similar patterns in other list screens.
class StatusChip extends StatelessWidget {
  final String status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final bool isPositive = status == 'Active' || status == 'Paid';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isPositive ? AppColors.successBg : AppColors.errorBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPositive ? AppColors.success : AppColors.error,
          width: 0.5,
        ),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isPositive ? AppColors.successDark : AppColors.errorDark,
        ),
      ),
    );
  }
}
