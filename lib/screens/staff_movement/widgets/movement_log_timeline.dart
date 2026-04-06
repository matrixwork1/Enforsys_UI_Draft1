import 'package:flutter/material.dart';

class MovementLogTimeline extends StatelessWidget {
  final List<MovementLogEntry> entries;

  const MovementLogTimeline({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.timeline, size: 18, color: Color(0xFF6B7280)),
              SizedBox(width: 8),
              Text(
                'Movement Log',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Recorded every 30 minutes',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(entries.length, (index) {
            final entry = entries[index];
            final isLast = index == entries.length - 1;

            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timeline column
                  SizedBox(
                    width: 24,
                    child: Column(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: entry.isIdle
                                ? const Color(0xFFEF4444)
                                : index == 0
                                    ? const Color(0xFFF5A623)
                                    : const Color(0xFF1F2937),
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                        if (!isLast)
                          Expanded(
                            child: Container(
                              width: 1.5,
                              color: const Color(0xFFE5E7EB),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Content
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Time
                          Text(
                            entry.timeRange,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Location info
                          if (entry.isIdle) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF2F2),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: const Color(0xFFFECACA)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.warning_amber_rounded, size: 14, color: Color(0xFFEF4444)),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'Idle at ${entry.from} (${entry.idleDuration})',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFFDC2626),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ] else ...[
                            Row(
                              children: [
                                const Icon(Icons.trip_origin, size: 14, color: Color(0xFF10B981)),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    entry.from,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF4B5563),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (entry.to != null) ...[
                              Padding(
                                padding: const EdgeInsets.only(left: 6, top: 2, bottom: 2),
                                child: Container(
                                  width: 1,
                                  height: 10,
                                  color: const Color(0xFFE5E7EB),
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 14, color: Color(0xFFF5A623)),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      entry.to!,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF4B5563),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                          if (entry.coords != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              entry.coords!,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFFB0B7C3),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class MovementLogEntry {
  final String timeRange;
  final String from;
  final String? to;
  final String? coords;
  final bool isIdle;
  final String? idleDuration;

  const MovementLogEntry({
    required this.timeRange,
    required this.from,
    this.to,
    this.coords,
    this.isIdle = false,
    this.idleDuration,
  });
}
