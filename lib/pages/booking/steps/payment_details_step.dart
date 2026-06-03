import 'package:flutter/material.dart';

import '../../../const/app_const.dart';

/// Step 3 of the booking wizard — payment details summary + discount code.
class PaymentDetailsStep extends StatefulWidget {
  const PaymentDetailsStep({super.key});

  @override
  State<PaymentDetailsStep> createState() => _PaymentDetailsStepState();
}

class _PaymentDetailsStepState extends State<PaymentDetailsStep> {
  bool _codeOpen = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      physics: AppConst.scrollPhysics,
      children: [
        Text('Payment details', style: AppConst.t2.copyWith(fontSize: 18)),
        const SizedBox(height: 12),
        Text.rich(
          TextSpan(
            style: AppConst.body.copyWith(fontSize: 13.5, height: 1.5),
            children: const [
              TextSpan(
                  text: 'Nothing will be changed',
                  style: TextStyle(fontWeight: FontWeight.w800)),
              TextSpan(
                  text: ' until the landlord accepts the booking request.',
                  style: TextStyle(color: AppConst.darkGray)),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total to pay',
                      style: AppConst.body.copyWith(
                          fontWeight: FontWeight.w700, fontSize: 16)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('€ 558',
                    style: AppConst.body.copyWith(
                        fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () {},
                  behavior: HitTestBehavior.opaque,
                  child: Text('View details',
                      style: AppConst.caption.copyWith(
                        fontSize: 12.5,
                        color: AppConst.appBlack,
                        decoration: TextDecoration.underline,
                      )),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () => setState(() => _codeOpen = !_codeOpen),
          behavior: HitTestBehavior.opaque,
          child: Row(
            children: [
              Expanded(
                child: Text('Do you have a discount or rental code?',
                    style: AppConst.body.copyWith(
                        fontSize: 13.5, color: AppConst.appBlack)),
              ),
              Icon(
                _codeOpen
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: AppConst.darkGray,
                size: 22,
              ),
            ],
          ),
        ),
        if (_codeOpen) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppConst.radius),
                    border: Border.all(color: AppConst.gray.withOpacity(0.8)),
                  ),
                  child: TextField(
                    style: AppConst.body.copyWith(fontSize: 14),
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: 'Enter code',
                      hintStyle: AppConst.body.copyWith(
                          color: AppConst.darkGray, fontSize: 14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: AppConst.primary.withOpacity(0.1),
                  foregroundColor: AppConst.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                ),
                child: Text('Apply',
                    style: AppConst.body.copyWith(
                        color: AppConst.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13)),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
