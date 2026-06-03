import 'package:flutter/material.dart';

import '../../../const/app_const.dart';
import '../renter_models.dart';

/// One rent transaction row: property + tenant, amount, date and a status chip.
class TransactionCard extends StatelessWidget {
  final RentTransaction txn;

  const TransactionCard({super.key, required this.txn});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppConst.gray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      txn.property,
                      style: AppConst.body.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: AppConst.appBlack,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      txn.tenant,
                      style: AppConst.caption.copyWith(
                        fontSize: 12,
                        color: AppConst.darkGray,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.more_horiz, color: AppConst.darkGray, size: 22),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      RenterMockData.formatAmount(txn.amount),
                      style: AppConst.t1.copyWith(fontSize: 26),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      txn.dateLabel,
                      style: AppConst.caption.copyWith(
                        fontSize: 12,
                        color: AppConst.darkGray,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusChip(status: txn.status),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final TxnStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    late final Color bg;
    late final String label;
    late final IconData icon;
    switch (status) {
      case TxnStatus.paid:
        bg = AppConst.success;
        label = 'Paid';
        icon = Icons.check_circle;
        break;
      case TxnStatus.overdue:
        bg = AppConst.errorColor;
        label = 'Overdue';
        icon = Icons.error;
        break;
      case TxnStatus.pending:
        bg = AppConst.warning;
        label = 'Pending';
        icon = Icons.error;
        break;
    }

    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppConst.body.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
