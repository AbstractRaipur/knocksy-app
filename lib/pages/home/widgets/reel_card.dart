import 'package:flutter/material.dart';

import '../../../const/app_const.dart';
import '../home_models.dart';
import 'card_image.dart';

/// A travel reel tile: image, top-left place chip, top-right duration, a
/// centred play button, and bottom landmark / author labels.
class ReelCard extends StatelessWidget {
  final TravelReel reel;

  const ReelCard({super.key, required this.reel});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CardImage(
            asset: reel.image,
            url: reel.imageUrl,
            seed: reel.seed,
            fallbackIcon: Icons.play_circle_outline,
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x73000000), // darken top for place / duration
                  Color(0x00000000),
                  Color(0x00000000),
                  Color(0xCC000000), // strong bottom for landmark / author
                  Color(0xF2000000),
                ],
                stops: [0.0, 0.28, 0.55, 0.85, 1.0],
              ),
            ),
          ),
          // Top row: place + duration
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    reel.place,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      shadows: [Shadow(color: Color(0x73000000), blurRadius: 6)],
                    ),
                  ),
                ),
                Text(
                  reel.duration,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 12.5,
                    shadows: [Shadow(color: Color(0x73000000), blurRadius: 6)],
                  ),
                ),
              ],
            ),
          ),
          // Centre play button
          const Center(child: _PlayButton()),
          // Bottom row: landmark + author
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    reel.landmark,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      height: 1.15,
                      shadows: [Shadow(color: Color(0x80000000), blurRadius: 6)],
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  reel.author,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.92),
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    shadows: const [Shadow(color: Color(0x80000000), blurRadius: 6)],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.play_arrow_rounded,
      color: Colors.white,
      size: 56,
      shadows: [
        Shadow(color: Color(0x66000000), blurRadius: 10),
      ],
    );
  }
}

/// The "Explore All Exciting places in the world" cell that sits in the reel
/// grid beside the last reel — text plus a circular arrow button.
class ExploreCard extends StatelessWidget {
  const ExploreCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Explore All\nExciting  places in\nthe world',
            style: AppConst.t1.copyWith(
              fontSize: 18,
              color: AppConst.appBlack,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppConst.gray, width: 1.4),
            ),
            child: const Icon(Icons.chevron_right_rounded,
                color: AppConst.appBlack, size: 26),
          ),
        ],
      ),
    );
  }
}
