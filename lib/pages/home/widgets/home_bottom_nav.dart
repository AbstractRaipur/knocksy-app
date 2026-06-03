import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../const/app_assets.dart';
import '../../../const/app_const.dart';

/// Bottom navigation bar — Home (active), Explore grid, Chat, Profile.
///
/// Each icon is a single SVG tinted at runtime: dark when selected, grey
/// otherwise (no separate selected/unselected files).
class HomeBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const HomeBottomNav({
    super.key,
    this.currentIndex = 0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                svgAsset: AppAssets.navHome,
                fallbackIcon: Icons.home_filled,
                active: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                svgAsset: AppAssets.navExplore,
                fallbackIcon: Icons.grid_view_rounded,
                active: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _NavItem(
                svgAsset: AppAssets.navChat,
                fallbackIcon: Icons.chat_bubble_outline_rounded,
                active: currentIndex == 2,
                onTap: () => onTap(2),
              ),
              _NavItem(
                svgAsset: AppAssets.navProfile,
                fallbackIcon: Icons.person_outline_rounded,
                active: currentIndex == 3,
                onTap: () => onTap(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String svgAsset;
  final IconData fallbackIcon;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({
    required this.svgAsset,
    required this.fallbackIcon,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? AppConst.appBlack : AppConst.darkGray;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            svgAsset,
            width: 26,
            height: 26,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            placeholderBuilder: (_) => Icon(fallbackIcon, color: color, size: 26),
          ),
          const SizedBox(height: 6),
          Container(
            width: 18,
            height: 3,
            decoration: BoxDecoration(
              color: active ? AppConst.appBlack : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
