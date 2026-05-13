import 'package:flutter/material.dart';
import '../enforcement_heatmap_data.dart';

/// AI Patrol Advisor card — displays patrol recommendations
/// with priority badges, confidence scores, and suggested times.
class PatrolAdvisorCard extends StatefulWidget {
  final List<PatrolRecommendation> recommendations;

  const PatrolAdvisorCard({super.key, required this.recommendations});

  @override
  State<PatrolAdvisorCard> createState() => _PatrolAdvisorCardState();
}

class _PatrolAdvisorCardState extends State<PatrolAdvisorCard> {
  bool _isHowItWorksExpanded = false;

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
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.auto_awesome, size: 16, color: Colors.white),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Patrol Advisor',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                      'Recommendations based on patrol data analysis',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'BETA',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF8B5CF6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Recommendation cards
          ...widget.recommendations.map((rec) => _buildRecommendation(rec)),

          // "How it works" expandable
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => setState(() => _isHowItWorksExpanded = !_isHowItWorksExpanded),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFF3F4F6)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.help_outline, size: 14, color: Color(0xFF9CA3AF)),
                      const SizedBox(width: 8),
                      const Text(
                        'How does AI Patrol Advisor work?',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const Spacer(),
                      AnimatedRotation(
                        turns: _isHowItWorksExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: const Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFF9CA3AF)),
                      ),
                    ],
                  ),
                  if (_isHowItWorksExpanded) ...[
                    const SizedBox(height: 10),
                    const Text(
                      'The AI Patrol Advisor analyses historical patrol data — including violation density, '
                      'repeat offender patterns, time-of-day trends, and compound issuance rates — to predict '
                      'which zones are most likely to have violations during specific time windows.\n\n'
                      'Recommendations are ranked by confidence score and prioritised for maximum enforcement efficiency. '
                      'The model improves as more patrol data is collected over time.',
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.5,
                        color: Color(0xFF6B7280),
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
  }

  Widget _buildRecommendation(PatrolRecommendation rec) {
    final color = patrolPriorityColor(rec.priority);
    final priorityLabel = rec.priority.name.toUpperCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border(left: BorderSide(color: color, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Priority badge + Zone
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  priorityLabel,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  rec.zone,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Reason
          Text(
            rec.reason,
            style: const TextStyle(
              fontSize: 11,
              height: 1.4,
              color: Color(0xFF4B5563),
            ),
          ),
          const SizedBox(height: 10),

          // Confidence + Suggested time
          Row(
            children: [
              // Confidence bar
              const Icon(Icons.auto_awesome, size: 12, color: Color(0xFF8B5CF6)),
              const SizedBox(width: 4),
              Text(
                '${(rec.confidenceScore * 100).round()}% confidence',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF8B5CF6),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: rec.confidenceScore,
                    backgroundColor: const Color(0xFFE5E7EB),
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF8B5CF6)),
                    minHeight: 3,
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Suggested time
              const Icon(Icons.schedule, size: 12, color: Color(0xFF6B7280)),
              const SizedBox(width: 4),
              Text(
                rec.suggestedTime,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
