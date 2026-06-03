import 'package:flutter/material.dart';

import '../../../const/app_const.dart';
import '../../home/home_models.dart';
import '../../home/widgets/card_image.dart';

/// Inline "Chat" text link + orange "k" mark (sits under the cancellation
/// policy card), matching the Figma reference.
class ChatActionRow extends StatelessWidget {
  final VoidCallback onChat;
  final VoidCallback onKnocksy;

  const ChatActionRow({
    super.key,
    required this.onChat,
    required this.onKnocksy,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: onChat,
          behavior: HitTestBehavior.opaque,
          child: Text(
            'Chat',
            style: AppConst.body.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: AppConst.appBlack,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        GestureDetector(
          onTap: onKnocksy,
          child: Container(
            height: 40,
            width: 40,
            decoration: const BoxDecoration(
              color: AppConst.primary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text(
              'k',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// "Payment details" — heading + explanatory copy + underlined View Payments.
class PaymentDetailsRow extends StatelessWidget {
  final VoidCallback onViewPayments;

  const PaymentDetailsRow({super.key, required this.onViewPayments});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment details',
          style: AppConst.t2.copyWith(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConst.radius),
            border: Border.all(color: AppConst.gray.withOpacity(0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'See what you\'ll pay over the course of your entire rental '
                'period.',
                style: AppConst.body.copyWith(
                  fontSize: 12.5,
                  color: AppConst.darkGray,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: onViewPayments,
                behavior: HitTestBehavior.opaque,
                child: Text(
                  'View Payments',
                  style: AppConst.body.copyWith(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppConst.appBlack,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// "Next Property" tile — an image-fill card with a dark bottom gradient and
/// white title / location / "Starts from x €" overlay (matches home cards).
class NextPropertyCard extends StatelessWidget {
  final PropertyListing listing;
  final VoidCallback onTap;

  const NextPropertyCard({
    super.key,
    required this.listing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AspectRatio(
        aspectRatio: 1.15,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CardImage(
                asset: listing.image,
                url: listing.imageUrl,
                seed: listing.seed,
                fallbackIcon: Icons.apartment_rounded,
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x00000000),
                      Color(0x40000000),
                      Color(0xCC000000),
                      Color(0xF2000000),
                    ],
                    stops: [0.0, 0.4, 0.75, 1.0],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listing.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      listing.location,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.92),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          'Starts from  ',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 10.5,
                          ),
                        ),
                        Text(
                          '${listing.priceFrom} ${listing.currency}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Sticky bottom bar — smiley + "Thinking this could be your next home?" and
/// an orange outlined "Book Now" pill.
class BookNowBar extends StatelessWidget {
  final VoidCallback onBookNow;

  const BookNowBar({super.key, required this.onBookNow});

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
          child: Row(
            children: [
              const Icon(Icons.sentiment_satisfied_outlined,
                  color: AppConst.appBlack, size: 26),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Thinking this could be your\nnext home?',
                  style: AppConst.body.copyWith(
                    fontSize: 12.5,
                    height: 1.3,
                    color: AppConst.appBlack,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: onBookNow,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppConst.primary, width: 1.4),
                  foregroundColor: AppConst.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
                ),
                child: Text(
                  'Book Now',
                  style: AppConst.body.copyWith(
                    color: AppConst.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
