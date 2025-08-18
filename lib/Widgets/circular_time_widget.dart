import 'dart:math';
import 'package:flutter/material.dart';

class CircularTimeDisplay extends StatelessWidget {
  final int seconds; // current second (0–59)
  final Widget centerContent; // your digit widgets or poem
  final double size;
  final Color backgroundColor;
  final Color progressColor;

  const CircularTimeDisplay({
    super.key,
    required this.seconds,
    required this.centerContent,
    this.size = 200,
    this.backgroundColor = const Color(0xFFEEEEEE),
    this.progressColor = const Color(0xFF4CAF50),
  });

  @override
  Widget build(BuildContext context) {
    final progress = seconds / 60.0;

    return CustomPaint(
      painter: _CirclePainter(
        progress: progress,
        backgroundColor: backgroundColor,
        progressColor: progressColor,
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: Center(child: centerContent),
      ),
    );
  }
}

class _CirclePainter extends CustomPainter {
  final double progress;
  final Color backgroundColor; // fill inside the circle
  final Color progressColor;   // arc stroke

  _CirclePainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 3.0;
    final radius = (size.width - strokeWidth) / 2;
    final center = Offset(size.width / 2, size.height / 2);

    // Fill background
    final fillPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, fillPaint);

    // Draw arc stroke
    final arcPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(_CirclePainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.backgroundColor != backgroundColor ||
      oldDelegate.progressColor != progressColor;
}