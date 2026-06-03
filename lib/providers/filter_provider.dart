import 'package:flutter/foundation.dart';

/// Holds the property search filters so they persist across screens.
///
/// The filters page edits a local draft and calls [commit] on "Apply
/// Filters"; everything else reads the committed values (e.g. an "active
/// filters" badge on the home screen).
class FilterProvider extends ChangeNotifier {
  // Only Euro is supported for now.
  static const List<String> currencies = ['Euros €'];

  static const List<String> propertyTypeOptions = [
    'Shared room',
    'Private room',
    'Studio Apartment',
    'Apartment',
    'Student Residence',
    'Professional Residence',
  ];
  static const List<String> genderOptions = ['Any gender', 'Female', 'Male'];
  static const List<String> bedOptions = ['Single Bed', 'Double Bed', 'Twin Bed'];

  Set<String> propertyTypes = {'Shared room'};
  String fromDate = '09-10-2025';
  String toDate = '09-10-2025';
  String currency = 'Euros €';
  int budgetMin = 200;
  int budgetMax = 3928;
  String? gender;
  String sizeMin = '0m';
  String sizeMax = 'No Maximum';
  Set<String> bedTypes = {};
  bool furnished = false;
  bool unfurnished = false;
  bool checkedByKnocksy = false;
  bool noDeposit = false;

  /// Number of active filters — drives the "Apply Filters(N)" label.
  int get activeCount {
    var c = propertyTypes.length + bedTypes.length;
    if (gender != null) c++;
    if (furnished) c++;
    if (unfurnished) c++;
    if (checkedByKnocksy) c++;
    if (noDeposit) c++;
    return c;
  }

  /// Persist a draft from the filters page.
  void commit({
    required Set<String> propertyTypes,
    required String fromDate,
    required String toDate,
    required String currency,
    required int budgetMin,
    required int budgetMax,
    required String? gender,
    required String sizeMin,
    required String sizeMax,
    required Set<String> bedTypes,
    required bool furnished,
    required bool unfurnished,
    required bool checkedByKnocksy,
    required bool noDeposit,
  }) {
    this.propertyTypes = propertyTypes;
    this.fromDate = fromDate;
    this.toDate = toDate;
    this.currency = currency;
    this.budgetMin = budgetMin;
    this.budgetMax = budgetMax;
    this.gender = gender;
    this.sizeMin = sizeMin;
    this.sizeMax = sizeMax;
    this.bedTypes = bedTypes;
    this.furnished = furnished;
    this.unfurnished = unfurnished;
    this.checkedByKnocksy = checkedByKnocksy;
    this.noDeposit = noDeposit;
    notifyListeners();
  }

  /// Clear everything back to defaults.
  void resetAll() {
    propertyTypes = {};
    fromDate = '09-10-2025';
    toDate = '09-10-2025';
    currency = 'Euros €';
    budgetMin = 200;
    budgetMax = 3928;
    gender = null;
    sizeMin = '0m';
    sizeMax = 'No Maximum';
    bedTypes = {};
    furnished = false;
    unfurnished = false;
    checkedByKnocksy = false;
    noDeposit = false;
    notifyListeners();
  }
}
