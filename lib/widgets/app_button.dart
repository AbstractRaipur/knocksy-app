import 'package:flutter/material.dart';

import '../const/app_const.dart';

/// Knocksy primary button.
///
/// Generic and parameterised — pass any child, override colours per call site.
/// Default state animates a subtle press-down feel; loading state collapses
/// the button to a centred spinner with a stop affordance.
class AppButton extends StatefulWidget {
  final Widget child;
  final double radius;
  final Color color;
  final Color? splash;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry padding;
  final bool loading;
  final bool enabled;
  final GestureTapCallback? onTap;
  final VoidCallback? onCancelLoading;

  const AppButton({
    super.key,
    required this.child,
    this.color = AppConst.primary,
    this.splash,
    this.radius = AppConst.radius,
    this.height = 52,
    this.width,
    this.padding = const EdgeInsets.symmetric(horizontal: 18),
    this.loading = false,
    this.enabled = true,
    this.onTap,
    this.onCancelLoading,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final disabled = !widget.enabled || widget.loading;
    final bg = disabled
        ? widget.color.withOpacity(0.55)
        : (_pressed ? widget.color.withOpacity(0.85) : widget.color);

    return GestureDetector(
      onTap: disabled ? null : widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: AppConst.curves,
        height: widget.height,
        width: widget.width,
        padding: widget.padding,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(widget.radius),
          boxShadow: _pressed || disabled
              ? null
              : const [AppConst.softShadow],
        ),
        child: widget.loading
            ? _LoadingContent(onCancel: widget.onCancelLoading)
            : DefaultTextStyle(
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
                child: IconTheme(
                  data: const IconThemeData(color: Colors.white, size: 20),
                  child: widget.child,
                ),
              ),
      ),
    );
  }
}

class _LoadingContent extends StatelessWidget {
  final VoidCallback? onCancel;

  const _LoadingContent({this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const SizedBox(
          height: 22,
          width: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2.4,
            color: Colors.white,
          ),
        ),
        if (onCancel != null)
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onCancel,
                child: const Center(
                  child: Icon(Icons.close_rounded,
                      color: Colors.white, size: 16),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
