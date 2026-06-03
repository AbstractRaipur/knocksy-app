import 'package:flutter/material.dart';

import '../../const/app_assets.dart';
import '../../const/app_const.dart';
import '../../utils/app_navigator.dart';
import '../../widgets/app_logo.dart';
import '../booking/booking_wizard_page.dart';

/// One line in the "Through Knocksy" breakdown.
class PaymentLineItem {
  final String title;
  final String? fromDate;
  final String? toDate;
  final bool showInfo;
  final String amount;

  const PaymentLineItem({
    required this.title,
    this.fromDate,
    this.toDate,
    this.showInfo = false,
    required this.amount,
  });
}

/// Payment Summary — shared by the renter "Pay your rent" flow and the
/// property booking flow. Static mock content matching the Figma reference;
/// dates/total/breakdown are parameterised.
class PaymentSummaryPage extends StatefulWidget {
  final String fromLabel;
  final String toLabel;
  final String total;
  final List<PaymentLineItem> items;

  /// When true, Continue starts the booking wizard; otherwise it just closes.
  final bool isBooking;

  const PaymentSummaryPage({
    super.key,
    this.fromLabel = '01 Aug 2025',
    this.toLabel = '31 Aug 2025',
    this.total = '€ 558',
    this.isBooking = false,
    this.items = const [
      PaymentLineItem(
        title: 'August Month Rent',
        fromDate: '01 Aug 2025',
        toDate: '31 Aug 2025',
        amount: '€ 558',
      ),
    ],
  });

  /// Variant used by the property booking flow.
  const PaymentSummaryPage.booking({super.key})
      : fromLabel = '10 Aug 2025',
        toLabel = '27 Oct 2025',
        total = '€ 558',
        isBooking = true,
        items = const [
          PaymentLineItem(
            title: 'First payment(31 days)',
            fromDate: '08 Oct 2025',
            toDate: '27 Oct 2025',
            amount: '€ 448',
          ),
          PaymentLineItem(
            title: 'Tenant Protection Fees',
            showInfo: true,
            amount: '€ 100',
          ),
        ];

  @override
  State<PaymentSummaryPage> createState() => _PaymentSummaryPageState();
}

class _PaymentSummaryPageState extends State<PaymentSummaryPage> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _ContinueBar(
        onContinue: () {
          if (widget.isBooking) {
            AppNavigator.navigateTo(context, const BookingWizardPage());
          } else {
            Navigator.of(context).maybePop();
          }
        },
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title bar — back button (left) + centered title.
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 12),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).maybePop(),
                      behavior: HitTestBehavior.opaque,
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.chevron_left_rounded,
                            size: 28, color: AppConst.appBlack),
                      ),
                    ),
                  ),
                  Text(
                    'Payment Summary',
                    style: AppConst.t2.copyWith(
                      color: AppConst.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: AppConst.lightGray),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                physics: AppConst.scrollPhysics,
                children: [
                  _FromToCard(
                    fromLabel: widget.fromLabel,
                    toLabel: widget.toLabel,
                  ),
                  const SizedBox(height: 16),
                  _ThroughCard(
                    expanded: _expanded,
                    total: widget.total,
                    items: widget.items,
                    onToggle: () => setState(() => _expanded = !_expanded),
                  ),
                  const SizedBox(height: 16),
                  const _GuaranteesCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------- From / To
class _FromToCard extends StatelessWidget {
  final String fromLabel;
  final String toLabel;

  const _FromToCard({required this.fromLabel, required this.toLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConst.radius),
        border: Border.all(color: AppConst.primary, width: 1.4),
      ),
      child: Row(
        children: [
          _DateBlock(
            label: 'From',
            value: fromLabel,
            align: CrossAxisAlignment.start,
          ),
          Expanded(
            child: Text(
              '-.-',
              textAlign: TextAlign.center,
              style: AppConst.body.copyWith(color: AppConst.darkGray),
            ),
          ),
          _DateBlock(
            label: 'To',
            value: toLabel,
            align: CrossAxisAlignment.end,
          ),
        ],
      ),
    );
  }
}

class _DateBlock extends StatelessWidget {
  final String label;
  final String value;
  final CrossAxisAlignment align;

  const _DateBlock({
    required this.label,
    required this.value,
    required this.align,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: align,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label,
            style: AppConst.body
                .copyWith(fontWeight: FontWeight.w700, fontSize: 15)),
        const SizedBox(height: 6),
        Text(value,
            style: AppConst.body.copyWith(
                color: AppConst.primary,
                fontWeight: FontWeight.w600,
                fontSize: 15)),
      ],
    );
  }
}

// -------------------------------------------------------------- Through card
class _ThroughCard extends StatelessWidget {
  final bool expanded;
  final String total;
  final List<PaymentLineItem> items;
  final VoidCallback onToggle;

