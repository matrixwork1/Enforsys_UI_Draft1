import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Simulated map widget using CustomPaint with status-colored pins.
class MovementMapWidget extends StatelessWidget {
  final List<MapEntry<String, Offset>> points;
  final int activeIndex;
  final bool showPwidLabels;
  final int? selectedIndex;
  final List<Color>? statusColors; // per-point status colors

  const MovementMapWidget({
    super.key,
    required this.points,
    required this.activeIndex,
    this.showPwidLabels = false,
    this.selectedIndex,
    this.statusColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFEAF0EA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD1D5DB)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: CustomPaint(
          painter: _MapPainter(
            points: points,
            activeIndex: activeIndex,
            showPwidLabels: showPwidLabels,
            selectedIndex: selectedIndex,
            statusColors: statusColors,
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  final List<MapEntry<String, Offset>> points;
  final int activeIndex;
  final bool showPwidLabels;
  final int? selectedIndex;
  final List<Color>? statusColors;

  _MapPainter({
    required this.points,
    required this.activeIndex,
    required this.showPwidLabels,
    this.selectedIndex,
    this.statusColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    _drawGrid(canvas, size);
    _drawRoads(canvas, size);

    final mapped = points.map((e) =>
      Offset(e.value.dx * size.width, e.value.dy * size.height)).toList();

    // Draw path line for individual staff mode
    if (!showPwidLabels && mapped.length > 1) {
      final pathPaint = Paint()
        ..color = const Color(0xFF1F2937).withValues(alpha: 0.35)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;
      for (int i = 0; i < mapped.length - 1; i++) {
        _drawDashedLine(canvas, mapped[i], mapped[i + 1], pathPaint);
      }
    }

    // Draw dots
    for (int i = 0; i < mapped.length; i++) {
      final pt = mapped[i];
      final isActive = i == activeIndex;
      final isSelected = selectedIndex != null && i == selectedIndex;
      final color = statusColors != null && i < statusColors!.length
          ? statusColors![i]
          : const Color(0xFF1F2937);

      if (showPwidLabels) {
        _drawPwidDot(canvas, pt, points[i].key, isActive || isSelected, color);
      } else {
        _drawSmallDot(canvas, pt, isActive, color);
      }
    }
  }

  void _drawGrid(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFFD4DED4)
      ..strokeWidth = 0.5;
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  void _drawRoads(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = const Color(0xFFC8D8C8)
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(20, size.height * 0.3), Offset(size.width - 20, size.height * 0.3), roadPaint);
    canvas.drawLine(Offset(20, size.height * 0.7), Offset(size.width - 20, size.height * 0.7), roadPaint);
    canvas.drawLine(Offset(size.width * 0.3, 20), Offset(size.width * 0.3, size.height - 20), roadPaint);
    canvas.drawLine(Offset(size.width * 0.65, 20), Offset(size.width * 0.65, size.height - 20), roadPaint);
  }

  void _drawSmallDot(Canvas canvas, Offset pt, bool isActive, Color color) {
    final radius = isActive ? 5.0 : 3.5;
    canvas.drawCircle(pt.translate(0, 0.5), radius, Paint()..color = Colors.black.withValues(alpha: 0.1));
    canvas.drawCircle(pt, radius, Paint()..color = isActive ? const Color(0xFFF5A623) : color);
    if (isActive) {
      canvas.drawCircle(pt, 2, Paint()..color = Colors.white);
      canvas.drawCircle(pt, 9, Paint()
        ..color = const Color(0xFFF5A623).withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke..strokeWidth = 1.5);
    }
  }

  void _drawPwidDot(Canvas canvas, Offset pt, String pwid, bool isHighlighted, Color color) {
    // Red dots larger for visual weight
    final isRed = color == const Color(0xFFEF4444);
    final isAmber = color == const Color(0xFFF59E0B);
    final dotRadius = isHighlighted ? 6.0 : (isRed ? 5.5 : (isAmber ? 5.0 : 4.0));

    canvas.drawCircle(pt.translate(0, 0.5), dotRadius, Paint()..color = Colors.black.withValues(alpha: 0.12));
    canvas.drawCircle(pt, dotRadius, Paint()..color = color);

    if (isHighlighted) {
      canvas.drawCircle(pt, 2, Paint()..color = Colors.white);
      canvas.drawCircle(pt, dotRadius + 4, Paint()
        ..color = color.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke..strokeWidth = 1.5);
    }

    // PWID label badge
    final tp = TextPainter(
      text: TextSpan(
        text: pwid,
        style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w700),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final labelOffset = pt.translate(-tp.width / 2, -(dotRadius + tp.height + 6));
    final rect = Rect.fromLTWH(labelOffset.dx - 5, labelOffset.dy - 2, tp.width + 10, tp.height + 4);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)),
      Paint()..color = Colors.white.withValues(alpha: 0.94));
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)),
      Paint()..color = color.withValues(alpha: 0.4)..style = PaintingStyle.stroke..strokeWidth = 0.8);
    tp.paint(canvas, labelOffset);
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashW = 5.0, dashS = 3.0;
    final dx = end.dx - start.dx, dy = end.dy - start.dy;
    final dist = math.sqrt(dx * dx + dy * dy);
    if (dist == 0) return;
    final steps = (dist / (dashW + dashS)).floor();
    final sdx = dx / dist * (dashW + dashS), sdy = dy / dist * (dashW + dashS);
    final ddx = dx / dist * dashW, ddy = dy / dist * dashW;
    for (int i = 0; i < steps; i++) {
      final x = start.dx + sdx * i, y = start.dy + sdy * i;
      canvas.drawLine(Offset(x, y), Offset(x + ddx, y + ddy), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
