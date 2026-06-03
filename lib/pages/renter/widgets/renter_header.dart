import 'package:flutter/material.dart';

import '../../../const/app_const.dart';
import '../../home/home_models.dart';
import '../../home/widgets/card_image.dart';
import '../renter_models.dart';

/// Orange header with rounded bottom corners: greeting row + the white
/// "Your Property" summary card with the Pay-your-rent CTA.
class RenterHeader extends StatelessWidget {
  final VoidCallback onPayRent;

  const RenterHeader({super.key, required this.onPayRent});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppConst.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 18),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: _GreetingRow(),
              ),
              const SizedBox(height: 18),
              _YourPropertyCard(onPayRent: onPayRent),
            ],
          ),
        ),
      ),
    );
  }
}

class _GreetingRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.25),
            border: Border.all(color: Colors.white, width: 1.5),
          ),
          alignment: Alignment.center,
          child: Text(
            RenterMockData.userName.substring(0, 1),
            style: AppConst.t2.copyWith(color: Colors.white),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Hi ${RenterMockData.userName}',
          style: AppConst.t1.copyWith(color: Colors.white, fontSize: 22),
        ),
        const Spacer(),
        const Icon(Icons.notifications_none, color: Colors.white, size: 26),
      ],
    );
  }
}

class _YourPropertyCard extends StatelessWidget {
  final VoidCallback onPayRent;

  const _YourPropertyCard({required this.onPayRent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [AppConst.softShadow],
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
                    Text('Your Property',
                        style: AppConst.caption.copyWith(
                            color: AppConst.darkGray, fontSize: 12)),
                    const SizedBox(height: 4),
                    Text(RenterMockData.propertyName,
                        style: AppConst.t2.copyWith(fontSize: 17)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(RenterMockData.unit,
                            style: AppConst.body.copyWith(
                                fontWeight: FontWeight.w700, fontSize: 12.5)),
                        const SizedBox(width: 12),
                        Text(RenterMockData.street,
                            style: AppConst.caption.copyWith(
                                color: AppConst.darkGray, fontSize: 12.5)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: const SizedBox(
                  width: 88,
                  height: 88,
                  child: CardImage(
                    asset: null,
                    url: HomeMockData.propertyPhoto,
                    fallbackIcon: Icons.chair_outlined,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, thickness: 1, color: AppConst.lightGray),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Expanded(
                flex: 5,
                child: _Stat(label: 'Net Rent', value: '€ 100'),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 7,
                child: _Stat(label: 'Net Deposit Amount', value: '€ 100'),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 6,
                child: _Stat(label: 'Contract Ends', value: '21 Dec 2028'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              onPressed: onPayRent,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppConst.primary, width: 1.4),
                foregroundColor: AppConst.appBlack,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 11),
              ),
              child: Text(
                'Pay your rent',
                style: AppConst.body.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppConst.appBlack,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;

  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppConst.caption
                .copyWith(color: AppConst.darkGray, fontSize: 11.5, height: 1.2)),
        const SizedBox(height: 6),
        Text(value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppConst.body
                .copyWith(fontWeight: FontWeight.w700, fontSize: 15)),
      ],
    );
  }
}
