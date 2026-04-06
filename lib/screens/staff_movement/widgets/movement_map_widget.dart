import 'dart:math' as math;
import 'package:flutter/material.dart';

class MovementMapWidget extends StatelessWidget {
  final List<MapEntry<String, Offset>> points;
  final int activeIndex;

  const MovementMapWidget({
    super.key,
    required this.points,
    required this.activeIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F0E8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD1D5DB)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: CustomPaint(
          painter: _MapPainter(points: points, activeIndex: activeIndex),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  final List<MapEntry<String, Offset>> points;
  final int activeIndex;

  _MapPainter({required this.points, required this.activeIndex});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    // Draw grid lines for "map" effect
    final gridPaint = Paint()
      ..color = const Color(0xFFD4DED4)
      ..strokeWidth = 0.5;

    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw "roads" — some horizontal and vertical thick lines
    final roadPaint = Paint()
      ..color = const Color(0xFFC8D8C8)
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(30, size.height * 0.3),
      Offset(size.width - 30, size.height * 0.3),
      roadPaint,
    );
    canvas.drawLine(
      Offset(30, size.height * 0.7),
      Offset(size.width - 30, size.height * 0.7),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.3, 30),
      Offset(size.width * 0.3, size.height - 30),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.7, 30),
      Offset(size.width * 0.7, size.height - 30),
      roadPaint,
    );

    // Map points to actual coordinates within the canvas
    final mappedPoints = points.map((entry) {
      return Offset(
        entry.value.dx * size.width,
        entry.value.dy * size.height,
      );
    }).toList();

    // Draw path line (dashed)
    if (mappedPoints.length > 1) {
      final pathPaint = Paint()
        ..color = const Color(0xFF1F2937).withValues(alpha: 0.5)
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;

      for (int i = 0; i < mappedPoints.length - 1; i++) {
        _drawDashedLine(canvas, mappedPoints[i], mappedPoints[i + 1], pathPaint);
      }
    }

    // Draw pins
    for (int i = 0; i < mappedPoints.length; i++) {
      final isActive = i == activeIndex;
      final pt = mappedPoints[i];

      // Pin shadow
      canvas.drawCircle(
        pt.translate(0, 1),
        isActive ? 10 : 7,
        Paint()..color = Colors.black.withValues(alpha: 0.15),
      );

      // Pin circle
      canvas.drawCircle(
        pt,
        isActive ? 10 : 7,
        Paint()..color = isActive ? const Color(0xFFF5A623) : const Color(0xFF1F2937),
      );

      // Inner white dot
      canvas.drawCircle(
        pt,
        isActive ? 5 : 3,
        Paint()..color = Colors.white,
      );

      // Active pulse ring
      if (isActive) {
        canvas.drawCircle(
          pt,
          16,
          Paint()
            ..color = const Color(0xFFF5A623).withValues(alpha: 0.2)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
      }

      // Label
      final textPainter = TextPainter(
        text: TextSpan(
          text: points[i].key,
          style: TextStyle(
            color: const Color(0xFF1F2937),
            fontSize: isActive ? 11 : 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      // Background for label
      final double dyOffset = isActive ? -26.0 : -20.0;
      final labelOffset = pt.translate(-textPainter.width / 2, dyOffset);
      final labelRect = Rect.fromLTWH(
        labelOffset.dx - 4.0,
        labelOffset.dy - 2.0,
        textPainter.width + 8.0,
        textPainter.height + 4.0,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(labelRect, const Radius.circular(4)),
        Paint()..color = Colors.white.withValues(alpha: 0.9),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(labelRect, const Radius.circular(4)),
        Paint()
          ..color = const Color(0xFFD1D5DB)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5,
      );

      textPainter.paint(canvas, labelOffset);
    }
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final distance = math.sqrt(dx * dx + dy * dy);
    final steps = (distance / (dashWidth + dashSpace)).floor();
    final stepDx = dx / distance * (dashWidth + dashSpace);
    final stepDy = dy / distance * (dashWidth + dashSpace);
    final dashDx = dx / distance * dashWidth;
    final dashDy = dy / distance * dashWidth;

    for (int i = 0; i < steps; i++) {
      final x = start.dx + stepDx * i;
      final y = start.dy + stepDy * i;
      canvas.drawLine(
        Offset(x, y),
        Offset(x + dashDx, y + dashDy),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
