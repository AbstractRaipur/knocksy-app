import 'package:flutter/material.dart';

import '../../../const/app_const.dart';
import '../../home/widgets/card_image.dart';
import 'wizard_fields.dart';

/// Step 2 of the booking wizard — rental details + required documents.
class RentalDetailsStep extends StatefulWidget {
  const RentalDetailsStep({super.key});

  @override
  State<RentalDetailsStep> createState() => _RentalDetailsStepState();
}

class _RentalDetailsStepState extends State<RentalDetailsStep> {
  String _proof = 'Bank Statement';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      physics: AppConst.scrollPhysics,
      children: [
        Text('Rental Details', style: AppConst.t1.copyWith(fontSize: 22)),
        const SizedBox(height: 20),
        const WizardField(label: 'Where do you work?'),
        const SizedBox(height: 16),
        const WizardField(label: 'What is your job title?*'),
        const SizedBox(height: 24),
        Text('Required Tenant Document',
            style: AppConst.t2.copyWith(fontSize: 18)),
        const SizedBox(height: 16),
        const WizardField(label: 'Govt. issued ID/Passport/Driver License*'),
        const SizedBox(height: 16),
        WizardDropdown(
          label: 'Select Proof of Documents*',
          value: _proof,
          items: const [
            'Bank Statement',
            'Salary Slip',
            'Employment Letter',
            'Tax Return',
          ],
          onChanged: (v) => setState(() => _proof = v ?? _proof),
        ),
        const SizedBox(height: 16),
        const _UploadCard(),
      ],
    );
  }
}

class _UploadCard extends StatelessWidget {
  const _UploadCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConst.lightGray.withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppConst.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppConst.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.file_upload_outlined,
                    color: AppConst.primary, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Upload your document here',
                        style: AppConst.body.copyWith(
                            fontWeight: FontWeight.w700, fontSize: 13.5)),
                    const SizedBox(height: 2),
                    Text('Support for JPC, PNG, WebP files upto 15MB',
                        style: AppConst.caption.copyWith(
                            fontSize: 11, color: AppConst.darkGray)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              // First slot — an uploaded thumbnail.
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: const SizedBox(
                  width: 52,
                  height: 52,
                  child: CardImage(
                    asset: null,
                    seed: 0,
                    fallbackIcon: Icons.description_outlined,
                  ),
                ),
              ),
              for (var i = 0; i < 8; i++) const UploadSlot(),
            ],
          ),
        ],
      ),
    );
  }
}
