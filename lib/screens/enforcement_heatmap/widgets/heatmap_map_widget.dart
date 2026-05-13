import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../enforcement_heatmap_data.dart';

/// Custom-painted map widget that renders enforcement zones (polygons)
/// or individual plate markers (dots), depending on the current mode.
class HeatmapMapWidget extends StatelessWidget {
  final List<EnforcementZone> zones;
  final bool showZones; // true = polygon view, false = marker view
  final Set<PlateStatus> activeStatusFilters;
  final int? selectedZoneIndex;
  final int? selectedMarkerZoneIdx;
  final int? selectedMarkerPlateIdx;
  final ValueChanged<int>? onZoneTap;
  final Function(int zoneIdx, int plateIdx)? onMarkerTap;

  const HeatmapMapWidget({
    super.key,
    required this.zones,
    required this.showZones,
    required this.activeStatusFilters,
    this.selectedZoneIndex,
    this.selectedMarkerZoneIdx,
    this.selectedMarkerPlateIdx,
    this.onZoneTap,
    this.onMarkerTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFEAF0EA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD1D5DB)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: GestureDetector(
          onTapDown: (details) => _handleTap(details, context),
          child: CustomPaint(
            painter: _HeatmapPainter(
              zones: zones,
              showZones: showZones,
              activeStatusFilters: activeStatusFilters,
              selectedZoneIndex: selectedZoneIndex,
              selectedMarkerZoneIdx: selectedMarkerZoneIdx,
              selectedMarkerPlateIdx: selectedMarkerPlateIdx,
            ),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }

  void _handleTap(TapDownDetails details, BuildContext context) {
    final box = context.findRenderObject() as RenderBox;
    final size = box.size;
    final pos = details.localPosition;
    final normX = pos.dx / size.width;
    final normY = pos.dy / size.height;

    if (showZones) {
      // Find which zone polygon contains the tap
      for (int i = 0; i < zones.length; i++) {
        if (_pointInPolygon(Offset(normX, normY), zones[i].polygonPoints)) {
          onZoneTap?.call(i);
          return;
        }
      }
    } else {
      // Find nearest marker
      double minDist = double.infinity;
      int bestZone = -1, bestPlate = -1;
      for (int zi = 0; zi < zones.length; zi++) {
        for (int pi = 0; pi < zones[zi].plates.length; pi++) {
          final p = zones[zi].plates[pi];
          if (!activeStatusFilters.contains(p.status)) continue;
          final dx = p.coordinates.dx - normX;
          final dy = p.coordinates.dy - normY;
          final dist = math.sqrt(dx * dx + dy * dy);
          if (dist < minDist && dist < 0.04) {
            minDist = dist;
            bestZone = zi;
            bestPlate = pi;
          }
        }
      }
      if (bestZone >= 0) {
        onMarkerTap?.call(bestZone, bestPlate);
      }
    }
  }

  bool _pointInPolygon(Offset point, List<Offset> polygon) {
    bool inside = false;
    int j = polygon.length - 1;
    for (int i = 0; i < polygon.length; i++) {
      if ((polygon[i].dy > point.dy) != (polygon[j].dy > point.dy) &&
          point.dx <
              (polygon[j].dx - polygon[i].dx) *
                      (point.dy - polygon[i].dy) /
                      (polygon[j].dy - polygon[i].dy) +
                  polygon[i].dx) {
        inside = !inside;
      }
      j = i;
    }
    return inside;
  }
}

class _HeatmapPainter extends CustomPainter {
  final List<EnforcementZone> zones;
  final bool showZones;
  final Set<PlateStatus> activeStatusFilters;
  final int? selectedZoneIndex;
  final int? selectedMarkerZoneIdx;
  final int? selectedMarkerPlateIdx;

  _HeatmapPainter({
    required this.zones,
    required this.showZones,
    required this.activeStatusFilters,
    this.selectedZoneIndex,
    this.selectedMarkerZoneIdx,
    this.selectedMarkerPlateIdx,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawGrid(canvas, size);
    _drawRoads(canvas, size);

    if (showZones) {
      _drawZones(canvas, size);
    } else {
      // Draw zone boundaries as faint outlines in marker mode
      _drawZoneOutlines(canvas, size);
      _drawMarkers(canvas, size);
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
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    // Horizontal roads
    canvas.drawLine(
        Offset(10, size.height * 0.29),
        Offset(size.width - 10, size.height * 0.29),
        roadPaint);
    canvas.drawLine(
        Offset(10, size.height * 0.56),
        Offset(size.width - 10, size.height * 0.56),
        roadPaint);
    canvas.drawLine(
        Offset(10, size.height * 0.78),
        Offset(size.width - 10, size.height * 0.78),
        roadPaint);

    // Vertical roads
    canvas.drawLine(
        Offset(size.width * 0.23, 10),
        Offset(size.width * 0.23, size.height - 10),
        roadPaint);
    canvas.drawLine(
        Offset(size.width * 0.49, 10),
        Offset(size.width * 0.49, size.height - 10),
        roadPaint);
    canvas.drawLine(
        Offset(size.width * 0.73, 10),
        Offset(size.width * 0.73, size.height - 10),
        roadPaint);
  }

  void _drawZones(Canvas canvas, Size size) {
    for (int i = 0; i < zones.length; i++) {
      final zone = zones[i];
      final color = zoneSeverityColor(zone.severity);
      final opacity = zoneSeverityOpacity(zone.severity);
      final isSelected = selectedZoneIndex == i;

      // Draw filled polygon
      final path = Path();
      for (int j = 0; j < zone.polygonPoints.length; j++) {
        final pt = Offset(
          zone.polygonPoints[j].dx * size.width,
          zone.polygonPoints[j].dy * size.height,
        );
        if (j == 0) {
          path.moveTo(pt.dx, pt.dy);
        } else {
          path.lineTo(pt.dx, pt.dy);
        }
      }
      path.close();

      // Fill
      canvas.drawPath(
        path,
        Paint()
          ..color = color.withValues(alpha: isSelected ? opacity + 0.15 : opacity)
          ..style = PaintingStyle.fill,
      );

      // Border
      canvas.drawPath(
        path,
        Paint()
          ..color = color.withValues(alpha: isSelected ? 0.8 : 0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = isSelected ? 2.5 : 1.5,
      );

      // Compact violation count badge (no zone name)
      if (zone.violationCount > 0) {
        final labelPos = Offset(
          zone.labelPosition.dx * size.width,
          zone.labelPosition.dy * size.height,
        );

        final countTp = TextPainter(
          text: TextSpan(
            text: '${zone.violationCount}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        final badgeW = countTp.width + 10;
        final badgeH = countTp.height + 6;
        final badgeRect = RRect.fromRectAndRadius(
          Rect.fromCenter(center: labelPos, width: badgeW, height: badgeH),
          const Radius.circular(6),
        );

        canvas.drawRRect(badgeRect, Paint()..color = color.withValues(alpha: 0.85));
        countTp.paint(
          canvas,
          Offset(labelPos.dx - countTp.width / 2, labelPos.dy - countTp.height / 2),
        );
      }
    }
  }

  void _drawZoneOutlines(Canvas canvas, Size size) {
    for (final zone in zones) {
      final path = Path();
      for (int j = 0; j < zone.polygonPoints.length; j++) {
        final pt = Offset(
          zone.polygonPoints[j].dx * size.width,
          zone.polygonPoints[j].dy * size.height,
        );
        if (j == 0) {
          path.moveTo(pt.dx, pt.dy);
        } else {
          path.lineTo(pt.dx, pt.dy);
        }
      }
      path.close();

      canvas.drawPath(
        path,
        Paint()
          ..color = const Color(0xFF9CA3AF).withValues(alpha: 0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8,
      );
    }
  }

  void _drawMarkers(Canvas canvas, Size size) {
    for (int zi = 0; zi < zones.length; zi++) {
      for (int pi = 0; pi < zones[zi].plates.length; pi++) {
        final plate = zones[zi].plates[pi];
        if (!activeStatusFilters.contains(plate.status)) continue;

        final pt = Offset(
          plate.coordinates.dx * size.width,
          plate.coordinates.dy * size.height,
        );
        final color = plateStatusColor(plate.status);
        final isSelected =
            selectedMarkerZoneIdx == zi && selectedMarkerPlateIdx == pi;

        final radius = isSelected ? 7.0 : 5.0;

        // Shadow
        canvas.drawCircle(
          pt.translate(0, 0.5),
          radius,
          Paint()..color = Colors.black.withValues(alpha: 0.1),
        );

        // Dot
        canvas.drawCircle(pt, radius, Paint()..color = color);

        if (isSelected) {
          // Inner white dot
          canvas.drawCircle(pt, 2.5, Paint()..color = Colors.white);
          // Outer ring
          canvas.drawCircle(
            pt,
            radius + 4,
            Paint()
              ..color = color.withValues(alpha: 0.25)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.5,
          );
        }

        // Plate label for selected marker
        if (isSelected) {
          final tp = TextPainter(
            text: TextSpan(
              text: plate.plateNumber,
              style: TextStyle(
                color: color,
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
            textDirection: TextDirection.ltr,
          )..layout();

          final labelOffset =
              pt.translate(-tp.width / 2, -(radius + tp.height + 8));
          final rect = Rect.fromLTWH(
            labelOffset.dx - 5,
            labelOffset.dy - 2,
            tp.width + 10,
            tp.height + 4,
          );
          canvas.drawRRect(
            RRect.fromRectAndRadius(rect, const Radius.circular(4)),
            Paint()..color = Colors.white.withValues(alpha: 0.94),
          );
          canvas.drawRRect(
            RRect.fromRectAndRadius(rect, const Radius.circular(4)),
            Paint()
              ..color = color.withValues(alpha: 0.4)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 0.8,
          );
          tp.paint(canvas, labelOffset);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
