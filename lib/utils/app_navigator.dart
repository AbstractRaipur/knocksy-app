import 'package:flutter/material.dart';

/// Centralised navigation helpers.
///
/// Convention (per project guidelines): NO named routes — explicit widget
/// pushes only. Use `AppNavigator.navigateTo` and `AppNavigator.replace`.
///
/// The global [navigatorKey] is attached to [MaterialApp.navigatorKey] so
/// non-widget code (notification handlers, deep links, background isolates
/// dispatched to the main isolate) can push routes without a BuildContext.
class AppNavigator {
  AppNavigator._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static BuildContext? get rootContext => navigatorKey.currentContext;

  static Future<T?> navigateTo<T>(BuildContext context, Widget page) {
    return Navigator.push<T>(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  static Future<T?> replace<T>(BuildContext context, Widget page) {
    return Navigator.pushReplacement<T, dynamic>(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  static Future<T?> replaceAll<T>(BuildContext context, Widget page) {
    return Navigator.pushAndRemoveUntil<T>(
      context,
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  static void pop(BuildContext context, [Object? result]) {
    Navigator.pop(context, result);
  }

  // --------------------------- Context-free variants (notifications etc.)
  static Future<T?> pushRoot<T>(Widget page) async {
    final nav = navigatorKey.currentState;
    if (nav == null) return null;
    return nav.push<T>(MaterialPageRoute(builder: (_) => page));
  }

  static Future<T?> replaceAllRoot<T>(Widget page) async {
    final nav = navigatorKey.currentState;
    if (nav == null) return null;
    return nav.pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }
}
