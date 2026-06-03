import 'package:flutter/material.dart';

import '../../../const/app_const.dart';
import 'wizard_fields.dart';

/// Step 1 of the booking wizard — tenant personal details.
class PersonalDetailsStep extends StatefulWidget {
  const PersonalDetailsStep({super.key});

  @override
  State<PersonalDetailsStep> createState() => _PersonalDetailsStepState();
}

class _PersonalDetailsStepState extends State<PersonalDetailsStep> {
  String _country = 'India';
  String _type = 'Professional';
  String _dob = '';

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: now,
    );
    if (picked == null) return;
    setState(() => _dob =
        '${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}');
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      physics: AppConst.scrollPhysics,
      children: [
        Text('Personal Details', style: AppConst.t1.copyWith(fontSize: 22)),
        const SizedBox(height: 20),
        const WizardField(label: 'Full Name*', initialValue: 'David'),
        const SizedBox(height: 16),
        const WizardField(label: 'Email', keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 16),
        const WizardField(label: 'Telephone', keyboardType: TextInputType.phone),
        const SizedBox(height: 16),
        const WizardField(label: 'Line 1*'),
        const SizedBox(height: 16),
        const WizardField(label: 'Line 2(optional)'),
        const SizedBox(height: 16),
        WizardField(
          label: 'Date of Birth*',
          hint: 'MM/DD/YYYY',
          readOnly: true,
          onTap: _pickDob,
          controller: TextEditingController(text: _dob),
          suffix: const Icon(Icons.calendar_month_outlined,
              size: 20, color: AppConst.darkGray),
        ),
        const SizedBox(height: 16),
        WizardDropdown(
          label: 'Country*',
          value: _country,
          items: const ['India', 'UAE', 'Spain', 'Italy', 'Poland'],
          onChanged: (v) => setState(() => _country = v ?? _country),
        ),
        const SizedBox(height: 16),
        WizardDropdown(
          label: 'Student or Professional*',
          value: _type,
          items: const ['Student', 'Professional'],
          onChanged: (v) => setState(() => _type = v ?? _type),
        ),
      ],
    );
  }
}
