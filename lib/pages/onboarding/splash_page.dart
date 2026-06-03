import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../const/app_const.dart';
import '../../utils/app_navigator.dart';
import '../../widgets/app_logo.dart';
import 'login_page.dart';

/// Knocksy splash — pure Dart custom splash (no native splash assets).
///
/// Plays a short scale-in animation on the wordmark, then auto-routes to
/// [LoginPage]. Status bar is forced to light icons for the orange backdrop.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    Future.delayed(AppConst.splashDuration, () {
      if (!mounted) return;
      AppNavigator.replaceAll(context, const LoginPage());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final wordmarkHeight = (size.width / 8).clamp(36.0, 60.0);

    return Scaffold(
      backgroundColor: AppConst.primary,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SafeArea(
          child: Stack(
            children: [
              // Soft brand wash blobs for depth (purely decorative)
              Positioned(
                top: -size.width * 0.35,
                right: -size.width * 0.35,
                child: _blob(size.width * 0.9, Colors.white.withOpacity(0.06)),
              ),
              Positioned(
                bottom: -size.width * 0.25,
                left: -size.width * 0.2,
                child: _blob(size.width * 0.7, Colors.white.withOpacity(0.05)),
              ),

              // Centred wordmark + tagline
              Center(
                child: FadeTransition(
                  opacity: _fade,
                  child: ScaleTransition(
                    scale: _scale,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        KnocksyWordmark(
                          height: wordmarkHeight,
                          color: Colors.white,
                        ),
                        SizedBox(height: size.height * 0.018),
                        Text(
                          'Find your next home',
                          style: AppConst.body.copyWith(
                            color: Colors.white.withOpacity(0.92),
                            fontSize: 14,
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom progress + tagline
              Positioned(
                bottom: 32,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _fade,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 26,
                        width: 26,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Discover · Book · Live',
                        style: AppConst.caption.copyWith(
                          color: Colors.white.withOpacity(0.7),
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _blob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
