import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';

import '../../../const/app_const.dart';
import '../../home/widgets/card_image.dart';

/// Top image carousel for the property detail page.
///
/// When [imageUrls] is non-empty, renders real network images (Azure SAS
/// URLs). Falls back to gradient placeholder tiles when the list is empty
/// (loading state or no photos yet).
class HeroCarousel extends StatefulWidget {
  final List<String> imageUrls;
  final VoidCallback onBack;

  const HeroCarousel({
    super.key,
    this.imageUrls = const [],
    this.placeholderCount = 4,
    this.totalPhotos,
    required this.onBack,
  });

  /// Number of gradient placeholder pages when [imageUrls] is empty.
  final int placeholderCount;

  /// Optional override for the "x/N" counter denominator (e.g. show 18
  /// total photos while only a few placeholders are paged).
  final int? totalPhotos;

  @override
  State<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int get _count => widget.imageUrls.isEmpty
      ? widget.placeholderCount
      : widget.imageUrls.length;

  int get _counterTotal => widget.totalPhotos ?? _count;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final h = (size.height * 0.34).clamp(220.0, 320.0);
    final count = _count;

    return SizedBox(
      height: h,
      child: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: count,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (_, i) => CardImage(
              asset: null,
              url: widget.imageUrls.isNotEmpty ? widget.imageUrls[i] : null,
              fallbackIcon: FeatherIcons.home,
            ),
          ),
          // Back button — plain chevron (no circle), per design.
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 10,
            child: GestureDetector(
              onTap: widget.onBack,
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 38,
                width: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  FeatherIcons.chevronLeft,
                  size: 22,
                  color: AppConst.appBlack,
                ),
              ),
            ),
          ),
          // Counter pill — corner-anchored at its natural width.
          Positioned(
            bottom: 12,
            right: 12,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.55),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(FeatherIcons.image,
                      color: Colors.white, size: 13),
                  const SizedBox(width: 5),
                  Text(
                    '${_index + 1}/$_counterTotal',
                    style: AppConst.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Page indicator dots — truly centred across the full width.
          Positioned(
            left: 0,
            right: 0,
            bottom: 21,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  count > 6 ? 6 : count,
                  (i) {
                    final active =
                        i == (_index >= 6 ? 5 : _index).clamp(0, 5);
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      height: 6,
                      width: active ? 18 : 6,
                      decoration: BoxDecoration(
                        color: active
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

