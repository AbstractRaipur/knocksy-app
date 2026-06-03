import 'package:flutter/material.dart';

/// The Knocksy brand mark — a bold "K" with a three-ray spark at its top-left.
/// Drawn in code (no asset needed) so it can be tinted/sized anywhere; used as
/// the faint watermark on the orange header.
class BrandMark extends StatelessWidget {
  final double size;
  final Color color;

  const BrandMark({super.key, this.size = 64, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _BrandMarkPainter(color)),
    );
  }
}

class _BrandMarkPainter extends CustomPainter {
  final Color color;
  _BrandMarkPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = s * 0.085;

    // --- "K" ---
    // vertical stem
    canvas.drawLine(Offset(s * 0.45, s * 0.34), Offset(s * 0.45, s * 0.96), paint);
    // upper diagonal
    canvas.drawLine(Offset(s * 0.45, s * 0.66), Offset(s * 0.92, s * 0.34), paint);
    // lower diagonal
    canvas.drawLine(Offset(s * 0.56, s * 0.60), Offset(s * 0.94, s * 0.96), paint);

    // --- spark (top-left rays) ---
    final spark = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = s * 0.075;
    // up
    canvas.drawLine(Offset(s * 0.28, s * 0.26), Offset(s * 0.28, s * 0.06), spark);
    // diagonal
    canvas.drawLine(Offset(s * 0.23, s * 0.22), Offset(s * 0.07, s * 0.08), spark);
    // left
    canvas.drawLine(Offset(s * 0.22, s * 0.30), Offset(s * 0.03, s * 0.26), spark);
  }

  @override
  bool shouldRepaint(covariant _BrandMarkPainter old) => old.color != color;
}
