import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';

import '../../const/app_const.dart';
import '../../utils/app_navigator.dart';
import '../booking/booking_date_picker.dart';
import '../home/home_models.dart';
import '../payment/payment_summary_page.dart';
import 'widgets/booking_steps.dart';
import 'widgets/footer_widgets.dart';
import 'widgets/hero_carousel.dart';
import 'widgets/info_cards.dart';

/// Tenant property detail page — matches the Figma reference. All content is
/// static mock data; swap in a model/provider when the backend is wired.
class PropertyDetailPage extends StatefulWidget {
  /// The listing tapped on the homepage (used for the title / price echo).
  final PropertyListing listing;

  const PropertyDetailPage({super.key, required this.listing});

  @override
  State<PropertyDetailPage> createState() => _PropertyDetailPageState();
}

class _PropertyDetailPageState extends State<PropertyDetailPage> {
  bool _saved = false;

  void _noop() {}

  /// Book Now → pick dates, then show the booking payment summary.
  Future<void> _startBooking(BuildContext context) async {
    final range = await showBookingDatePicker(context);
    if (range == null || !context.mounted) return;
    AppNavigator.navigateTo(context, const PaymentSummaryPage.booking());
  }

  @override
  Widget build(BuildContext context) {
    final l = widget.listing;

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BookNowBar(onBookNow: () => _startBooking(context)),
      body: ListView(
        padding: EdgeInsets.zero,
        physics: AppConst.scrollPhysics,
        children: [
          HeroCarousel(
            imageUrls: l.imageUrl != null
                ? List<String>.filled(18, l.imageUrl!)
                : const [],
            placeholderCount: 5,
            totalPhotos: 18,
            onBack: () => Navigator.of(context).maybePop(),
          ),
          // White sheet pulled up over the hero's bottom edge.
          Transform.translate(
            offset: const Offset(0, -16),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: AppConst.borderRadiusTopOnly,
              ),
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SheetHandle(),
                  const SizedBox(height: 14),
                  _TitleRow(
                    title: l.title,
                    saved: _saved,
                    onSave: () => setState(() => _saved = !_saved),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        'Apartment in ${l.location}',
                        style: AppConst.body.copyWith(
                          color: AppConst.accent,
                          fontWeight: FontWeight.w600,
                          fontSize: 13.5,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(FeatherIcons.mapPin,
                          size: 16, color: AppConst.accent),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const _MetaRow(
                    items: ['Upto 4 People', 'Bedroom', '2 Bathroom'],
                  ),
                  const SizedBox(height: 20),

                  // -------------------------------------------- Description
                  const _SectionHeading('Description'),
                  const SizedBox(height: 8),
                  Text(
                    'Experience modern living at its finest with this '
                    'beautifully designed 2 BHK residence located in a prime, '
                    'well-connected neighbourhood. The property features '
                    'spacious rooms filled with natural light, a fully '
                    'equipped modular kitchen, premium fittings, and a private '
                    'balcony overlooking serene surroundings.',
                    style: AppConst.body.copyWith(
                      fontSize: 13,
                      height: 1.55,
                      color: AppConst.darkGray,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TrustBadgeCard(
                    icon: FeatherIcons.shield,
                    iconBg: const Color(0xffE3F0FB),
                    iconColor: AppConst.accent,
                    body: 'Your deposit is safe with us. If your landlord '
                        'fails to return it, we\'ll step in and make sure '
                        'you get it back.',
                    linkText: 'Learn more',
                    onLinkTap: _noop,
                  ),
                  const SizedBox(height: 10),
                  TrustBadgeCard(
                    icon: FeatherIcons.fileText,
                    iconBg: const Color(0xffE0F2F1),
                    iconColor: const Color(0xff009688),
                    body: 'All bills covered. Experience stress-free living '
                        'with rent and utilities included, making your stay '
                        'simple and convenient.',
                  ),
                  const SizedBox(height: 10),
                  TrustBadgeCard(
                    icon: FeatherIcons.smile,
                    iconBg: const Color(0xffFDE7E2),
                    iconColor: const Color(0xffEF6C57),
                    body: 'Trusted landlord\nProfessional · Partnered with us '
                        'for 1 year',
                    linkText: 'Learn more about this landlord',
                    onLinkTap: _noop,
                  ),
                  const SizedBox(height: 12),
                  HelpCard(onContact: _noop),
                  const SizedBox(height: 16),
                  const BreadcrumbRow(
                    parts: ['Home', 'Dubai', 'Apartments for rent'],
                  ),
                  const SizedBox(height: 22),

                  // ---------------------------------------------- Amenities
                  const _SectionHeading('Amenities'),
                  const SizedBox(height: 4),
                  const AmenitiesGrid(items: [
                    Amenity(FeatherIcons.droplet, 'Private Toilet'),
                    Amenity(FeatherIcons.thermometer, 'Gas Heating'),
                    Amenity(FeatherIcons.coffee, 'Private Kitchen'),
                    Amenity(FeatherIcons.coffee, 'Private Kitchen'),
                    Amenity(FeatherIcons.droplet, 'Private Bathroom'),
                    Amenity(FeatherIcons.wifi, 'Wifi'),
                    Amenity(FeatherIcons.sun, 'Private Balcony'),
                    Amenity(FeatherIcons.moon, 'Bed'),
                  ]),
                  const SizedBox(height: 22),

                  // -------------------------------------------- House Rules
                  const _SectionHeading('House Rules'),
                  const SizedBox(height: 10),
                  const HouseRulesCard(rules: [
                    'Check-in: After 2:00 PM',
                    'Check-out: Before 11:00 AM',
                    'No parties or loud music after 10:00 PM',
                    'No smoking inside the property',
                    'Pets: Allowed only if mentioned in the listing',
                  ]),
                  const SizedBox(height: 22),

                  // ------------------------------------------ Booking steps
                  const _SectionHeading(
                      '4 Easy Steps to Book Your Home with Knocksy'),
                  const SizedBox(height: 12),
                  ..._bookingSteps(),
                  const SizedBox(height: 22),

                  // -------------------------------------- Cancellation
                  const _SectionHeading('Cancellation Policy'),
                  const SizedBox(height: 10),
                  const CancellationPolicyCard(
                    policyName: 'Strict cancellation',
                    rules: [
                      CancellationRule(
                        when: 'Within 24 hours of confirmation',
                        refund: 'Full refund of first month\'s rent',
                      ),
                      CancellationRule(
                        when: 'After 24 hours of confirmation',
                        refund: 'No refund',
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ChatActionRow(onChat: _noop, onKnocksy: _noop),
                  const SizedBox(height: 24),

                  // --------------------------------------- Payment details
                  PaymentDetailsRow(onViewPayments: _noop),
                  const SizedBox(height: 24),

                  // ----------------------------------------- Next property
                  const _SectionHeading('Next Property'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: NextPropertyCard(
                          listing: const PropertyListing(
                            title: 'A101 - Future Towers',
                            location: 'Dubai',
                            priceFrom: 560,
                            imageUrl: HomeMockData.propertyPhoto,
                            seed: 2,
                          ),
                          onTap: _noop,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: NextPropertyCard(
                          listing: const PropertyListing(
                            title: 'A101 - Future Towers',
                            location: 'Dubai',
                            priceFrom: 480,
                            imageUrl: HomeMockData.propertyPhoto,
                            seed: 3,
                          ),
                          onTap: _noop,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _bookingSteps() {
    final steps = <Widget>[
      BookingStepCard(
        icon: FeatherIcons.search,
        background: const Color(0xffEAF1FB),
        iconColor: AppConst.accent,
        title: 'Search & Select',
        subtitle: 'Find your ideal home with ease. Our verified listings '
            'include real photos, virtual tours, and detailed descriptions '
            'of both the property and the neighborhood.',
        bullets: const [
          BookingBullet(
            label: 'Verified Listings',
            description:
                'Every property is checked for accuracy and security and '
                'been knocksy trusted.',
          ),
          BookingBullet(
            label: 'Real Photos & Virtual Tours',
            description: 'Explore homes online as if you were there.',
          ),
          BookingBullet(
            label: 'Highlighted Insights',
            description: 'Get to know the area before booking.',
          ),
          BookingBullet(
            label: 'Check Landlord Policies',
            description:
                'Before booking to understand deposit terms, rental '
                'conditions, and additional fees.',
          ),
        ],
      ),
      BookingStepCard(
        icon: FeatherIcons.calendar,
        background: const Color(0xffF1ECFB),
        iconColor: const Color(0xff7E57C2),
        title: 'Reserve the Property',
        subtitle: 'Once you\'ve found the perfect place, submit your '
            'reservation request. The landlord will have up to 24 hours to '
            'respond. Secure Payment Process - We take your payment details '
            'at this stage, but you won\'t be charged until the landlord '
            'confirms. What you Pay For:',
        bullets: const [
          BookingBullet(
            label: 'First Rent Payment',
            description:
                'This is securely held by knocksy and transferred to the '
                'landlord 48 hours after you move in. Unless you contact us '
                'with a problem.',
          ),
          BookingBullet(
            label: 'Tenant Protection Fees',
            description:
                'Covers verifications, Customer support and platform services.',
          ),
        ],
      ),
      BookingStepCard(
        icon: FeatherIcons.checkCircle,
        background: const Color(0xffEAF4FB),
        iconColor: AppConst.accent,
        title: 'Get Confirmation',
        subtitle: 'Once the landlord accepts your booking, your payment will '
            'be processed automatically.',
        bullets: const [
          BookingBullet(
            label: 'Direct Contact with the Landlord',
            description:
                'We\'ll connect you via email to arrange key collection, '
                'move-in time, and required documentation.',
          ),
          BookingBullet(
            label: 'Need Help?',
            description:
                'Covers verifications, Customer support and platform services.',
          ),
          BookingBullet(
            label: 'Tenant Protection Fees',
            description:
                'Covers verification, customer support, and platform services.',
          ),
        ],
      ),
      BookingStepCard(
        icon: FeatherIcons.home,
        background: const Color(0xffFBF6E6),
        iconColor: AppConst.warning,
        title: 'Move In',
        subtitle: 'Congratulations! The home is yours. Simply collect your '
            'keys and sign the contract with the landlord via Knocksy Manage '
            'or as requested by the landlord.',
        bullets: const [
          BookingBullet(
            label: 'First Rent Transfer',
            description:
                'Your first payment will be securely transferred to the '
                'landlord 48 hours after you move in.',
          ),
          BookingBullet(
            label: 'Deposit & Additional Fees',
            description:
                'Pay the landlord directly for any required security deposit '
                'or additional costs only through knocksy Manage to ensure '
                'full transparency and accountability.',
          ),
        ],
      ),
    ];

    // Interleave with vertical spacing.
    final spaced = <Widget>[];
    for (var i = 0; i < steps.length; i++) {
      spaced.add(steps[i]);
      if (i != steps.length - 1) spaced.add(const SizedBox(height: 12));
    }
    return spaced;
  }
}

// ------------------------------------------------------------------ Helpers

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: AppConst.primary,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}

class _TitleRow extends StatelessWidget {
  final String title;
  final bool saved;
  final VoidCallback onSave;

  const _TitleRow({
    required this.title,
    required this.saved,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: AppConst.t1.copyWith(fontSize: 22),
          ),
        ),
        GestureDetector(
          onTap: onSave,
          behavior: HitTestBehavior.opaque,
          child: Icon(
            saved ? FeatherIcons.bookmark : FeatherIcons.bookmark,
            color: AppConst.appBlack,
            size: 24,
          ),
        ),
      ],
    );
  }
}

class _MetaRow extends StatelessWidget {
  final List<String> items;
  const _MetaRow({required this.items});

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      children.add(Text(
        items[i],
        style: AppConst.caption.copyWith(
          fontSize: 12,
          color: AppConst.darkGray,
        ),
      ));
      if (i < items.length - 1) {
        children.add(const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Icon(Icons.circle, size: 4, color: AppConst.darkGray),
        ));
      }
    }
    // Scale down on very narrow screens so the meta line never overflows.
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(children: children),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String text;
  const _SectionHeading(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppConst.t2.copyWith(fontSize: 16, color: AppConst.appBlack),
    );
  }
}
