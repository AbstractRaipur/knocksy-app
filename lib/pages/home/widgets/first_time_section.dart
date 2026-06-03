import 'package:flutter/material.dart';

import '../../../const/app_assets.dart';
import '../../../const/app_const.dart';

/// "When was the Last time you did / Something for the First Time" block,
/// followed by the hiking illustration. Uses the [AppAssets.firstTimeHiker]
/// PNG when present, otherwise a painted flat-illustration fallback.
class FirstTimeSection extends StatelessWidget {
  const FirstTimeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'When was the Last time you did',
                style: AppConst.caption.copyWith(
                  color: AppConst.darkGray,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Something for\nthe First Time',
                style: AppConst.t1.copyWith(fontSize: 26, height: 1.2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AspectRatio(
          aspectRatio: 780 / 520,
          child: Image.asset(
            AppAssets.firstTimeHiker,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const _HikerFallback(),
          ),
        ),
      ],
    );
  }
}

/// Flat-illustration fallback painted in code so the section looks intentional
/// before the real PNG is dropped into `assets/images/home/`.
class _HikerFallback extends StatelessWidget {
  const _HikerFallback();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _HikerPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _HikerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Sky
    final sky = Paint()..color = const Color(0xffF7F3EC);
    canvas.drawRect(Offset.zero & size, sky);

    // Sun
    canvas.drawCircle(
      Offset(w * 0.78, h * 0.42),
      h * 0.22,
      Paint()..color = const Color(0xffF6C66B),
    );
    canvas.drawCircle(
      Offset(w * 0.78, h * 0.42),
      h * 0.14,
      Paint()..color = const Color(0xffF2A93B),
    );

    // Distant mountains
    final farMountain = Paint()..color = const Color(0xffB8C2CC);
    final p1 = Path()
      ..moveTo(w * 0.45, h)
      ..lineTo(w * 0.66, h * 0.45)
      ..lineTo(w * 0.88, h)
      ..close();
    canvas.drawPath(p1, farMountain);

    final farMountain2 = Paint()..color = const Color(0xffCDD5DD);
    final p2 = Path()
      ..moveTo(w * 0.7, h)
      ..lineTo(w * 0.9, h * 0.58)
      ..lineTo(w, h * 0.95)
      ..lineTo(w, h)
      ..close();
    canvas.drawPath(p2, farMountain2);

    // Near cliff (left) where the hiker sits
    final cliff = Paint()..color = const Color(0xff4F5B66);
    final cliffPath = Path()
      ..moveTo(0, h * 0.55)
      ..lineTo(w * 0.36, h * 0.72)
      ..lineTo(w * 0.30, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(cliffPath, cliff);

    // Water
    final water = Paint()..color = const Color(0xff63C5C0);
    final waterPath = Path()
      ..moveTo(w * 0.30, h)
      ..lineTo(w * 0.36, h * 0.82)
      ..lineTo(w * 0.7, h * 0.86)
      ..lineTo(w * 0.78, h)
      ..close();
    canvas.drawPath(waterPath, water);

    // Hiker silhouette (simple seated figure with backpack)
    final body = Paint()..color = const Color(0xff37424D);
    final cx = w * 0.2;
    final cy = h * 0.5;
    // backpack
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - h * 0.14, cy, h * 0.14, h * 0.2),
        Radius.circular(h * 0.03),
      ),
      Paint()..color = const Color(0xff7CA34E),
    );
    // torso
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - h * 0.03, cy - h * 0.02, h * 0.1, h * 0.22),
        Radius.circular(h * 0.03),
      ),
      body,
    );
    // head
    canvas.drawCircle(Offset(cx + h * 0.02, cy - h * 0.08), h * 0.06, body);
    // legs (dangling)
    final legs = Paint()..color = const Color(0xffE8A53C);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx, cy + h * 0.2, h * 0.07, h * 0.22),
        Radius.circular(h * 0.02),
      ),
      legs,
    );

    // A couple of clouds
    final cloud = Paint()..color = Colors.white;
    void drawCloud(double x, double y, double s) {
      canvas.drawCircle(Offset(x, y), s, cloud);
      canvas.drawCircle(Offset(x + s, y + s * 0.2), s * 0.8, cloud);
      canvas.drawCircle(Offset(x - s, y + s * 0.2), s * 0.8, cloud);
      canvas.drawRect(
          Rect.fromLTWH(x - s * 1.8, y + s * 0.2, s * 3.6, s), cloud);
    }

    drawCloud(w * 0.3, h * 0.18, h * 0.05);
    drawCloud(w * 0.6, h * 0.12, h * 0.04);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
