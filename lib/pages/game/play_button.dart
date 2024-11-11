import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class PlayButton extends PositionComponent with TapCallbacks {
  static final defaultPaint = Paint()
    ..color = const Color(0xFFFFFFFF)
    ..style = PaintingStyle.fill;

  late TextPaint textPaint; // Make textPaint a member variable
  late String text = "Classic"; // Store the text

  @override
  FutureOr<void> onLoad() {
    size = Vector2(400, 80);
    textPaint =
        TextPaint(style: const TextStyle(fontSize: 32, color: Colors.black));

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y), const Radius.circular(20));

    canvas.drawRRect(rect, defaultPaint);
    // canvas.drawRRect(rect, borderPaint);

    // Calculate text bounds
    final textSpan = TextSpan(text: text, style: textPaint.style);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(minWidth: 0, maxWidth: size.x);

    // Calculate centered position
    final xCenter = (size.x - textPainter.width) / 2;
    final yCenter = (size.y - textPainter.height) / 2;

    // Draw the text
    textPainter.paint(canvas, Offset(xCenter, yCenter));

    super.render(canvas);
  }

  @override
  void onTapDown(TapDownEvent event) {
    debugPrint("Tapped tapped");
  }
}
