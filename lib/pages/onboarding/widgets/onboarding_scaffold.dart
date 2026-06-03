import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../const/app_const.dart';

/// Shared layout for onboarding pages — solid orange header with a curved
/// white "sheet" below.
class OnboardingScaffold extends StatelessWidget {
  final Widget header;
  final Widget sheet;
  final double headerHeightFraction;
  final EdgeInsetsGeometry sheetPadding;
  final Color background;
  final bool resizeToAvoidBottomInset;

  const OnboardingScaffold({
    super.key,
    required this.header,
    required this.sheet,
    this.headerHeightFraction = 0.42,
    this.sheetPadding = const EdgeInsets.fromLTRB(
      AppConst.padding * 1.6,
      24,
      AppConst.padding * 1.6,
      24,
    ),
    this.background = AppConst.primary,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final headerHeight = size.height * headerHeightFraction;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: background,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: headerHeight + 60,
              child: Container(color: background),
            ),
            SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: headerHeight - MediaQuery.of(context).padding.top,
                    child: header,
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppConst.borderRadiusTopOnly,
                      ),
                      child: SafeArea(
                        top: false,
                        child: Padding(
                          padding: sheetPadding,
                          child: sheet,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
