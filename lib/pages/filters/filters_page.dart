import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../const/app_const.dart';
import '../../providers/filter_provider.dart';

/// Property search filters — opened from the homepage Filters button.
///
/// Edits a local draft seeded from [FilterProvider]; "Apply Filters" commits
/// the draft back to the provider so it persists across screens.
class FiltersPage extends StatefulWidget {
  const FiltersPage({super.key});

  @override
  State<FiltersPage> createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  late Set<String> _propertyTypes;
  late String _fromDate;
  late String _toDate;
  late String _currency;
  late String? _gender;
  late Set<String> _bedTypes;
  late bool _furnished;
  late bool _unfurnished;
  late bool _checkedByKnocksy;
  late bool _noDeposit;

  late final TextEditingController _budgetMin;
  late final TextEditingController _budgetMax;
  late final TextEditingController _sizeMin;
  late final TextEditingController _sizeMax;

  @override
  void initState() {
    super.initState();
    final f = context.read<FilterProvider>();
    _propertyTypes = {...f.propertyTypes};
    _fromDate = f.fromDate;
    _toDate = f.toDate;
    _currency = f.currency;
    _gender = f.gender;
    _bedTypes = {...f.bedTypes};
    _furnished = f.furnished;
    _unfurnished = f.unfurnished;
    _checkedByKnocksy = f.checkedByKnocksy;
    _noDeposit = f.noDeposit;
    _budgetMin = TextEditingController(text: '${f.budgetMin}');
    _budgetMax = TextEditingController(text: '${f.budgetMax}');
    _sizeMin = TextEditingController(text: f.sizeMin);
    _sizeMax = TextEditingController(text: f.sizeMax);
  }

  @override
  void dispose() {
    _budgetMin.dispose();
    _budgetMax.dispose();
    _sizeMin.dispose();
    _sizeMax.dispose();
    super.dispose();
  }

  int get _activeCount {
    var c = _propertyTypes.length + _bedTypes.length;
    if (_gender != null) c++;
    if (_furnished) c++;
    if (_unfurnished) c++;
    if (_checkedByKnocksy) c++;
    if (_noDeposit) c++;
    return c;
  }

  void _resetAll() {
    setState(() {
      _propertyTypes = {};
      _fromDate = '09-10-2025';
      _toDate = '09-10-2025';
      _currency = 'Euros €';
      _gender = null;
      _bedTypes = {};
      _furnished = false;
      _unfurnished = false;
      _checkedByKnocksy = false;
      _noDeposit = false;
      _budgetMin.text = '200';
      _budgetMax.text = '3928';
      _sizeMin.text = '0m';
      _sizeMax.text = 'No Maximum';
    });
  }

  void _apply() {
    context.read<FilterProvider>().commit(
          propertyTypes: _propertyTypes,
          fromDate: _fromDate,
          toDate: _toDate,
          currency: _currency,
          budgetMin: int.tryParse(_budgetMin.text.trim()) ?? 0,
          budgetMax: int.tryParse(_budgetMax.text.trim()) ?? 0,
          gender: _gender,
          sizeMin: _sizeMin.text.trim(),
          sizeMax: _sizeMax.text.trim(),
          bedTypes: _bedTypes,
          furnished: _furnished,
          unfurnished: _unfurnished,
          checkedByKnocksy: _checkedByKnocksy,
          noDeposit: _noDeposit,
        );
    Navigator.of(context).maybePop();
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (picked == null) return;
    setState(() {
      final s = _fmt(picked);
      if (isFrom) {
        _fromDate = s;
      } else {
        _toDate = s;
      }
    });
  }

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';

