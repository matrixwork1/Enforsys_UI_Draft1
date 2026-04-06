import 'package:flutter/material.dart';

class KpiPeriodSelector extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final VoidCallback onCustomDateTap;
  final String dateRangeLabel;

  const KpiPeriodSelector({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
    required this.onCustomDateTap,
    required this.dateRangeLabel,
  });

  static const _labels = ['Today', 'Week', 'Month', 'Year'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Period chips row
        Row(
          children: [
            for (int i = 0; i < _labels.length; i++) ...[
              if (i > 0) const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () => onSelected(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: selectedIndex == i
                          ? const Color(0xFF1F2937)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: selectedIndex == i
                            ? const Color(0xFF1F2937)
                            : const Color(0xFFE5E7EB),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _labels[i],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: selectedIndex == i
                              ? Colors.white
                              : const Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 10),
        // Date range row
        InkWell(
          onTap: onCustomDateTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined, color: Color(0xFF6B7280), size: 18),
                const SizedBox(width: 10),
                Text(
                  dateRangeLabel,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF4B5563),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.arrow_drop_down, color: Color(0xFF6B7280), size: 22),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
