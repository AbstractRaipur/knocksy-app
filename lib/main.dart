import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'const/app_const.dart';
import 'pages/onboarding/splash_page.dart';
import 'providers/filter_provider.dart';
import 'utils/app_navigator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
  );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    // DevicePreview lets you switch device sizes/orientations in debug to
    // test responsiveness. It's a no-op in release builds.
    DevicePreview(
      enabled: false, // re-enable (e.g. !kReleaseMode) to test device sizes
      builder: (_) => ChangeNotifierProvider<FilterProvider>(
        create: (_) => FilterProvider(),
        child: const KnocksyApp(),
      ),
    ),
  );
}

class KnocksyApp extends StatelessWidget {
  const KnocksyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Knocksy',
      debugShowCheckedModeBanner: false,
      navigatorKey: AppNavigator.navigatorKey,
      theme: AppConst.lightTheme,
      // Hook DevicePreview into the app's locale.
      locale: DevicePreview.locale(context),
      // Responsive shell:
      //  • DevicePreview.appBuilder injects the simulated device metrics.
      //  • Force a baseline text scale so OS font settings don't break layouts.
      //  • Tap-to-dismiss the keyboard on empty space.
      // The UI fills the full width on every device; grids/sections adapt
      // their column counts (see HomePage) so tablets use the space.
      builder: (context, child) {
        return DevicePreview.appBuilder(
          context,
          MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1)),
            child: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              behavior: HitTestBehavior.opaque,
              child: child ?? const SizedBox.shrink(),
            ),
          ),
        );
      },
      home: const SplashPage(),
    );
  }
}