  const _ThroughCard({
    required this.expanded,
    required this.total,
    required this.items,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConst.radius),
        border: Border.all(color: AppConst.gray.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Through',
                  style: AppConst.body.copyWith(
                      fontWeight: FontWeight.w700, fontSize: 14)),
              const SizedBox(width: 8),
              KnocksyWordmark(height: 20, color: AppConst.primary),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Via Credit Card or Paypal',
                  style: AppConst.body
                      .copyWith(fontSize: 13.5, color: AppConst.appBlack),
                ),
              ),
              const _PayMethods(),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onToggle,
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Total to pay per booking request',
                    style: AppConst.body
                        .copyWith(fontSize: 13.5, color: AppConst.appBlack),
                  ),
                ),
                Text(total,
                    style: AppConst.body.copyWith(
                        fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(width: 6),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: AppConst.darkGray,
                ),
              ],
            ),
          ),
          if (expanded) ...[
            const SizedBox(height: 12),
            const Divider(height: 1, thickness: 1, color: AppConst.lightGray),
            const SizedBox(height: 12),
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0) const SizedBox(height: 12),
              _LineItemRow(item: items[i]),
            ],
          ],
        ],
      ),
    );
  }
}

class _LineItemRow extends StatelessWidget {
  final PaymentLineItem item;

  const _LineItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(item.title,
                        style: AppConst.body.copyWith(
                            fontSize: 13.5, color: AppConst.appBlack)),
                  ),
                  if (item.showInfo) ...[
                    const SizedBox(width: 6),
                    const Icon(Icons.info_outline,
                        size: 15, color: AppConst.darkGray),
                  ],
                ],
              ),
              if (item.fromDate != null && item.toDate != null) ...[
                const SizedBox(height: 2),
                Text.rich(
                  TextSpan(
                    style: AppConst.caption.copyWith(
                        fontSize: 11.5, color: AppConst.darkGray),
                    children: [
                      const TextSpan(text: 'From '),
                      TextSpan(
                          text: item.fromDate,
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      const TextSpan(text: ' to '),
                      TextSpan(
                          text: item.toDate,
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(item.amount,
            style: AppConst.body
                .copyWith(fontWeight: FontWeight.w600, fontSize: 14)),
      ],
    );
  }
}

class _PayMethods extends StatelessWidget {
  const _PayMethods();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.payMethods,
      height: 22,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          _PayChip(label: 'Pay', bg: Color(0xff003087), fg: Colors.white),
          SizedBox(width: 6),
          _PayChip(label: 'MC', bg: Color(0xffEB001B), fg: Colors.white),
          SizedBox(width: 6),
          _PayChip(label: 'VISA', bg: Color(0xff1A1F71), fg: Colors.white),
        ],
      ),
    );
  }
}

class _PayChip extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;

  const _PayChip({required this.label, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ------------------------------------------------------------ Guarantees card
class _GuaranteesCard extends StatelessWidget {
  const _GuaranteesCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConst.radius),
        border: Border.all(color: AppConst.gray.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Knocksy Guarantees',
              style: AppConst.body
                  .copyWith(fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 16),
          _GuaranteeRow(
            asset: AppAssets.guaranteeShield,
            fallbackIcon: Icons.verified_user,
            fallbackColor: AppConst.success,
            imageOnRight: true,
            title: 'Fraud Protection',
            body: 'Your rent is transferred to the landlord only after '
                'you\'ve moved in.',
          ),
          const SizedBox(height: 18),
          _GuaranteeRow(
            asset: AppAssets.guaranteeVerified,
            fallbackIcon: Icons.phonelink_ring,
            fallbackColor: AppConst.accent,
            imageOnRight: false,
            title: 'Verified Listings',
            body: 'All properties are checked to ensure they match their '
                'descriptions.',
          ),
        ],
      ),
    );
  }
}

class _GuaranteeRow extends StatelessWidget {
  final String asset;
  final IconData fallbackIcon;
  final Color fallbackColor;
  final bool imageOnRight;
  final String title;
  final String body;

  const _GuaranteeRow({
    required this.asset,
    required this.fallbackIcon,
    required this.fallbackColor,
    required this.imageOnRight,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final illustration = SizedBox(
      width: 92,
      height: 78,
      child: Image.asset(
        asset,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Center(
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: fallbackColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(fallbackIcon, color: fallbackColor, size: 30),
          ),
        ),
      ),
    );

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: AppConst.body
                .copyWith(fontWeight: FontWeight.w700, fontSize: 14)),
        const SizedBox(height: 4),
        Text(
          body,
          style: AppConst.caption.copyWith(
            fontSize: 12,
            color: AppConst.darkGray,
            height: 1.45,
          ),
        ),
      ],
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: imageOnRight
          ? [Expanded(child: text), const SizedBox(width: 12), illustration]
          : [illustration, const SizedBox(width: 12), Expanded(child: text)],
    );
  }
}

// ----------------------------------------------------------------- Continue
class _ContinueBar extends StatelessWidget {
  final VoidCallback onContinue;

  const _ContinueBar({required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConst.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Continue',
                style: AppConst.body.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
