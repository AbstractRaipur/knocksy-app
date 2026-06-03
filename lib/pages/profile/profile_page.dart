import 'package:flutter/material.dart';

import '../../const/app_const.dart';
import '../home/home_models.dart';
import '../home/widgets/card_image.dart';
import 'profile_models.dart';

/// Account / Profile tab — matches the Figma reference. Static mock data
/// ([ProfileMockData]); the bottom nav is owned by [MainShell].
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _tenantsExpanded = true;

  void _noop() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
              child: Row(
                children: [
                  Text('Account', style: AppConst.t1.copyWith(fontSize: 24)),
                  const Spacer(),
                  GestureDetector(
                    onTap: _noop,
                    behavior: HitTestBehavior.opaque,
                    child: Text('Edit',
                        style: AppConst.body.copyWith(
                            color: AppConst.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 15)),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: AppConst.lightGray),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                physics: AppConst.scrollPhysics,
                children: [
                  const _ProfileCard(),
                  const SizedBox(height: 16),
                  _PropertyCard(onMessage: _noop),
                  const SizedBox(height: 16),
                  _MenuTile(label: 'Help & support', onTap: _noop),
                  const SizedBox(height: 12),
                  _MenuTile(label: 'Terms & conditions', onTap: _noop),
                  const SizedBox(height: 12),
                  _MenuTile(label: 'Send feedback', onTap: _noop),
                  const SizedBox(height: 12),
                  _MenuTile(label: 'About us', onTap: _noop),
                  const SizedBox(height: 16),
                  _TenantsCard(
                    expanded: _tenantsExpanded,
                    onToggle: () => setState(
                        () => _tenantsExpanded = !_tenantsExpanded),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: _noop,
                      behavior: HitTestBehavior.opaque,
                      child: Text('Sign out',
                          style: AppConst.body.copyWith(
                              color: AppConst.accent,
                              fontWeight: FontWeight.w600,
                              fontSize: 15)),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------- Profile
class _ProfileCard extends StatelessWidget {
  const _ProfileCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppConst.gray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Avatar(name: ProfileMockData.name, seed: 4, size: 60),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ProfileMockData.name,
                      style: AppConst.t2.copyWith(fontSize: 18)),
                  const SizedBox(height: 2),
                  Text(ProfileMockData.role,
                      style: AppConst.body.copyWith(
                          color: AppConst.darkGray, fontSize: 13.5)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const _LabelValue(
              label: 'Registered mobile number',
              value: ProfileMockData.mobile),
          const SizedBox(height: 16),
          const _LabelValue(
              label: 'Registered email ID', value: ProfileMockData.email),
        ],
      ),
    );
  }
}

class _LabelValue extends StatelessWidget {
  final String label;
  final String value;

  const _LabelValue({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                AppConst.body.copyWith(color: AppConst.darkGray, fontSize: 13.5)),
        const SizedBox(height: 4),
        Text(value,
            style: AppConst.body
                .copyWith(fontWeight: FontWeight.w700, fontSize: 15)),
      ],
    );
  }
}

// ----------------------------------------------------------------- Property
class _PropertyCard extends StatelessWidget {
  final VoidCallback onMessage;

