import 'package:country_picker/country_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../const/app_assets.dart';
import '../../const/app_const.dart';
import '../../utils/app_navigator.dart';
import '../../utils/app_validators.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import 'verification_page.dart';

/// Login screen — orange brand band with portrait + wordmark up top, draggable
/// white sheet at the bottom with the mobile-number field and the blue Continue
/// CTA. UI-only shell: Continue validates the number then routes to [HomePage]
/// (no auth/OTP backend wired in the tenant app yet).
///
/// The white sheet is a [DraggableScrollableSheet] so the entire surface
/// responds to drag, and it auto-expands when the keyboard opens.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// ---- Sheet snap fractions (kept at file scope so _OrangeContent can size
// the portrait against the same constants the sheet uses).
const double _kSheetMin = 0.42;
const double _kSheetMax = 0.92;
const double _kSheetKeyboard = 0.78;

class _LoginPageState extends State<LoginPage> {
  final _phone = TextEditingController();
  final _sheetController = DraggableScrollableController();

  String _countryCode = '+91';
  String? _phoneError;
  bool _keyboardOpen = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));
    if (kDebugMode) {
      _phone.text = '9876543210';
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    if (isOpen != _keyboardOpen) {
      _keyboardOpen = isOpen;
      // Auto-snap the sheet so the form sits above the keyboard.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_sheetController.isAttached) return;
        _sheetController.animateTo(
          isOpen ? _kSheetKeyboard : _kSheetMin,
          duration: AppConst.animationDuration,
          curve: AppConst.curves,
        );
      });
    }
  }

  @override
  void dispose() {
    _phone.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  void _onContinue() {
    final raw = _phone.text.trim();
    final err = AppValidators.phone(raw);
    setState(() => _phoneError = err);
    if (err != null) return;

    FocusManager.instance.primaryFocus?.unfocus();
    AppNavigator.navigateTo(
      context,
      VerificationPage(countryCode: _countryCode, phone: raw),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final viewInsets = MediaQuery.of(context).viewInsets;

    return PopScope(
      // Login is the root of the auth stack — block the system back gesture
      // and ask the user to confirm before exiting the app.
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final exit = await _confirmExit(context);
        if (exit == true) SystemNavigator.pop();
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: AppConst.primary,
          // Don't auto-resize — we drive the sheet ourselves so the portrait
          // and gradient don't squish when the keyboard appears.
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              // -------- Orange background: wordmark + tagline + portrait ----
              Positioned.fill(
                child: _OrangeContent(size: size),
              ),

              // -------- Draggable white sheet -------------------------------
              DraggableScrollableSheet(
                controller: _sheetController,
                initialChildSize: _kSheetMin,
                minChildSize: _kSheetMin,
                maxChildSize: _kSheetMax,
                snap: true,
                snapSizes: const [_kSheetMin, _kSheetKeyboard, _kSheetMax],
                builder: (context, scrollController) {
                  return _SheetSurface(
                    scrollController: scrollController,
                    bottomInset: viewInsets.bottom,
                    child: _LoginForm(
                      phone: _phone,
                      countryCode: _countryCode,
                      phoneError: _phoneError,
                      onCountryTap: _pickCountry,
                      onPhoneChanged: (_) {
                        if (_phoneError != null) {
                          setState(() => _phoneError = null);
                        }
                      },
                      onContinue: _onContinue,
                      onSignUp: () {},
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      useSafeArea: true,
      countryListTheme: CountryListThemeData(
        // Cap the sheet at 70% of the screen height, with a rounded top.
        bottomSheetHeight: MediaQuery.of(context).size.height * 0.7,
        backgroundColor: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: EdgeInsets.zero,
        flagSize: 26,
        textStyle: AppConst.body.copyWith(
          fontSize: 15,
          color: AppConst.appBlack,
          fontWeight: FontWeight.w500,
        ),
        searchTextStyle: AppConst.body.copyWith(
          fontSize: 15,
          color: AppConst.appBlack,
        ),
        inputDecoration: InputDecoration(
          isDense: true,
          hintText: 'Search country',
          hintStyle: AppConst.body.copyWith(
            color: AppConst.darkGray,
            fontSize: 15,
          ),
          prefixIcon: const Icon(Icons.search_rounded,
              color: AppConst.darkGray, size: 22),
          filled: true,
          fillColor: const Color(0xffF5F5F7),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppConst.primary, width: 1.4),
          ),
        ),
      ),
      onSelect: (Country country) {
        setState(() => _countryCode = '+${country.phoneCode}');
      },
    );
  }
}

/// Confirm-exit prompt used by [PopScope] on the Login screen. Returning
/// `true` lets the caller actually exit the app via [SystemNavigator.pop].
Future<bool?> _confirmExit(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: const Text('Exit Knocksy?'),
        content: const Text('Are you sure you want to leave the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Stay'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppConst.errorColor),
            child: const Text('Exit'),
          ),
        ],
      );
    },
  );
}

