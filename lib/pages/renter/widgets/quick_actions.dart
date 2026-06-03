import 'package:flutter/material.dart';

import '../../../const/app_assets.dart';
import '../../../const/app_const.dart';

/// "Quick Actions" — three icon tiles (Invoices / Transactions / Documents)
/// inside a soft rounded panel.
class QuickActions extends StatelessWidget {
  final ValueChanged<String> onTap;

  const QuickActions({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 117,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xffFAFAFA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ActionTile(
              asset: AppAssets.qaInvoices,
              fallbackIcon: Icons.receipt_long,
              fallbackColor: Color(0xff2EBD85),
              label: 'Invoices',
              onTap: () => onTap('invoices'),
            ),
          ),
          Expanded(
            child: _ActionTile(
              asset: AppAssets.qaTransactions,
              fallbackIcon: Icons.account_balance_wallet,
              fallbackColor: Color(0xffF5A623),
              label: 'Transactions',
              onTap: () => onTap('transactions'),
            ),
          ),
          Expanded(
            child: _ActionTile(
              asset: AppAssets.qaDocuments,
              fallbackIcon: Icons.description,
              fallbackColor: Color(0xff2A86E0),
              label: 'Documents',
              onTap: () => onTap('documents'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String asset;
  final IconData fallbackIcon;
  final Color fallbackColor;
  final String label;
  final VoidCallback onTap;

  const _ActionTile({
    required this.asset,
    required this.fallbackIcon,
    required this.fallbackColor,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 38,
            width: 38,
            child: Image.asset(
              asset,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Container(
                decoration: BoxDecoration(
                  color: fallbackColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(fallbackIcon, color: fallbackColor, size: 22),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: AppConst.body.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppConst.appBlack,
            ),
          ),
        ],
      ),
    );
  }
}
