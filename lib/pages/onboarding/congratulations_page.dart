import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../const/app_const.dart';
import '../../utils/app_navigator.dart';
import '../../widgets/app_button.dart';
import '../main_shell.dart';

/// Final onboarding step — orange full-bleed background, white check badge,
/// "Congratulations!" heading, supporting copy, and a blue Continue CTA, with
/// a self-contained confetti burst (custom painter, no external package).
/// UI-only: Continue → [MainShell].
class CongratulationsPage extends StatefulWidget {
  const CongratulationsPage({super.key});

  @override
  State<CongratulationsPage> createState() => _CongratulationsPageState();
}

class _CongratulationsPageState extends State<CongratulationsPage>
    with TickerProviderStateMixin {
  late final AnimationController _badge;
  late final Animation<double> _badgeScale;
  late final AnimationController _confetti;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));

    _badge = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _badgeScale = CurvedAnimation(parent: _badge, curve: Curves.elasticOut);

    _confetti = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _badge.forward();
      _confetti.forward(from: 0);
    });
  }

  @override
  void dispose() {
    _badge.dispose();
    _confetti.dispose();
    super.dispose();
  }

  void _onContinue() {
    AppNavigator.replaceAll(context, const MainShell());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final badgeSize = (size.width / 2.8).clamp(120.0, 180.0);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppConst.primary,
        body: Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConst.padding * 1.6),
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.16),
                    ScaleTransition(
                      scale: _badgeScale,
                      child: _CheckBadge(size: badgeSize),
                    ),
                    SizedBox(height: size.height * 0.06),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Congratulations!',
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          color: Colors.white,
                          fontSize: (size.width / 9).clamp(28.0, 40.0),
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      "You're all set!",
                      textAlign: TextAlign.center,
                      style: AppConst.body.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom + 24,
                      ),
                      child: AppButton(
                        color: Colors.white,
                        width: double.infinity,
                        height: 56,
                        onTap: _onContinue,
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            color: AppConst.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Confetti overlay (custom, always renders).
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _confetti,
                  builder: (context, _) => CustomPaint(
                    painter: _ConfettiPainter(_confetti.value),
                    size: Size.infinite,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Paints falling confetti for a single forward pass (progress 0 → 1).
class _ConfettiPainter extends CustomPainter {
  final double progress;

  // Stable particle set (generated once with a fixed seed so it doesn't
  // re-randomise every repaint).
  static final List<_Particle> _particles = _build();
  static List<_Particle> _build() {
    final rnd = math.Random(7);
    const colors = [
      Colors.white,
      AppConst.accent,
      Color(0xffFFD18A),
      Color(0xffFFEDC8),
      Color(0xffB6E0FF),
    ];
    return List.generate(70, (i) {
      return _Particle(
        x: rnd.nextDouble(),
        delay: rnd.nextDouble() * 0.35,
        speed: 0.75 + rnd.nextDouble() * 0.5,
        drift: (rnd.nextDouble() - 0.5) * 0.25,
        size: 7 + rnd.nextDouble() * 8,
        rotation: rnd.nextDouble() * math.pi,
        rotationSpeed: (rnd.nextDouble() - 0.5) * 12,
        color: colors[rnd.nextInt(colors.length)],
        round: rnd.nextBool(),
      );
    });
  }

  _ConfettiPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return;
    final paint = Paint();
    for (final p in _particles) {
      final t = ((progress - p.delay) / (1 - p.delay)).clamp(0.0, 1.0);
      if (t <= 0) continue;
      final y = (t * p.speed) * (size.height + 60) - 30;
      if (y > size.height + 30) continue;
      final x = p.x * size.width +
          math.sin(t * math.pi * 3) * (p.drift * size.width);
      final opacity = (1.0 - t).clamp(0.0, 1.0);
      paint.color = p.color.withOpacity(opacity);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(p.rotation + p.rotationSpeed * t);
      if (p.round) {
        canvas.drawCircle(Offset.zero, p.size / 2, paint);
      } else {
        canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.6),
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter old) =>
      old.progress != progress;
}

class _Particle {
  final double x; // 0..1 of width
  final double delay; // 0..1 start offset
  final double speed; // fall-speed multiplier
  final double drift; // horizontal sway amount
  final double size;
  final double rotation;
  final double rotationSpeed;
  final Color color;
  final bool round;

  const _Particle({
    required this.x,
    required this.delay,
    required this.speed,
    required this.drift,
    required this.size,
    required this.rotation,
    required this.rotationSpeed,
    required this.color,
    required this.round,
  });
}

class _CheckBadge extends StatelessWidget {
  final double size;

  const _CheckBadge({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.check_rounded,
          color: AppConst.primary,
          size: size * 0.55,
        ),
      ),
    );
  }
}
