import 'package:flutter/material.dart';

import '../../const/app_const.dart';
import '../../utils/app_navigator.dart';
import '../filters/filters_page.dart';
import '../property_detail/property_detail_page.dart';
import 'home_models.dart';
import 'widgets/filter_sort_bar.dart';
import 'widgets/first_time_section.dart';
import 'widgets/home_header.dart';
import 'widgets/property_card.dart';
import 'widgets/reel_card.dart';

/// Tenant homepage tab — matches the Figma reference: orange header with
/// search + dates, a Filters/Sort bar, "Properties Near You" grid, "Reeling
/// you in" reels, and the "Something for the First Time" illustration. Static
/// mock data ([HomeMockData]); no backend.
///
/// The bottom navigation bar is owned by [MainShell], not this tab.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.zero,
        physics: AppConst.scrollPhysics,
        children: [
          // Orange header, then the white sheet starting with the
          // full-width Filters / Sort bar (rounded top, flush — not floating).
          const HomeHeader(),
          FilterSortBar(
            onFilters: () => AppNavigator.navigateTo(
              context,
              const FiltersPage(),
            ),
          ),
          const SizedBox(height: 16),

          // ---------------------------------------- Properties Near You
          const _SectionTitle('Properties Near You'),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              // Auto columns: ~2 on phones, more on tablets (tile ≤ 210dp).
              gridDelegate:
                  const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 210,
                crossAxisSpacing: 16,
                mainAxisSpacing: 18,
                childAspectRatio: 0.74,
              ),
              children: [
                for (final p in HomeMockData.properties)
                  PropertyCard(
                    listing: p,
                    onTap: () => AppNavigator.navigateTo(
                      context,
                      PropertyDetailPage(listing: p),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // ---------------------------------------- Reeling you in
          const _SectionTitle('Reeling you in'),
          const SizedBox(height: 14),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _ReelsMasonry(),
          ),
          const SizedBox(height: 32),

          // ---------------------------------------- Something for the First Time
          const FirstTimeSection(),
        ],
      ),
    );
  }
}

/// Responsive staggered (masonry) layout for "Reeling you in".
///
/// Column count adapts to width (2 on phones, more on tablets); each reel
/// keeps its own aspect ratio and items are placed into the currently
/// shortest column so the masonry stays balanced. The "Explore" card fills
/// the last/shortest column.
class _ReelsMasonry extends StatelessWidget {
  const _ReelsMasonry();

  // Per-reel aspect ratios (cycled), matching the phone reference.
  static const _aspects = [0.76, 0.96, 1.0, 0.74, 0.77];

  @override
  Widget build(BuildContext context) {
    final reels = HomeMockData.reels;
    const gap = 14.0;

    return LayoutBuilder(
      builder: (context, c) {
        final cols = (c.maxWidth / 200).floor().clamp(2, 5);
        final tileW = (c.maxWidth - gap * (cols - 1)) / cols;

        final colChildren = List.generate(cols, (_) => <Widget>[]);
        final colHeights = List<double>.filled(cols, 0);

        int shortest() {
          var idx = 0;
          for (var k = 1; k < cols; k++) {
            if (colHeights[k] < colHeights[idx]) idx = k;
          }
          return idx;
        }

        void place(Widget child, double aspect) {
          final i = shortest();
          if (colChildren[i].isNotEmpty) {
            colChildren[i].add(const SizedBox(height: gap));
          }
          colChildren[i].add(
            AspectRatio(aspectRatio: aspect, child: child),
          );
          colHeights[i] += tileW / aspect + gap;
        }

        for (var i = 0; i < reels.length; i++) {
          place(ReelCard(reel: reels[i]), _aspects[i % _aspects.length]);
        }
        place(const ExploreCard(), 0.8);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var k = 0; k < cols; k++) ...[
              if (k > 0) const SizedBox(width: gap),
              Expanded(child: Column(children: colChildren[k])),
            ],
          ],
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        text,
        style: AppConst.t2.copyWith(fontSize: 18, color: AppConst.appBlack),
      ),
    );
  }
}
