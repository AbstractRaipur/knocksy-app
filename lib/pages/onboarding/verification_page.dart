import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../const/app_const.dart';
import '../../utils/app_navigator.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_logo.dart';
import 'congratulations_page.dart';
import 'widgets/onboarding_scaffold.dart';

/// OTP verification — 6-digit code with a dash between the 3rd and 4th boxes,
/// blue Continue CTA, and a "Valid for 10 minutes" hint. UI-only: any 6 digits
/// continue to the Congratulations screen (no backend).
class VerificationPage extends StatefulWidget {
  final String countryCode;
  final String phone;

  const VerificationPage({
    super.key,
    required this.countryCode,
    required this.phone,
  });

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  String _otp = '';
  String? _otpError;

  void _onContinue() {
    if (_otp.length < 6) {
      setState(() => _otpError = 'Enter the 6-digit code');
      return;
    }
    setState(() => _otpError = null);
    AppNavigator.navigateTo(context, const CongratulationsPage());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return OnboardingScaffold(
      headerHeightFraction: 0.25,
      header: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppConst.padding * 1.6,
          8,
          AppConst.padding * 1.6,
          24,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                behavior: HitTestBehavior.opaque,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Icon(Icons.chevron_left_rounded,
                      color: Colors.white, size: 30),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: KnocksyWordmark(
                height: (size.width / 11).clamp(28.0, 42.0),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      sheet: SingleChildScrollView(
        physics: AppConst.scrollPhysics,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Text(
              '6-digit Code',
              style: AppConst.t1.copyWith(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: AppConst.appBlack,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Code sent to ${widget.countryCode} ${widget.phone} '
              'unless you already have an account',
              style: AppConst.body.copyWith(
                fontSize: 14,
                color: AppConst.appBlack,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 28),
            _OtpField(
              onChanged: (v) {
                _otp = v;
                if (_otpError != null) setState(() => _otpError = null);
              },
              hasError: _otpError != null,
            ),
            if (_otpError != null) ...[
              const SizedBox(height: 8),
              Center(
                child: Text(
                  _otpError!,
                  style: const TextStyle(
                    color: AppConst.errorColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 28),
            AppButton(
              color: AppConst.accent,
              width: double.infinity,
              height: 56,
              onTap: _onContinue,
              child: const Text('Continue'),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Valid for 10 minutes',
                style: AppConst.body.copyWith(
                  color: AppConst.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(foregroundColor: AppConst.primary),
                child: Text(
                  'Resend code',
                  style: AppConst.body.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
          ],
        ),
      ),
    );
  }
}

/// Segmented 6-box OTP field with a dash between the 3rd and 4th boxes.
///
/// Backed by a single real (invisible) [TextField] so it reliably captures
/// input from both the on-screen keyboard and a hardware/emulator keyboard;
/// the 6 boxes are a visual representation of the typed digits.
class _OtpField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final bool hasError;

  const _OtpField({required this.onChanged, required this.hasError});

  @override
  State<_OtpField> createState() => _OtpFieldState();
}

class _OtpFieldState extends State<_OtpField> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  static const _len = 6;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final code = _controller.text;

    return GestureDetector(
      onTap: () => _focus.requestFocus(),
      behavior: HitTestBehavior.opaque,
      child: LayoutBuilder(
        builder: (context, c) {
          const separators = 4 * 6 + (6 * 2 + 14);
          final slot = ((c.maxWidth - separators) / 6).clamp(34.0, 56.0);

          Widget box(int i) {
            final filled = i < code.length;
            final isCurrent = i == code.length && _focus.hasFocus;
            return Container(
              width: slot,
              height: slot * 1.15,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppConst.lightGray,
                borderRadius: BorderRadius.circular(AppConst.radiusSmall + 2),
                border: Border.all(
                  color: widget.hasError
                      ? AppConst.errorColor
                      : (isCurrent ? AppConst.primary : AppConst.gray),
                  width: isCurrent ? 1.6 : 1.2,
                ),
              ),
              child: Text(
                filled ? code[i] : '',
                style: AppConst.t2.copyWith(
                  fontSize: slot > 44 ? 22 : 18,
                  color: AppConst.appBlack,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          }

          return Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  box(0),
                  const SizedBox(width: 4),
                  box(1),
                  const SizedBox(width: 4),
                  box(2),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7),
                    child: Container(
                        width: 12, height: 2, color: AppConst.primary),
                  ),
                  box(3),
                  const SizedBox(width: 4),
                  box(4),
                  const SizedBox(width: 4),
                  box(5),
                ],
              ),
              // Invisible field that actually receives keystrokes.
              Positioned.fill(
                child: Opacity(
                  opacity: 0,
                  child: TextField(
                    controller: _controller,
                    focusNode: _focus,
                    autofocus: true,
                    showCursor: false,
                    keyboardType: TextInputType.number,
                    maxLength: _len,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                    ),
                    onChanged: (v) {
                      setState(() {});
                      widget.onChanged(v);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
