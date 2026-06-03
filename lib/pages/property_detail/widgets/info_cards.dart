import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';

import '../../../const/app_const.dart';

/// Generic icon-led card used for the three trust signals.
class TrustBadgeCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String body;
  final String? linkText;
  final VoidCallback? onLinkTap;

  const TrustBadgeCard({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.body,
    this.linkText,
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConst.radius),
        border: Border.all(color: AppConst.gray.withOpacity(0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  body,
                  style: AppConst.body.copyWith(
                    fontSize: 12.5,
                    height: 1.45,
                    color: AppConst.appBlack,
                  ),
                ),
                if (linkText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: GestureDetector(
                      onTap: onLinkTap,
                      child: Text(
                        linkText!,
                        style: AppConst.body.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppConst.primary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// "Unsure about something?" — outlined orange-tinted card with the
/// Contact-experts CTA.
class HelpCard extends StatelessWidget {
  final VoidCallback onContact;

  const HelpCard({super.key, required this.onContact});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppConst.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(AppConst.radius),
        border: Border.all(color: AppConst.primary.withOpacity(0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(FeatherIcons.helpCircle,
                  color: AppConst.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Unsure about something',
                style: AppConst.body.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'If you have any concerns or questions about this listing, '
            'we\'re here to assist.',
            style: AppConst.caption.copyWith(
              fontSize: 12,
              color: AppConst.darkGray,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: onContact,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppConst.primary, width: 1.2),
              foregroundColor: AppConst.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text(
              'Contact with our experts',
              style: AppConst.caption.copyWith(
                color: AppConst.primary,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Two-column amenities grid. Each entry is an icon + label.
class AmenitiesGrid extends StatelessWidget {
  final List<Amenity> items;

  const AmenitiesGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    // Split into two columns row-major: pairs of items per row.
    final rows = <List<Amenity>>[];
    for (var i = 0; i < items.length; i += 2) {
      rows.add(items.skip(i).take(2).toList());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows.map((pair) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(child: _AmenityCell(item: pair[0])),
              if (pair.length > 1)
                Expanded(child: _AmenityCell(item: pair[1]))
              else
                const Spacer(),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class Amenity {
  final IconData icon;
  final String label;
  const Amenity(this.icon, this.label);
}

class _AmenityCell extends StatelessWidget {
  final Amenity item;
  const _AmenityCell({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(item.icon, color: AppConst.darkGray, size: 18),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            item.label,
            style: AppConst.body.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppConst.appBlack,
            ),
          ),
        ),
      ],
    );
  }
}

/// "House Rules" — bullet list inside a soft outlined card.
class HouseRulesCard extends StatelessWidget {
  final List<String> rules;

  const HouseRulesCard({super.key, required this.rules});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConst.radius),
        border: Border.all(color: AppConst.gray.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rules.map((r) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Icon(Icons.circle, size: 6, color: AppConst.appBlack),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    r,
                    style: AppConst.body.copyWith(
                      fontSize: 12.5,
                      height: 1.45,
                      color: AppConst.appBlack,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Breadcrumb row — "Home › Dubai › Apartments for rent".
class BreadcrumbRow extends StatelessWidget {
  final List<String> parts;
  const BreadcrumbRow({super.key, required this.parts});

  @override
  Widget build(BuildContext context) {
    final spans = <InlineSpan>[];
    for (var i = 0; i < parts.length; i++) {
      final isLast = i == parts.length - 1;
      spans.add(TextSpan(
        text: parts[i],
        style: AppConst.caption.copyWith(
          fontSize: 12.5,
          fontWeight: FontWeight.w500,
          color: AppConst.appBlack,
          decoration: isLast ? TextDecoration.underline : null,
        ),
      ));
      if (!isLast) {
        spans.add(TextSpan(
          text: ' > ',
          style: AppConst.caption.copyWith(
            color: AppConst.darkGray,
            fontSize: 12.5,
          ),
        ));
      }
    }
    return RichText(text: TextSpan(children: spans));
  }
}
