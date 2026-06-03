import 'package:flutter/material.dart';

import '../../const/app_const.dart';

/// Shows the "Select Dates to see Prices" modal and resolves to the chosen
/// [DateTimeRange] (or null if dismissed).
Future<DateTimeRange?> showBookingDatePicker(
  BuildContext context, {
  DateTime? initialStart,
  DateTime? initialEnd,
}) {
  return showDialog<DateTimeRange>(
    context: context,
    barrierColor: Colors.black.withOpacity(0.55),
    builder: (_) => _BookingDatePickerDialog(
      initialStart: initialStart,
      initialEnd: initialEnd,
    ),
  );
}

const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String _fmt(DateTime? d) {
  if (d == null) return '';
  return '${d.day.toString().padLeft(2, '0')} ${_months[d.month - 1]} ${d.year}';
}

bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

class _BookingDatePickerDialog extends StatefulWidget {
  final DateTime? initialStart;
  final DateTime? initialEnd;

  const _BookingDatePickerDialog({this.initialStart, this.initialEnd});

  @override
  State<_BookingDatePickerDialog> createState() =>
      _BookingDatePickerDialogState();
}

class _BookingDatePickerDialogState extends State<_BookingDatePickerDialog> {
  late DateTime? _start = widget.initialStart ?? DateTime(2025, 10, 8);
  late DateTime? _end = widget.initialEnd ?? DateTime(2025, 10, 27);
  late DateTime _month =
      DateTime(_start?.year ?? 2025, _start?.month ?? 10);
  bool _calendarOpen = false;

  void _onDayTap(DateTime day) {
    setState(() {
      if (_start == null || _end != null) {
        // start a fresh range
        _start = day;
        _end = null;
      } else {
        // _start set, _end null
        if (day.isBefore(_start!)) {
          _start = day;
        } else {
          _end = day;
        }
      }
    });
  }

  void _clear() => setState(() {
        _start = null;
        _end = null;
      });

  void _continue() {
    if (_start != null && _end != null) {
      Navigator.of(context).pop(DateTimeRange(start: _start!, end: _end!));
    } else {
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasRange = _start != null;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text('Select Dates to see Prices',
                            style: AppConst.t2.copyWith(fontSize: 17)),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).maybePop(),
                        behavior: HitTestBehavior.opaque,
                        child: const Icon(Icons.close_rounded,
                            size: 22, color: AppConst.appBlack),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _DateField(
                    label: 'Check in Date',
                    value: _fmt(_start),
                    onTap: () => setState(() => _calendarOpen = true),
                  ),
                  const SizedBox(height: 14),
                  _DateField(
                    label: 'Check out Date',
                    value: _fmt(_end),
                    onTap: () => setState(() => _calendarOpen = true),
                  ),
                  if (_calendarOpen) ...[
                    const SizedBox(height: 20),
                    _MonthHeader(
                      month: _month,
                      onPrev: () => setState(() =>
                          _month = DateTime(_month.year, _month.month - 1)),
                      onNext: () => setState(() =>
                          _month = DateTime(_month.year, _month.month + 1)),
                    ),
                    const SizedBox(height: 14),
                    _MonthGrid(
                      month: _month,
                      start: _start,
                      end: _end,
                      onTap: _onDayTap,
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Footer
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 18),
            child: !_calendarOpen
                ? _PrimaryButton(label: 'Continue', onTap: _continue)
                : Row(
                    children: [
                      if (hasRange)
                        GestureDetector(
                          onTap: _clear,
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text('Clear dates',
                                style: AppConst.body.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: AppConst.appBlack)),
                          ),
                        ),
                      const Spacer(),
                      _PrimaryButton(label: 'Continue', onTap: _continue),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _DateField(
      {required this.label, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConst.radius),
          border: Border.all(color: AppConst.gray.withOpacity(0.7)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: AppConst.caption.copyWith(
                          color: AppConst.darkGray, fontSize: 11.5)),
                  const SizedBox(height: 4),
                  Text(value.isEmpty ? 'Select date' : value,
                      style: AppConst.body.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: value.isEmpty
                              ? AppConst.darkGray
                              : AppConst.appBlack)),
                ],
              ),
            ),
            const Icon(Icons.calendar_month_outlined,
                size: 20, color: AppConst.darkGray),
          ],
        ),
      ),
    );
  }
}

