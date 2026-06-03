/// Static mock data for the Account / Profile tab.

class TenantInfo {
  final String name;
  final String designation;
  final String gender;
  final String nationality;
  final String from;
  final String? tenure;
  final int seed;

  const TenantInfo({
    required this.name,
    required this.designation,
    required this.gender,
    required this.nationality,
    required this.from,
    this.tenure,
    this.seed = 0,
  });
}

class ProfileMockData {
  ProfileMockData._();

  static const String name = 'Sarah Willams';
  static const String role = 'Tenant';
  static const String mobile = '+919087654323';
  static const String email = 'sarah@gmail.com';

  static const String propertyName = 'A101- Future Apartments- Dubai';
  static const String price = '100 €';
  static const String area = 'Al Lesaily';
  static const String city = 'Dubai';
  static const String moveInDate = 'Nov 15, 2025';
  static const String contractStart = 'Nov 15, 2025';
  static const String contractEnds = 'Nov 15, 2027';

  static const List<TenantInfo> tenants = [
    TenantInfo(
      name: 'Nisha Deo',
      designation: 'Student',
      gender: 'Female',
      nationality: 'Indian',
      from: 'Mumbai',
      tenure: '10/08/25 - 10/27/25',
      seed: 3,
    ),
    TenantInfo(
      name: 'Christopher K.',
      designation: 'Musician',
      gender: 'Male',
      nationality: 'Spain',
      from: 'Barcelona',
      tenure: '02/08/25 - 06/25/29',
      seed: 1,
    ),
    TenantInfo(
      name: 'Natasha V.',
      designation: 'Student',
      gender: 'Female',
      nationality: 'Italy',
      from: 'Rome',
      seed: 6,
    ),
  ];
}
