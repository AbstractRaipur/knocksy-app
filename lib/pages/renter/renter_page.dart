import 'package:flutter/material.dart';

import '../../const/app_const.dart';
import '../../utils/app_navigator.dart';
import '../payment/payment_summary_page.dart';
import 'renter_models.dart';
import 'widgets/quick_actions.dart';
import 'widgets/rent_status_selector.dart';
import 'widgets/renter_header.dart';
import 'widgets/transaction_card.dart';

/// Renter dashboard tab — matches the Figma reference: orange header with the
/// "Your Property" card, Quick Actions, a rent-status month pager, and the
/// Transactions feed with Paid / Overdue / Pending tabs. Static mock data
/// ([RenterMockData]); the bottom nav is owned by [MainShell].
class RenterPage extends StatefulWidget {
  const RenterPage({super.key});

  @override
  State<RenterPage> createState() => _RenterPageState();
}

class _RenterPageState extends State<RenterPage> {
  int _tab = 0; // 0 Paid, 1 Overdue, 2 Pending

  void _noop() {}

  @override
  Widget build(BuildContext context) {
    // Figma gutters: panels (QA, rent status) sit at a 12px gutter; the
    // transactions block (heading, tabs, cards) sits at a 20px gutter.
    const pad12 = EdgeInsets.symmetric(horizontal: 12);
    const pad20 = EdgeInsets.symmetric(horizontal: 20);

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.zero,
        physics: AppConst.scrollPhysics,
        children: [
          RenterHeader(
            onPayRent: () => AppNavigator.navigateTo(
              context,
              const PaymentSummaryPage(),
            ),
          ),
          const SizedBox(height: 22),

          const Padding(
            padding: pad12,
            child: _SectionTitle('Quick Actions'),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: pad12,
            child: QuickActions(onTap: (_) => _noop()),
          ),
          const SizedBox(height: 18),

          Padding(
            padding: pad12,
            child: RentStatusSelector(
              month: RenterMockData.rentStatusMonth,
              onPrev: _noop,
              onNext: _noop,
            ),
          ),
          const SizedBox(height: 24),

          Padding(
            padding: pad20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const _SectionTitle('Transactions'),
                const Spacer(),
                Text(
                  '${RenterMockData.totalTransactions} transactions',
                  style: AppConst.caption.copyWith(
                    color: AppConst.darkGray,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Padding(
            padding: pad20,
            child: _StatusTabs(
              selected: _tab,
              paidCount: RenterMockData.paidCount,
              onChanged: (i) => setState(() => _tab = i),
            ),
          ),
          const SizedBox(height: 20),

          // The mock feed shows the recent transactions regardless of tab;
          // wire real filtering to [_tab] once the backend lands.
          for (final t in RenterMockData.transactions) ...[
            Padding(
              padding: pad20,
              child: TransactionCard(txn: t),
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppConst.t2.copyWith(fontSize: 18, color: AppConst.appBlack),
    );
  }
}

class _StatusTabs extends StatelessWidget {
  final int selected;
  final int paidCount;
  final ValueChanged<int> onChanged;

  const _StatusTabs({
    required this.selected,
    required this.paidCount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Tab(
          label: 'Paid',
          badge: paidCount,
          active: selected == 0,
          onTap: () => onChanged(0),
        ),
        const SizedBox(width: 28),
        _Tab(
          label: 'Overdue',
          active: selected == 1,
          onTap: () => onChanged(1),
        ),
        const SizedBox(width: 28),
        _Tab(
          label: 'Pending',
          active: selected == 2,
          onTap: () => onChanged(2),
        ),
      ],
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final int? badge;
  final bool active;
  final VoidCallback onTap;

  const _Tab({
    required this.label,
    this.badge,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: IntrinsicWidth(
        child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppConst.body.copyWith(
                  fontSize: 15,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  color: active ? AppConst.appBlack : AppConst.darkGray,
                ),
              ),
              if (badge != null) ...[
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppConst.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$badge',
                    style: AppConst.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Container(
            height: 2.5,
            decoration: BoxDecoration(
              color: active ? AppConst.appBlack : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
        ),
      ),
    );
  }
}
