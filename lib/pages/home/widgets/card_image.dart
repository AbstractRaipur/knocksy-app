import 'package:flutter/material.dart';

/// Fills its parent with an image — a network [url] if given, else a bundled
/// [asset] — with proper loading and error states:
///   * loading   → neutral shimmer skeleton (never a coloured flash)
///   * error     → neutral placeholder with [fallbackIcon]
///   * empty      → same neutral placeholder
///   * loaded    → image fades in
class CardImage extends StatelessWidget {
  final String? asset;
  final String? url;
  final int seed; // retained for API compatibility; no longer drives colour
  final IconData fallbackIcon;

  const CardImage({
    super.key,
    required this.asset,
    this.url,
    this.seed = 0,
    this.fallbackIcon = Icons.image_outlined,
  });

  @override
  Widget build(BuildContext context) {
    if (url != null && url!.isNotEmpty) {
      return Image.network(
        url!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        // Fade the decoded image in once it's ready.
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;
          return AnimatedOpacity(
            opacity: frame == null ? 0 : 1,
            duration: const Duration(milliseconds: 350),
            child: child,
          );
        },
        // Show the shimmer (filling the whole box) while bytes download.
        loadingBuilder: (context, child, progress) =>
            progress == null ? child : const _Skeleton(),
        errorBuilder: (_, __, ___) => _ErrorPlaceholder(icon: fallbackIcon),
      );
    }

    if (asset != null && asset!.isNotEmpty) {
      return Image.asset(
        asset!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        errorBuilder: (_, __, ___) => _ErrorPlaceholder(icon: fallbackIcon),
      );
    }

    return _ErrorPlaceholder(icon: fallbackIcon);
  }
}

/// Neutral placeholder shown on error / when no source is provided.
class _ErrorPlaceholder extends StatelessWidget {
  final IconData icon;
  const _ErrorPlaceholder({required this.icon});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xffECEFF1),
      child: Center(
        child: Icon(icon, color: const Color(0xffB0B8BF), size: 32),
      ),
    );
  }
}

/// Animated neutral shimmer used while an image loads.
class _Skeleton extends StatefulWidget {
  const _Skeleton();

  @override
  State<_Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<_Skeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                Color(0xffE6E9EC),
                Color(0xffF3F5F7),
                Color(0xffE6E9EC),
              ],
              stops: const [0.25, 0.5, 0.75],
              transform: _SlideGradient(_c.value),
            ),
          ),
        );
      },
    );
  }
}

/// Slides the shimmer gradient horizontally across the bounds.
class _SlideGradient extends GradientTransform {
  final double t;
  const _SlideGradient(this.t);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * (t * 2 - 1), 0, 0);
  }
}
