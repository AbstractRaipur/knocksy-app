import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../const/app_const.dart';

/// Knocksy text field — theme-adaptive, reusable across forms.
///
/// Designed to live inside a parent that already provides horizontal padding;
/// this widget only handles its own internal layout so it composes cleanly.
class AppTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final bool required;
  final bool readOnly;
  final bool autoFocus;
  final bool obscureText;
  final bool enabled;
  final int? maxLength;
  final TextInputType inputType;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  /// Pre-fills the field when no [controller] is provided.
  /// Ignored if [controller] is set (use controller.text instead).
  /// Only applied on first build — the widget retains user edits after that.
  final String? initialValue;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final Widget? prefix;
  final Widget? suffix;
  final String? errorText;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.required = false,
    this.readOnly = false,
    this.autoFocus = false,
    this.obscureText = false,
    this.enabled = true,
    this.maxLength,
    this.inputType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.inputFormatters,
    this.controller,
    this.initialValue,
    this.validator,
    this.onChanged,
    this.onTap,
    this.prefix,
    this.suffix,
    this.errorText,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscure = widget.obscureText;
  bool _focused = false;
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      if (mounted) setState(() => _focused = _focus.hasFocus);
    });
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    final borderColor = hasError
        ? AppConst.errorColor
        : _focused
            ? AppConst.primary
            : AppConst.gray;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Row(
              children: [
                Text(
                  widget.label!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppConst.darkGray,
                  ),
                ),
                if (widget.required)
                  const Text(' *',
                      style: TextStyle(color: AppConst.errorColor)),
              ],
            ),
          ),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: AppConst.curves,
          decoration: BoxDecoration(
            color: widget.enabled
                ? theme.scaffoldBackgroundColor
                : AppConst.lightGray,
            borderRadius: BorderRadius.circular(AppConst.radius),
            border: Border.all(color: borderColor, width: 1.4),
          ),
          child: TextFormField(
            focusNode: _focus,
            controller: widget.controller,
            // initialValue is only honoured when no controller is provided.
            initialValue:
                widget.controller == null ? widget.initialValue : null,
            validator: widget.validator,
            onChanged: widget.onChanged,
            onTap: widget.onTap,
            readOnly: widget.readOnly,
            enabled: widget.enabled,
            autofocus: widget.autoFocus,
            obscureText: _obscure,
            keyboardType: widget.inputType,
            textInputAction: widget.textInputAction,
            inputFormatters: widget.inputFormatters,
            maxLength: widget.maxLength,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              counterText: '',
              hintStyle: TextStyle(
                color: AppConst.darkGray.withOpacity(0.7),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: widget.prefix,
              suffixIcon: widget.obscureText
                  ? IconButton(
                      onPressed: () => setState(() => _obscure = !_obscure),
                      icon: Icon(
                        _obscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppConst.darkGray,
                        size: 20,
                      ),
                    )
                  : widget.suffix,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 16,
              ),
              errorStyle: const TextStyle(height: 0, fontSize: 0),
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(left: 6, top: 6),
            child: Text(
              widget.errorText!,
              style: const TextStyle(
                color: AppConst.errorColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}
