import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../const/app_assets.dart';
import '../../../const/app_const.dart';
import '../home_models.dart';

/// Orange brand header: greeting row (avatar + "Hi Sara" + bell) and the
/// outlined search-by-location card (transparent fill, white border + text)
/// holding the move-in / move-out dates — matching the Figma reference.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: AppConst.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Knocksy brand watermark (SVG, native colours), bottom-right.
            Positioned(
              right: 0,
              bottom: 0,
              child: Opacity(
                opacity: 0.5,
                child: SvgPicture.asset(
                  AppAssets.kIconSvg,
                  width: 64,
                  height: 64,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _GreetingRow(),
                  SizedBox(height: 18),
                  _SearchCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GreetingRow extends StatelessWidget {
  const _GreetingRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.25),
            border: Border.all(color: Colors.white, width: 1.5),
          ),
          clipBehavior: Clip.antiAlias,
          alignment: Alignment.center,
          child: Image.network(
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&q=60&auto=format&fit=crop',
            fit: BoxFit.cover,
            width: 46,
            height: 46,
            errorBuilder: (_, __, ___) => Center(
              child: Text(
                HomeMockData.userName.substring(0, 1),
                style: AppConst.t2.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Text(
          'Hi ${HomeMockData.userName}',
          style: AppConst.t1.copyWith(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        const Icon(Icons.notifications_none, color: Colors.white, size: 28),
      ],
    );
  }
}

class _SearchCard extends StatelessWidget {
  const _SearchCard();

  static const _line = Color(0x66FFFFFF); // semi-transparent white divider

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConst.radius),
        border: Border.all(color: Colors.white, width: 1.4),
      ),
      child: Column(
        children: [
          // Search by location
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Search by location',
                    style: AppConst.body.copyWith(
                        color: Colors.white.withOpacity(0.85), fontSize: 13)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.search_rounded,
                        color: Colors.white, size: 22),
                    const SizedBox(width: 10),
                    Text(
                      HomeMockData.searchLocation,
                      style: AppConst.t2.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: _line),
          // Move-in / move-out dates
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _DateCell(
                    label: 'Move in date',
                    value: HomeMockData.moveInDate,
                  ),
                ),
                const VerticalDivider(width: 1, thickness: 1, color: _line),
                Expanded(
                  child: _DateCell(
                    label: 'Move out date',
                    value: HomeMockData.moveOutDate,
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

class _DateCell extends StatelessWidget {
  final String label;
  final String value;

  const _DateCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        children: [
          const Icon(Icons.calendar_today_outlined,
              color: Colors.white, size: 18),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label,
                  style: AppConst.body.copyWith(
                      color: Colors.white.withOpacity(0.85), fontSize: 12.5)),
              const SizedBox(height: 4),
              Text(value,
                  style: AppConst.body.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}