// ---------------------------------------------------------------- Orange band
class _OrangeContent extends StatelessWidget {
  final Size size;

  const _OrangeContent({required this.size});

  @override
  Widget build(BuildContext context) {
    final taglineGap = size.height * 0.22;
    const sheetTopOverlap = 16.0; // portrait dips this far behind the sheet

    return Container(
      color: AppConst.primary,
      child: Stack(
        children: [
          // Portrait — bounded between tagline area and the sheet's top edge.
          Positioned(
            top: taglineGap,
            bottom: size.height * _kSheetMin - sheetTopOverlap,
            left: 0,
            right: 0,
            child: Image.asset(
              AppAssets.signInGirl,
              fit: BoxFit.contain,
              alignment: Alignment.bottomCenter,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
          // Wordmark + tagline — pinned across the top, centred horizontally.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppAssets.logo,
                      height: (size.width / 6).clamp(48.0, 80.0),
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.12),
                      child: Text(
                        'We help rental market users to fulfill their needs '
                        'by offering an A2Z rental solution.',
                        textAlign: TextAlign.center,
                        style: AppConst.body.copyWith(
                          color: Colors.white,
                          fontSize: 14.5,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------- White sheet
class _SheetSurface extends StatelessWidget {
  final ScrollController scrollController;
  final double bottomInset;
  final Widget child;

  const _SheetSurface({
    required this.scrollController,
    required this.bottomInset,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: AppConst.borderRadiusTopOnly,
        boxShadow: [AppConst.boxShadow],
      ),
      child: ListView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: EdgeInsets.fromLTRB(
          AppConst.padding * 1.6,
          10,
          AppConst.padding * 1.6,
          24 + bottomInset + MediaQuery.of(context).padding.bottom,
        ),
        children: [
          const _GrabHandle(),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _GrabHandle extends StatelessWidget {
  const _GrabHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 44,
        height: 5,
        decoration: BoxDecoration(
          color: AppConst.gray,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------- Form body
class _LoginForm extends StatelessWidget {
  final TextEditingController phone;
  final String countryCode;
  final String? phoneError;
  final VoidCallback onCountryTap;
  final ValueChanged<String> onPhoneChanged;
  final VoidCallback onContinue;
  final VoidCallback onSignUp;

  const _LoginForm({
    required this.phone,
    required this.countryCode,
    required this.phoneError,
    required this.onCountryTap,
    required this.onPhoneChanged,
    required this.onContinue,
    required this.onSignUp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CountryCodeChip(code: countryCode, onTap: onCountryTap),
            const SizedBox(width: 10),
            Expanded(
              child: AppTextField(
                controller: phone,
                hint: 'Mobile number',
                inputType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                maxLength: 10,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                errorText: phoneError,
                onChanged: onPhoneChanged,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            "We'll text you a 6-digit code to confirm it's you.",
            style: AppConst.body.copyWith(
              color: AppConst.darkGray,
              fontSize: 12.5,
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 24),
        AppButton(
          color: AppConst.accent,
          width: double.infinity,
          height: 56,
          onTap: onContinue,
          child: const Text('Continue'),
        ),
        const SizedBox(height: 18),
        Center(
          child: TextButton(
            onPressed: onSignUp,
            style: TextButton.styleFrom(foregroundColor: AppConst.primary),
            child: Text.rich(
              TextSpan(
                style: AppConst.body.copyWith(
                  fontSize: 13,
                  color: AppConst.primary,
                ),
                children: const [
                  TextSpan(text: "Don't have an account? "),
                  TextSpan(
                    text: 'Sign up',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Compact "+91 ▾" chip — the login screen's country code selector.
class _CountryCodeChip extends StatelessWidget {
  final String code;
  final VoidCallback onTap;

  const _CountryCodeChip({required this.code, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 56, // matches AppTextField vertical footprint
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConst.radius),
          border: Border.all(color: AppConst.gray, width: 1.4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              code,
              style: AppConst.body.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppConst.appBlack,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppConst.darkGray,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
