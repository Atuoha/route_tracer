import 'package:flutter/material.dart';
import 'package:tracer/components/bottom_panel.dart';
import 'package:tracer/components/drawing_toolbar.dart';
import 'package:tracer/components/top_bar.dart';
import 'package:tracer/constants/app_constants.dart';
import 'package:tracer/models/draw_stroke.dart';
import 'package:tracer/models/vehicle_type.dart';
import 'package:tracer/widgets/dark_map_painter.dart';
import 'package:tracer/widgets/stroke_painter.dart';
import 'dart:math' as Math;

class TracerHomeScreen extends StatefulWidget {
  const TracerHomeScreen({super.key});

  @override
  State<TracerHomeScreen> createState() => _TracerHomeScreenState();
}

class _TracerHomeScreenState extends State<TracerHomeScreen>
    with TickerProviderStateMixin {
  List<DrawStroke> strokes = [];
  DrawStroke? currentStroke;
  bool isDrawing = true;
  Color selectedColor = kPaletteColors[0];
  double brushWidth = 4.0;
  VehicleType selectedVehicle = VehicleType.car;
  int selectedSpeedIndex = 0;
  late AnimationController animController;
  late Animation<double> animProgress;
  bool isAnimating = false;
  List<Offset> flatPath = [];


  @override
  void initState() {
    super.initState();
    animController = AnimationController(vsync: this);
    animProgress = Tween<double>(begin: 0.0, end: 1.0).animate(animController);
    animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => isAnimating = false);
      }
    });
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  List<Offset> buildFlatPath() {
    final points = <Offset>[];
    for (final stroke in strokes) {
      points.addAll(stroke.points);
    }
    return points;
  }

  double totalPathLength(List<Offset> pts) {
    double len = 0;
    for (int i = 1; i < pts.length; i++) {
      len += (pts[i] - pts[i - 1]).distance;
    }
    return len;
  }

  Offset positionAtFraction(List<Offset> pts, double t) {
    if (pts.isEmpty) return Offset.zero;
    if (pts.length == 1) return pts.first;
    final totalLen = totalPathLength(pts);
    final targetLen = totalLen * t;
    double accum = 0;
    for (int i = 1; i < pts.length; i++) {
      final segLen = (pts[i] - pts[i - 1]).distance;
      if (accum + segLen >= targetLen) {
        final segT = (targetLen - accum) / segLen;
        return Offset.lerp(pts[i - 1], pts[i], segT)!;
      }
      accum += segLen;
    }
    return pts.last;
  }

  double getAngle(List<Offset> pts, double t) {
  if (pts.length < 2) return 0;

  final totalLen = totalPathLength(pts);
  final targetLen = totalLen * t;

  double accum = 0;
  for (int i = 1; i < pts.length; i++) {
    final seg = pts[i] - pts[i - 1];
    final segLen = seg.distance;

    if (accum + segLen >= targetLen) {
      return Math.atan2(seg.dy, seg.dx);
    }
    accum += segLen;
  }

  final lastSeg = pts.last - pts[pts.length - 2];
  return Math.atan2(lastSeg.dy, lastSeg.dx);
}

  void startAnimation() {
    flatPath = buildFlatPath();
    if (flatPath.length < 2) return;

    final totalLen = totalPathLength(flatPath);
    final baseDuration = totalLen / 200.0;
    final speed = kSpeedMultipliers[selectedSpeedIndex];
    final duration = Duration(
      milliseconds: ((baseDuration / speed) * 1000).round().clamp(500, 60000),
    );

    animController.duration = duration;
    animController.reset();

    setState(() {
      isAnimating = true;
      isDrawing = false;
    });

    animController.forward();
  }

  void clearCanvas() {
    animController.reset();
    setState(() {
      strokes = [];
      currentStroke = null;
      isAnimating = false;
      flatPath = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: DarkMapPainter()),
          ),
          Positioned.fill(
            child: GestureDetector(
              onPanStart: isDrawing && !isAnimating
                  ? (d) {
                      setState(() {
                        currentStroke = DrawStroke(
                          points: [d.localPosition],
                          color: selectedColor,
                          width: brushWidth,
                        );
                      });
                    }
                  : null,
              onPanUpdate: isDrawing && !isAnimating
                  ? (d) {
                      setState(() {
                        currentStroke?.points.add(d.localPosition);
                      });
                    }
                  : null,
              onPanEnd: isDrawing && !isAnimating
                  ? (d) {
                      if (currentStroke != null) {
                        setState(() {
                          strokes.add(currentStroke!);
                          currentStroke = null;
                        });
                      }
                    }
                  : null,
              child: CustomPaint(
                painter: StrokePainter(
                  strokes: strokes,
                  currentStroke: currentStroke,
                ),
              ),
            ),
          ),
          if (isAnimating && flatPath.length >= 2)
            AnimatedBuilder(
              animation: animProgress,
              builder: (context, child) {
              final pos = positionAtFraction(flatPath, animProgress.value);
              final angle = getAngle(flatPath, animProgress.value) + Math.pi / 2;
              const vehicleSize = 36.0;

                return Positioned(
                        left: pos.dx - vehicleSize / 2,
                        top: pos.dy - vehicleSize / 2,
                        child: Transform.rotate(
                          angle: angle,
                          child: Container(
                            width: vehicleSize,
                            height: vehicleSize,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: selectedColor.withValues(alpha: 0.6),
                                  blurRadius: 16,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                kVehicleAssets[selectedVehicle.index],
                                fit: BoxFit.contain, // IMPORTANT
                              ),
                            ),
                          ),
                        ),
                      );
              },
            ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: const TopBar(),
          ),
          Positioned(
            right: 16,
            top: MediaQuery.of(context).padding.top + 70,
            child: DrawingToolbar(
              isDrawing: isDrawing,
              selectedColor: selectedColor,
              brushWidth: brushWidth,
              onToggleDrawing: () => setState(() => isDrawing = !isDrawing),
              onColorChanged: (c) => setState(() => selectedColor = c),
              onBrushWidthChanged: (v) => setState(() => brushWidth = v),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomPanel(
              selectedVehicle: selectedVehicle,
              selectedSpeedIndex: selectedSpeedIndex,
              isAnimating: isAnimating,
              onVehicleChanged: (v) => setState(() => selectedVehicle = v),
              onSpeedChanged: (i) => setState(() => selectedSpeedIndex = i),
              onClear: clearCanvas,
              onPlayStop: () {
                if (isAnimating) {
                  animController.stop();
                  setState(() => isAnimating = false);
                } else {
                  startAnimation();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
