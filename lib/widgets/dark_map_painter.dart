import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class DarkMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF0D0F1A),
    );

    final gridPaint = Paint()
      ..color = const Color(0xFF1A1E35).withValues(alpha: 0.5)
      ..strokeWidth = 0.5;

    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final roadPaint = Paint()
      ..color = const Color(0xFF252A45).withValues(alpha: 0.6)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final path1 = Path()
      ..moveTo(0, size.height * 0.3)
      ..cubicTo(
        size.width * 0.2,
        size.height * 0.25,
        size.width * 0.4,
        size.height * 0.45,
        size.width * 0.6,
        size.height * 0.35,
      )
      ..cubicTo(
        size.width * 0.8,
        size.height * 0.25,
        size.width * 0.9,
        size.height * 0.4,
        size.width,
        size.height * 0.38,
      );
    canvas.drawPath(path1, roadPaint);

    final path2 = Path()
      ..moveTo(size.width * 0.15, 0)
      ..cubicTo(
        size.width * 0.2,
        size.height * 0.3,
        size.width * 0.35,
        size.height * 0.5,
        size.width * 0.3,
        size.height,
      );
    canvas.drawPath(path2, roadPaint);

    final path3 = Path()
      ..moveTo(size.width * 0.7, 0)
      ..cubicTo(
        size.width * 0.65,
        size.height * 0.35,
        size.width * 0.8,
        size.height * 0.6,
        size.width * 0.75,
        size.height,
      );
    canvas.drawPath(path3, roadPaint);

    final path4 = Path()
      ..moveTo(0, size.height * 0.7)
      ..cubicTo(
        size.width * 0.3,
        size.height * 0.65,
        size.width * 0.6,
        size.height * 0.8,
        size.width,
        size.height * 0.72,
      );
    canvas.drawPath(path4, roadPaint);

    final dotPaint = Paint()..style = PaintingStyle.fill;
    final glowPoints = [
      Offset(size.width * 0.3, size.height * 0.35),
      Offset(size.width * 0.7, size.height * 0.33),
      Offset(size.width * 0.5, size.height * 0.55),
      Offset(size.width * 0.2, size.height * 0.7),
      Offset(size.width * 0.75, size.height * 0.72),
    ];

    for (final pt in glowPoints) {
      dotPaint.color = const Color(0xFF6C63FF).withValues(alpha: 0.08);
      canvas.drawCircle(pt, 12, dotPaint);
      dotPaint.color = const Color(0xFF6C63FF).withValues(alpha: 0.25);
      canvas.drawCircle(pt, 4, dotPaint);
      dotPaint.color = const Color(0xFF6C63FF).withValues(alpha: 0.5);
      canvas.drawCircle(pt, 2, dotPaint);
    }

    final borderPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF6C63FF).withValues(alpha: 0.15),
          const Color(0xFF00E5FF).withValues(alpha: 0.05),
          const Color(0xFF6C63FF).withValues(alpha: 0.15),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(1, 1, size.width - 2, size.height - 2),
        const Radius.circular(0),
      ),
      borderPaint,
    );

    final coordStyle = ui.TextStyle(
      color: const Color(0xFF3A4070),
      fontSize: 10,
      fontWeight: FontWeight.w300,
    );
    final pb1 = ui.ParagraphBuilder(ui.ParagraphStyle())
      ..pushStyle(coordStyle)
      ..addText('LAT 40.7128° N');
    final para1 = pb1.build()
      ..layout(const ui.ParagraphConstraints(width: 200));
    canvas.drawParagraph(para1, Offset(16, size.height * 0.12));

    final pb2 = ui.ParagraphBuilder(ui.ParagraphStyle())
      ..pushStyle(coordStyle)
      ..addText('LNG 74.0060° W');
    final para2 = pb2.build()
      ..layout(const ui.ParagraphConstraints(width: 200));
    canvas.drawParagraph(para2, Offset(16, size.height * 0.12 + 16));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
