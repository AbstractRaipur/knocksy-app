/// Static mock data backing the renter dashboard.

enum TxnStatus { paid, overdue, pending }

class RentTransaction {
  final String property;
  final String tenant;
  final double amount;
  final String dateLabel; // e.g. "Paid on 20/Nov/2025" or "Due on 30/Dec/2025"
  final TxnStatus status;

  const RentTransaction({
    required this.property,
    required this.tenant,
    required this.amount,
    required this.dateLabel,
    required this.status,
  });
}

class RenterMockData {
  RenterMockData._();

  static const String userName = 'Sara';
  static const String propertyName = 'A101 - Future Towers';
  static const String unit = 'Unit 3A';
  static const String street = '123 Oak Street';
  static const String netRent = '€ 100';
  static const String netDeposit = '€ 100';
  static const String contractEnds = '21 Dec 2028';

  static const String rentStatusMonth = 'November 2023';
  static const int totalTransactions = 8;

  static const int paidCount = 10;

  static const List<RentTransaction> transactions = [
    RentTransaction(
      property: 'A101 - Future Towers',
      tenant: 'John Smith',
      amount: 50,
      dateLabel: 'Due on 30/Dec/2025',
      status: TxnStatus.pending,
    ),
    RentTransaction(
      property: 'A101 - Future Towers',
      tenant: 'John Smith',
      amount: 50,
      dateLabel: 'Paid on 20/Nov/2025',
      status: TxnStatus.paid,
    ),
    RentTransaction(
      property: 'A101 - Future Towers',
      tenant: 'John Smith',
      amount: 50,
      dateLabel: 'Paid on 20/Oct/2025',
      status: TxnStatus.paid,
    ),
    RentTransaction(
      property: 'A101 - Future Towers',
      tenant: 'John Smith',
      amount: 50,
      dateLabel: 'Paid on 20/Sep/2025',
      status: TxnStatus.paid,
    ),
  ];

  /// Formats an amount as "€ 50,00" (comma decimal, matching the design).
  static String formatAmount(double value) {
    final s = value.toStringAsFixed(2).replaceAll('.', ',');
    return '€ $s';
  }
}