  void _quickRange(int days) {
    final now = DateTime.now();
    setState(() {
      _fromDate = _fmt(now);
      _toDate = _fmt(now.add(Duration(days: days)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _BottomBar(
        count: _activeCount,
        onResetAll: _resetAll,
        onApply: _apply,
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    behavior: HitTestBehavior.opaque,
                    child: const Icon(Icons.chevron_left_rounded,
                        size: 28, color: AppConst.appBlack),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _resetAll,
                    behavior: HitTestBehavior.opaque,
                    child: Text('Reset',
                        style: AppConst.body.copyWith(
                            color: AppConst.accent,
                            fontWeight: FontWeight.w600,
                            fontSize: 14)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                physics: AppConst.scrollPhysics,
                children: [
                  // -------------------------------------- Property type
                  const _SectionTitle('Property type'),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 10,
                    runSpacing: 12,
                    children: [
                      for (final t in FilterProvider.propertyTypeOptions)
                        _Chip(
                          label: t,
                          selected: _propertyTypes.contains(t),
                          onTap: () => setState(() => _propertyTypes.contains(t)
                              ? _propertyTypes.remove(t)
                              : _propertyTypes.add(t)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(
                      height: 1, thickness: 1, color: AppConst.lightGray),
                  const SizedBox(height: 20),

                  // -------------------------------------- Date Range
                  _SectionTitle('Date Range', onReset: () {
                    setState(() {
                      _fromDate = '09-10-2025';
                      _toDate = '09-10-2025';
                    });
                  }),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _DateField(
                          label: 'From',
                          value: _fromDate,
                          onTap: () => _pickDate(isFrom: true),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _DateField(
                          label: 'To',
                          value: _toDate,
                          onTap: () => _pickDate(isFrom: false),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                          child: _QuickChip(
                              label: 'Today', onTap: () => _quickRange(0))),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _QuickChip(
                              label: 'This Week', onTap: () => _quickRange(7))),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _QuickChip(
                              label: 'This Month',
                              onTap: () => _quickRange(30))),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(
                      height: 1, thickness: 1, color: AppConst.lightGray),
                  const SizedBox(height: 20),

                  // -------------------------------------- Budget Range
                  Row(
                    children: [
                      const _SectionTitle('Budget Range'),
                      const Spacer(),
                      _CurrencyDropdown(
                        value: _currency,
                        onChanged: (v) => setState(() => _currency = v),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _AmountField(
                          label: 'Minimum',
                          controller: _budgetMin,
                          prefix: '€',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _AmountField(
                          label: 'Maximum',
                          controller: _budgetMax,
                          prefix: '€',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // -------------------------------------- Gender
                  const _SectionTitle('Gender'),
                  const SizedBox(height: 14),
                  _TwoColumnWrap(
                    children: [
                      for (final g in FilterProvider.genderOptions)
                        _WideOption(
                          label: g,
                          selected: _gender == g,
                          onTap: () => setState(
                              () => _gender = _gender == g ? null : g),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // -------------------------------------- Size
                  const _SectionTitle('Size(m^2)'),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _AmountField(
                          label: 'Minimum',
                          controller: _sizeMin,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _AmountField(
                          label: 'Maximum',
                          controller: _sizeMax,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // -------------------------------------- Type of Bed
                  const _SectionTitle('Type of Bed'),
                  const SizedBox(height: 14),
                  _TwoColumnWrap(
                    children: [
                      for (final b in FilterProvider.bedOptions)
                        _WideOption(
                          label: b,
                          selected: _bedTypes.contains(b),
                          onTap: () => setState(() => _bedTypes.contains(b)
                              ? _bedTypes.remove(b)
                              : _bedTypes.add(b)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(
                      height: 1, thickness: 1, color: AppConst.lightGray),
                  const SizedBox(height: 20),

                  // -------------------------------------- Furnish Options
                  const _SectionTitle('Furnish Options'),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _CheckRow(
                          icon: Icons.verified_outlined,
                          label: 'Furnished',
                          value: _furnished,
                          onChanged: (v) => setState(() => _furnished = v),
                        ),
                      ),
                      Expanded(
                        child: _CheckRow(
                          icon: Icons.crop_square,
                          label: 'Unfurnished',
                          value: _unfurnished,
                          onChanged: (v) => setState(() => _unfurnished = v),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(
                      height: 1, thickness: 1, color: AppConst.lightGray),
                  const SizedBox(height: 20),

                  // -------------------------------------- Advanced Search
                  const _SectionTitle('Advanced Search'),
                  const SizedBox(height: 14),
                  _CheckRow(
                    icon: Icons.verified_user_outlined,
                    value: _checkedByKnocksy,
                    onChanged: (v) => setState(() => _checkedByKnocksy = v),
                    richText: const _RichLabel(
                      bold: 'Checked by Knocksy',
                      rest: ' - Our team has verified this property',
                    ),
                  ),
                  const SizedBox(height: 16),
                  _CheckRow(
                    icon: Icons.money_off,
                    value: _noDeposit,
                    onChanged: (v) => setState(() => _noDeposit = v),
                    richText: const _RichLabel(
                      bold: 'No Deposit',
                      rest: ' -  Properties that don\'t require a deposit',
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

// ------------------------------------------------------------------ Widgets

class _SectionTitle extends StatelessWidget {
  final String text;
  final VoidCallback? onReset;

  const _SectionTitle(this.text, {this.onReset});

  @override
  Widget build(BuildContext context) {
    final title = Text(text,
        style: AppConst.t2.copyWith(fontSize: 17, color: AppConst.appBlack));
    if (onReset == null) return title;
    return Row(
      children: [
        title,
        const Spacer(),
        GestureDetector(
          onTap: onReset,
          behavior: HitTestBehavior.opaque,
          child: Text('Reset',
              style: AppConst.body.copyWith(
                  color: AppConst.accent,
                  fontWeight: FontWeight.w600,
                  fontSize: 14)),
        ),
      ],
    );
  }
}

/// Content-sized selectable pill (Property type).
class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Chip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        decoration: BoxDecoration(
          color: selected ? AppConst.primary : Colors.white,
          borderRadius: BorderRadius.circular(AppConst.radius),
          border: Border.all(
            color: selected ? AppConst.primary : AppConst.gray.withOpacity(0.7),
            width: 1.3,
          ),
        ),
        child: Text(
          label,
          style: AppConst.body.copyWith(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : AppConst.appBlack,
          ),
        ),
      ),
    );
  }
}

/// Two equal-width columns that wrap to new rows.
class _TwoColumnWrap extends StatelessWidget {
  final List<Widget> children;
  const _TwoColumnWrap({required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        const gap = 16.0;
        final w = (c.maxWidth - gap) / 2;
        return Wrap(
          spacing: gap,
          runSpacing: 12,
          children: [
            for (final child in children) SizedBox(width: w, child: child),
          ],
        );
      },
    );
  }
}

/// Half-width selectable box (Gender / Type of Bed).
class _WideOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _WideOption(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: selected ? AppConst.primary : Colors.white,
          borderRadius: BorderRadius.circular(AppConst.radius),
          border: Border.all(
            color: selected ? AppConst.primary : AppConst.gray.withOpacity(0.7),
            width: 1.3,
          ),
        ),
        child: Text(
          label,
          style: AppConst.body.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : AppConst.appBlack,
          ),
        ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                AppConst.caption.copyWith(color: AppConst.darkGray, fontSize: 13)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: AppConst.lightGray.withOpacity(0.5),
              borderRadius: BorderRadius.circular(AppConst.radius),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(value,
                      style: AppConst.body.copyWith(
                          fontSize: 14, color: AppConst.appBlack)),
                ),
                const Icon(Icons.calendar_month_outlined,
                    size: 18, color: AppConst.darkGray),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConst.radius),
          border: Border.all(color: AppConst.gray.withOpacity(0.7), width: 1.3),
        ),
        child: Text(label,
            style: AppConst.body.copyWith(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: AppConst.appBlack)),
      ),
    );
  }
}

class _CurrencyDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _CurrencyDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppConst.lightGray.withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppConst.radius),
        border: Border.all(color: AppConst.gray.withOpacity(0.6)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
          items: [
            for (final c in FilterProvider.currencies)
              DropdownMenuItem(value: c, child: Text(c)),
          ],
          style: AppConst.body
              .copyWith(fontSize: 13.5, color: AppConst.appBlack),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

class _AmountField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? prefix;

  const _AmountField({
    required this.label,
    required this.controller,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                AppConst.caption.copyWith(color: AppConst.darkGray, fontSize: 13)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppConst.lightGray.withOpacity(0.5),
            borderRadius: BorderRadius.circular(AppConst.radius),
          ),
          child: Row(
            children: [
              if (prefix != null) ...[
                Text(prefix!,
                    style: AppConst.body.copyWith(
                        color: AppConst.darkGray, fontSize: 14)),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: TextField(
                  controller: controller,
                  style: AppConst.body
                      .copyWith(fontSize: 14, color: AppConst.appBlack),
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RichLabel extends StatelessWidget {
  final String bold;
  final String rest;
  const _RichLabel({required this.bold, required this.rest});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: AppConst.body.copyWith(fontSize: 13.5, color: AppConst.appBlack),
        children: [
          TextSpan(text: bold, style: const TextStyle(fontWeight: FontWeight.w700)),
          TextSpan(
              text: rest, style: const TextStyle(color: AppConst.darkGray)),
        ],
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  final IconData icon;
  final String? label;
  final Widget? richText;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _CheckRow({
    required this.icon,
    this.label,
    this.richText,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CheckSquare(value: value),
          const SizedBox(width: 10),
          Icon(icon, size: 20, color: AppConst.appBlack),
          const SizedBox(width: 8),
          Expanded(
            child: richText ??
                Text(
                  label ?? '',
                  style: AppConst.body.copyWith(
                      fontWeight: FontWeight.w700, fontSize: 14),
                ),
          ),
        ],
      ),
    );
  }
}

class _CheckSquare extends StatelessWidget {
  final bool value;
  const _CheckSquare({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: value ? AppConst.primary : Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: value ? AppConst.primary : AppConst.gray,
          width: 1.5,
        ),
      ),
      child: value
          ? const Icon(Icons.check, size: 14, color: Colors.white)
          : null,
    );
  }
}

class _BottomBar extends StatelessWidget {
  final int count;
  final VoidCallback onResetAll;
  final VoidCallback onApply;

  const _BottomBar({
    required this.count,
    required this.onResetAll,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: onResetAll,
                  style: TextButton.styleFrom(
                    backgroundColor: AppConst.primary.withOpacity(0.1),
                    foregroundColor: AppConst.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text('Reset All',
                      style: AppConst.body.copyWith(
                          color: AppConst.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 15)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: ElevatedButton(
                  onPressed: onApply,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConst.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text('Apply Filters($count)',
                      style: AppConst.body.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
