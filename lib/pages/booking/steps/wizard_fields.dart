import 'package:flutter/material.dart';

import '../../../const/app_const.dart';

/// Shared floating-label input decoration for the booking wizard forms.
InputDecoration _decoration(String label, {String? hint, Widget? suffix}) {
  OutlineInputBorder border(Color c) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConst.radius),
        borderSide: BorderSide(color: c, width: 1.4),
      );
  return InputDecoration(
    labelText: label,
    hintText: hint,
    suffixIcon: suffix,
    isDense: true,
    labelStyle: const TextStyle(color: AppConst.darkGray, fontSize: 14),
    floatingLabelStyle: const TextStyle(color: AppConst.darkGray, fontSize: 13),
    hintStyle: TextStyle(color: AppConst.darkGray.withOpacity(0.7), fontSize: 14),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
    border: border(AppConst.gray),
    enabledBorder: border(AppConst.gray.withOpacity(0.8)),
    focusedBorder: border(AppConst.primary),
  );
}

/// Floating-label text field used across the booking wizard.
class WizardField extends StatelessWidget {
  final String label;
  final String? hint;
  final String? initialValue;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffix;

  const WizardField({
    super.key,
    required this.label,
    this.hint,
    this.initialValue,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.onTap,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      style: AppConst.body.copyWith(fontSize: 15, fontWeight: FontWeight.w500),
      decoration: _decoration(label, hint: hint, suffix: suffix),
    );
  }
}

/// Floating-label dropdown styled to match [WizardField].
class WizardDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const WizardDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 22),
      style: AppConst.body.copyWith(
          fontSize: 15, fontWeight: FontWeight.w500, color: AppConst.appBlack),
      decoration: _decoration(label),
      items: [
        for (final i in items)
          DropdownMenuItem(value: i, child: Text(i)),
      ],
      onChanged: onChanged,
    );
  }
}

/// A square document-upload slot with a dashed orange border and a + icon.
class UploadSlot extends StatelessWidget {
  const UploadSlot({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedRectPainter(color: AppConst.primary, radius: 8),
      child: const SizedBox(
        width: 52,
        height: 52,
        child: Icon(Icons.add, color: AppConst.primary, size: 22),
      ),
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  final Color color;
  final double radius;

  _DashedRectPainter({required this.color, this.radius = 8});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);

    const dash = 4.0;
    const gap = 3.0;
    for (final metric in path.computeMetrics()) {
      var dist = 0.0;
      while (dist < metric.length) {
        final next = dist + dash;
        canvas.drawPath(
          metric.extractPath(dist, next.clamp(0, metric.length)),
          paint,
        );
        dist = next + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
