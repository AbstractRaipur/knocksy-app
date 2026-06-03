import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';

import '../../../const/app_const.dart';

/// One numbered/colored card in the "4 Easy Steps" stack.
class BookingStepCard extends StatelessWidget {
  final IconData icon;
  final Color background;
  final Color iconColor;
  final String title;
  final String subtitle;
  final List<BookingBullet> bullets;

  const BookingStepCard({
    super.key,
    required this.icon,
    required this.background,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.bullets,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppConst.radius),
        boxShadow: const [AppConst.softShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 34,
                width: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: iconColor,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: AppConst.t2.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: AppConst.caption.copyWith(
              fontSize: 12,
              color: AppConst.appBlack,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 10),
          ...bullets.map((b) => _BulletRow(spans: [
                TextSpan(
                  text: '${b.label} ',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(text: '- ${b.description}'),
              ])),
        ],
      ),
    );
  }
}

/// One bullet inside a step card — bold label followed by an explanation.
class BookingBullet {
  final String label;
  final String description;
  const BookingBullet({required this.label, required this.description});
}

/// Shared row used by both step-card bullets and cancellation rules:
/// small grey dot + caller-supplied rich text.
class _BulletRow extends StatelessWidget {
  final List<InlineSpan> spans;
  const _BulletRow({required this.spans});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 5, color: AppConst.darkGray),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: AppConst.caption.copyWith(
                  fontSize: 11.5,
                  height: 1.5,
                  color: AppConst.appBlack,
                ),
                children: spans,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Cancellation policy card — heading + rule list.
class CancellationPolicyCard extends StatelessWidget {
  final String policyName;
  final List<CancellationRule> rules;

  const CancellationPolicyCard({
    super.key,
    this.policyName = 'Strict cancellation',
    required this.rules,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffFDEDE7),
        borderRadius: BorderRadius.circular(AppConst.radius),
        border: Border.all(color: AppConst.primary.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 34,
                width: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xffEF6C57),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(FeatherIcons.alertCircle,
                    color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                policyName,
                style: AppConst.body.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'If you cancel:',
            style: AppConst.caption.copyWith(
              color: AppConst.appBlack,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          ...rules.map((r) => _BulletRow(spans: [
                TextSpan(text: '${r.when} — '),
                TextSpan(
                  text: r.refund,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ])),
        ],
      ),
    );
  }
}

class CancellationRule {
  final String when;
  final String refund;
  const CancellationRule({required this.when, required this.refund});
}
