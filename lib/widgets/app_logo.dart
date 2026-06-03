import 'package:flutter/material.dart';

import '../const/app_assets.dart';

/// Knocksy wordmark — the official `knocksy_logo.png` asset rendered at a
/// caller-controlled height. Width derives from the asset's native aspect
/// (~3:1) via [BoxFit.contain].
///
/// The asset ships as white-on-transparent, which matches the most common
/// use case (overlaid on the orange brand band). Pass [color] to tint to a
/// different colour — handy when the wordmark sits on a light surface.
///
/// [stacked] is kept for API compatibility with earlier callers that
/// expected a column layout; it currently has no visual effect since the
/// asset already contains the glyph + wordmark composition.
class KnocksyWordmark extends StatelessWidget {
  /// Logical-pixel cap height of the wordmark. Drives the rendered size.
  final double height;
  final Color color;
  // ignore: unused_element_parameter
  final bool stacked;

  const KnocksyWordmark({
    super.key,
    this.height = 56,
    this.color = Colors.white,
    this.stacked = false,
  });

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      AppAssets.logo,
      height: height,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => SizedBox(height: height),
    );

    // White is the asset's native colour, so no tint needed in that case.
    if (color == Colors.white) return image;

    return ColorFiltered(
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      child: image,
    );
  }
}
