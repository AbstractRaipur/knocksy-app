import 'package:flutter/material.dart';

import '../../../const/app_const.dart';

/// Month pager for the rent status section: ‹  Rent status / Month  ›
class RentStatusSelector extends StatelessWidget {
  final String month;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const RentStatusSelector({
    super.key,
    required this.month,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: const Color(0xffF9F9F9),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _Chevron(icon: Icons.chevron_left_rounded, onTap: onPrev),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Rent status',
                    style: AppConst.caption.copyWith(
                        color: AppConst.darkGray,
                        fontSize: 11.5,
                        height: 1.1)),
                const SizedBox(height: 3),
                Text(month,
                    style: AppConst.body.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        height: 1.1)),
              ],
            ),
          ),
          _Chevron(icon: Icons.chevron_right_rounded, onTap: onNext),
        ],
      ),
    );
  }
}

class _Chevron extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _Chevron({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Icon(icon, size: 24, color: AppConst.appBlack),
      ),
    );
  }
}