class _MonthHeader extends StatelessWidget {
  final DateTime month;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const _MonthHeader(
      {required this.month, required this.onPrev, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('${_monthName(month.month)} ${month.year}',
            style: AppConst.t2.copyWith(fontSize: 18)),
        const Spacer(),
        _NavArrow(icon: Icons.chevron_left_rounded, onTap: onPrev),
        const SizedBox(width: 14),
        _NavArrow(icon: Icons.chevron_right_rounded, onTap: onNext),
      ],
    );
  }

  static String _monthName(int m) {
    const full = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return full[m - 1];
  }
}

class _NavArrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NavArrow({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Icon(icon, size: 26, color: AppConst.appBlack),
    );
  }
}

class _MonthGrid extends StatelessWidget {
  final DateTime month;
  final DateTime? start;
  final DateTime? end;
  final ValueChanged<DateTime> onTap;

  const _MonthGrid({
    required this.month,
    required this.start,
    required this.end,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const labels = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final firstWeekday = DateTime(month.year, month.month, 1).weekday; // 1=Mon

    // Build a flat list of cells: leading blanks then days.
    final cells = <DateTime?>[];
    for (var i = 1; i < firstWeekday; i++) {
      cells.add(null);
    }
    for (var d = 1; d <= daysInMonth; d++) {
      cells.add(DateTime(month.year, month.month, d));
    }
    while (cells.length % 7 != 0) {
      cells.add(null);
    }

    final rows = <Widget>[];
    for (var i = 0; i < cells.length; i += 7) {
      rows.add(Row(
        children: [
          for (final c in cells.sublist(i, i + 7))
            Expanded(child: _DayCell(day: c, start: start, end: end, onTap: onTap)),
        ],
      ));
    }

    return Column(
      children: [
        Row(
          children: [
            for (final l in labels)
              Expanded(
                child: Center(
                  child: Text(l,
                      style: AppConst.body.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: AppConst.appBlack)),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        ...rows,
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  final DateTime? day;
  final DateTime? start;
  final DateTime? end;
  final ValueChanged<DateTime> onTap;

  const _DayCell({
    required this.day,
    required this.start,
    required this.end,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (day == null) return const SizedBox(height: 44);

    final d = day!;
    final isStart = start != null && _sameDay(d, start!);
    final isEnd = end != null && _sameDay(d, end!);
    final hasRange = start != null && end != null;
    final inBand =
        hasRange && !d.isBefore(start!) && !d.isAfter(end!); // inclusive
    final endpoint = isStart || isEnd;

    // The pink band fills the cell width so adjacent days connect, but each
    // row-segment gets rounded ends: at the range start/end and at the week
    // edges (Monday / Sunday).
    const radius = Radius.circular(20);
    final col = d.weekday - 1; // Mon = 0 … Sun = 6
    final roundLeft = isStart || col == 0;
    final roundRight = isEnd || col == 6;

    Widget? band;
    if (inBand && !(isStart && isEnd)) {
      band = Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppConst.primary.withOpacity(0.16),
            borderRadius: BorderRadius.horizontal(
              left: roundLeft ? radius : Radius.zero,
              right: roundRight ? radius : Radius.zero,
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => onTap(d),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 44,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (band != null) Positioned.fill(child: band),
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: endpoint
                  ? const BoxDecoration(
                      color: AppConst.primary, shape: BoxShape.circle)
                  : null,
              child: Text(
                '${d.day}',
                style: AppConst.body.copyWith(
                  fontSize: 14,
                  fontWeight: endpoint ? FontWeight.w700 : FontWeight.w500,
                  color: endpoint ? Colors.white : AppConst.appBlack,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppConst.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 15),
      ),
      child: Text(label,
          style: AppConst.body.copyWith(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
    );
  }
}
