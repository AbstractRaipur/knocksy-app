import 'package:flutter/material.dart';

import '../../../const/app_const.dart';

/// White rounded bar with "Filters" and "Sort by", split by a short orange
/// divider — overlaps the bottom of the orange header in the Figma design.
class FilterSortBar extends StatelessWidget {
  final VoidCallback? onFilters;
  final VoidCallback? onSort;

  const FilterSortBar({super.key, this.onFilters, this.onSort});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _BarItem(
              icon: Icons.tune_rounded,
              label: 'Filters',
              onTap: onFilters,
            ),
          ),
          Container(
            width: 2,
            height: 22,
            decoration: BoxDecoration(
              color: AppConst.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: _BarItem(
              icon: Icons.swap_vert_rounded,
              label: 'Sort by',
              trailingIcon: true,
              onTap: onSort,
            ),
          ),
        ],
      ),
    );
  }
}

class _BarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool trailingIcon;
  final VoidCallback? onTap;

  const _BarItem({
    required this.icon,
    required this.label,
    this.trailingIcon = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final text = Text(
      label,
      style: AppConst.body.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: AppConst.appBlack,
      ),
    );
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        if (!trailingIcon) ...[
          Icon(icon, size: 20, color: AppConst.appBlack),
          const SizedBox(width: 8),
          text,
        ] else ...[
          text,
          const SizedBox(width: 8),
          Icon(icon, size: 20, color: AppConst.appBlack),
        ],
        ],
      ),
    );
  }
}
