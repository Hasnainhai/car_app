import 'package:fl_carmax/utils/constant.dart';
import 'package:flutter/material.dart';

class CustomThumbShape extends RangeSliderThumbShape {
  final String start;
  final String end;
  final double minValue;
  final double maxValue;
  static const double _thumbSize = 14.0;

  CustomThumbShape({
    required this.start,
    required this.end,
    required this.minValue,
    required this.maxValue,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      const Size(_thumbSize, _thumbSize);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = true,
    bool isOnTop = false,
    bool isPressed = false,
    required SliderThemeData sliderTheme,
    TextDirection textDirection = TextDirection.ltr,
    Thumb thumb = Thumb.start,
  }) {
    final Canvas canvas = context.canvas;

    // Draw thumb circle
    final Paint paint = Paint()
      ..color = sliderTheme.thumbColor ?? Colors.blue
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, _thumbSize / 2, paint);

    // Draw labels
    final TextSpan span = TextSpan(
      text: thumb == Thumb.start ? start : end,
      style: TextStyle(
        fontSize: 12,
        color: sliderTheme.thumbColor ?? Colors.blue,
        fontWeight: FontWeight.w500,
      ),
    );

    final TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: textDirection,
    )..layout();

    // Fixed positions:
    // - Start thumb label always on left side
    // - End thumb label always on right side
    double dx;
    if (thumb == Thumb.start) {
      dx = center.dx - _thumbSize * 2; // Left position for min label
    } else {
      dx = center.dx + _thumbSize; // Right position for max label
    }

    final Offset labelOffset = Offset(
      dx,
      center.dy - _thumbSize - tp.height - 4,
    );

    tp.paint(canvas, labelOffset);
  }

  double _parseValue(String value) {
    return double.tryParse(value.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0.0;
  }
}