  const _PropertyCard({required this.onMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color(0xffFCE4D8)],
        ),
      ),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: CardImage(
                    asset: null,
                    url: HomeMockData.propertyPhoto,
                    fallbackIcon: Icons.home_work_outlined,
                  ),
                ),
              ),
              Positioned(
                left: 14,
                right: 14,
                bottom: -36,
                child: _PropertyInfoCard(),
              ),
            ],
          ),
          const SizedBox(height: 48),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Expanded(
                    child: _DateStat(
                        label: 'Move-in Date',
                        value: ProfileMockData.moveInDate)),
                Expanded(
                    child: _DateStat(
                        label: 'Contract Start',
                        value: ProfileMockData.contractStart)),
                Expanded(
                    child: _DateStat(
                        label: 'Contract Ends',
                        value: ProfileMockData.contractEnds)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Center(
              child: ElevatedButton.icon(
                onPressed: onMessage,
                icon: const Icon(Icons.chat_bubble_outline_rounded,
                    size: 20, color: Colors.white),
                label: Text('Message Landlord',
                    style: AppConst.body.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConst.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 11),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PropertyInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [AppConst.softShadow],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ProfileMockData.propertyName,
                    style: AppConst.caption.copyWith(
                        fontSize: 12.5, color: AppConst.appBlack)),
                const SizedBox(height: 4),
                Text(ProfileMockData.price,
                    style: AppConst.t1.copyWith(fontSize: 24)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 15, color: AppConst.darkGray),
                    const SizedBox(width: 4),
                    Text(ProfileMockData.area,
                        style: AppConst.caption.copyWith(
                            fontSize: 12, color: AppConst.darkGray)),
                    const Spacer(),
                    Text(ProfileMockData.city,
                        style: AppConst.caption.copyWith(
                            fontSize: 12, color: AppConst.darkGray)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xff7FCE60),
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Text('Active Property',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 10.5)),
          ),
        ],
      ),
    );
  }
}

class _DateStat extends StatelessWidget {
  final String label;
  final String value;

  const _DateStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppConst.body
                .copyWith(fontWeight: FontWeight.w700, fontSize: 13)),
        const SizedBox(height: 4),
        Text(value,
            style:
                AppConst.caption.copyWith(color: AppConst.darkGray, fontSize: 12.5)),
      ],
    );
  }
}

// ----------------------------------------------------------------- Menu tile
class _MenuTile extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _MenuTile({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 63,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppConst.gray),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(label,
                  style: AppConst.body.copyWith(
                      fontWeight: FontWeight.w600, fontSize: 15)),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppConst.darkGray, size: 24),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------- Tenants
class _TenantsCard extends StatelessWidget {
  final bool expanded;
  final VoidCallback onToggle;

  const _TenantsCard({required this.expanded, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final tenants = ProfileMockData.tenants;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppConst.gray),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onToggle,
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Expanded(
                  child: Text('Meet Your Tenants',
                      style: AppConst.t2.copyWith(fontSize: 16)),
                ),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: AppConst.darkGray,
                  size: 24,
                ),
              ],
            ),
          ),
          if (expanded)
            for (var i = 0; i < tenants.length; i++) ...[
              const SizedBox(height: 16),
              _TenantRow(tenant: tenants[i]),
              if (i != tenants.length - 1) ...[
                const SizedBox(height: 16),
                const Divider(
                    height: 1, thickness: 1, color: AppConst.lightGray),
              ],
            ],
        ],
      ),
    );
  }
}

class _TenantRow extends StatelessWidget {
  final TenantInfo tenant;

  const _TenantRow({required this.tenant});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Avatar(name: tenant.name, seed: tenant.seed, size: 44),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tenant.name,
                  style: AppConst.body.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: AppConst.appBlack)),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                      child: _MiniFact(
                          label: 'Designation', value: tenant.designation)),
                  Expanded(
                      child:
                          _MiniFact(label: 'Gender', value: tenant.gender)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                      child: _MiniFact(
                          label: 'Nationality', value: tenant.nationality)),
                  Expanded(
                      child: _MiniFact(label: 'From', value: tenant.from)),
                ],
              ),
              if (tenant.tenure != null) ...[
                const SizedBox(height: 4),
                _MiniFact(label: 'Tenure', value: tenant.tenure!),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _MiniFact extends StatelessWidget {
  final String label;
  final String value;

  const _MiniFact({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$label - $value',
      style: AppConst.caption.copyWith(
        fontSize: 11.5,
        color: AppConst.darkGray,
        height: 1.3,
      ),
    );
  }
}

// ----------------------------------------------------------------- Avatar
class _Avatar extends StatelessWidget {
  final String name;
  final int seed;
  final double size;

  const _Avatar({required this.name, required this.seed, this.size = 48});

  @override
  Widget build(BuildContext context) {
    final colors = HomeMockData.placeholderGradient(seed);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        name.isNotEmpty ? name.substring(0, 1) : '?',
        style: AppConst.t2.copyWith(color: Colors.white, fontSize: size * 0.38),
      ),
    );
  }
}
