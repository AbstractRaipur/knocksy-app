import 'package:flutter/material.dart';

import '../../const/app_assets.dart';
import '../../const/app_const.dart';
import 'steps/payment_details_step.dart';
import 'steps/personal_details_step.dart';
import 'steps/rental_details_step.dart';

/// Three-step booking request wizard: Personal → Rental → Payment details,
/// ending in a "Congratulations" confirmation. Reached after the booking
/// payment summary.
class BookingWizardPage extends StatefulWidget {
  const BookingWizardPage({super.key});

  @override
  State<BookingWizardPage> createState() => _BookingWizardPageState();
}

class _BookingWizardPageState extends State<BookingWizardPage> {
  int _step = 0;

  static const _titles = ['Personal details', 'Rental details', 'Payment details'];

  void _back() {
    if (_step > 0) {
      setState(() => _step--);
    } else {
      Navigator.of(context).maybePop();
    }
  }

  void _continue() {
    if (_step < 2) {
      setState(() => _step++);
    } else {
      _showCongrats();
    }
  }

  Future<void> _showCongrats() async {
    await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (_) => const _CongratsDialog(),
    );
    if (!mounted) return;
    // Return to the app root (close the whole booking flow).
    Navigator.of(context).popUntil((r) => r.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _BottomBar(
        showSecurePayment: _step == 2,
        onContinue: _continue,
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _StepBar(step: _step, titles: _titles, onBack: _back),
            const Divider(height: 1, thickness: 1, color: AppConst.lightGray),
            Expanded(
              child: IndexedStack(
                index: _step,
                children: const [
                  PersonalDetailsStep(),
                  RentalDetailsStep(),
                  PaymentDetailsStep(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------ Step bar
class _StepBar extends StatelessWidget {
  final int step;
  final List<String> titles;
  final VoidCallback onBack;

  const _StepBar(
      {required this.step, required this.titles, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];
    for (var i = 0; i < 3; i++) {
      items.add(_StepDot(index: i, current: step));
      if (i == step) {
        items.add(const SizedBox(width: 8));
        items.add(Flexible(
          child: Text(
            titles[i],
            overflow: TextOverflow.ellipsis,
            style: AppConst.body.copyWith(
                fontWeight: FontWeight.w700, fontSize: 15),
          ),
        ));
      }
      if (i != 2) items.add(const SizedBox(width: 14));
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 16, 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            behavior: HitTestBehavior.opaque,
            child: const Icon(Icons.chevron_left_rounded,
                size: 28, color: AppConst.appBlack),
          ),
          const SizedBox(width: 6),
          ...items,
        ],
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  final int index;
  final int current;

  const _StepDot({required this.index, required this.current});

  @override
  Widget build(BuildContext context) {
    final done = index < current;
    final active = index == current;
    final filled = done || active;

    return Container(
      width: 26,
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? AppConst.primary : Colors.white,
        border: Border.all(
          color: filled ? AppConst.primary : AppConst.gray,
          width: 1.5,
        ),
      ),
      child: done
          ? const Icon(Icons.check, size: 15, color: Colors.white)
          : Text(
              '${index + 1}',
              style: AppConst.caption.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: active ? Colors.white : AppConst.darkGray,
              ),
            ),
    );
  }
}

// ------------------------------------------------------------------ Bottom bar
class _BottomBar extends StatelessWidget {
  final bool showSecurePayment;
  final VoidCallback onContinue;

  const _BottomBar(
      {required this.showSecurePayment, required this.onContinue});

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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showSecurePayment) ...[
                Row(
                  children: [
                    const Icon(Icons.lock_outline,
                        size: 20, color: AppConst.appBlack),
                    const SizedBox(width: 8),
                    Text('Secure Payment',
                        style: AppConst.body.copyWith(
                            fontWeight: FontWeight.w700, fontSize: 14)),
                    const Spacer(),
                    const _PayChips(),
                  ],
                ),
                const SizedBox(height: 12),
              ],
              SizedBox(
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
                  child: Text('Continue',
                      style: AppConst.body.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PayChips extends StatelessWidget {
  const _PayChips();

  @override
  Widget build(BuildContext context) {
    Widget chip(String t, Color c) => Container(
          margin: const EdgeInsets.only(left: 6),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration:
              BoxDecoration(color: c, borderRadius: BorderRadius.circular(4)),
          child: Text(t,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w800)),
        );
    return Image.asset(
      AppAssets.payMethods,
      height: 22,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          chip('Pay', const Color(0xff003087)),
          chip('MC', const Color(0xffEB001B)),
          chip('VISA', const Color(0xff1A1F71)),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------ Congrats
class _CongratsDialog extends StatelessWidget {
  const _CongratsDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Congratulations !', style: AppConst.t1.copyWith(fontSize: 22)),
            const SizedBox(height: 14),
            Text('Your stay is officially booked.',
                textAlign: TextAlign.center,
                style: AppConst.body
                    .copyWith(fontWeight: FontWeight.w700, fontSize: 14.5)),
            const SizedBox(height: 12),
            Text(
              'Get ready to make memories at your new home away from home. '
              'You can now connect with your property manager or check your '
              'stay details below.',
              textAlign: TextAlign.center,
              style: AppConst.caption.copyWith(
                fontSize: 12.5,
                color: AppConst.darkGray,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).maybePop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConst.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text('Continue',
                    style: AppConst.body.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15)),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.sync_rounded,
                    size: 15, color: AppConst.darkGray.withOpacity(0.8)),
                const SizedBox(width: 6),
                Text("Waiting for the landlord's Approval",
                    style: AppConst.caption.copyWith(
                        fontSize: 12, color: AppConst.darkGray)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
