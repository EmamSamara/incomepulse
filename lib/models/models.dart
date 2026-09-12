class FixedExpense {
  const FixedExpense({
    this.id,
    required this.name,
    required this.amount,
    this.category = '',
  });
  final int? id;
  final String name;
  final double amount;
  final String category;

  factory FixedExpense.fromMap(Map<String, Object?> map) => FixedExpense(
    id: map['id'] as int?,
    name: map['name'] as String,
    amount: (map['amount'] as num).toDouble(),
    category: (map['category'] as String?) ?? '',
  );
  Map<String, Object?> toMap() => {
    'id': id,
    'name': name,
    'amount': amount,
    'category': category,
  };
}

class IncomeEntry {
  const IncomeEntry({
    this.id,
    required this.amount,
    required this.category,
    required this.date,
    this.note = '',
  });
  final int? id;
  final double amount;
  final String category;
  final DateTime date;
  final String note;

  factory IncomeEntry.fromMap(Map<String, Object?> map) => IncomeEntry(
    id: map['id'] as int?,
    amount: (map['amount'] as num).toDouble(),
    category: map['category'] as String,
    date: DateTime.parse(map['date'] as String),
    note: (map['note'] as String?) ?? '',
  );
  Map<String, Object?> toMap() => {
    'id': id,
    'type': 'income',
    'amount': amount,
    'category': category,
    'date': date.toIso8601String(),
    'note': note,
  };
}

class CurrencyOption {
  const CurrencyOption(this.code, this.name, this.symbol);
  final String code;
  final String name;
  final String symbol;
}

const currencyOptions = <CurrencyOption>[
  CurrencyOption('USD', 'US Dollar', '\$'),
  CurrencyOption('ILS', 'Israeli New Shekel', '₪'),
  CurrencyOption('EUR', 'Euro', '€'),
  CurrencyOption('GBP', 'British Pound', '£'),
  CurrencyOption('JOD', 'Jordanian Dinar', 'د.ا'),
  CurrencyOption('EGP', 'Egyptian Pound', 'E£'),
  CurrencyOption('SAR', 'Saudi Riyal', '﷼'),
  CurrencyOption('AED', 'UAE Dirham', 'د.إ'),
  CurrencyOption('QAR', 'Qatari Riyal', 'ر.ق'),
  CurrencyOption('KWD', 'Kuwaiti Dinar', 'د.ك'),
  CurrencyOption('CAD', 'Canadian Dollar', 'CA\$'),
  CurrencyOption('AUD', 'Australian Dollar', 'A\$'),
  CurrencyOption('NZD', 'New Zealand Dollar', 'NZ\$'),
  CurrencyOption('CHF', 'Swiss Franc', 'CHF'),
  CurrencyOption('JPY', 'Japanese Yen', '¥'),
  CurrencyOption('CNY', 'Chinese Yuan', '元'),
  CurrencyOption('INR', 'Indian Rupee', '₹'),
  CurrencyOption('BRL', 'Brazilian Real', 'R\$'),
  CurrencyOption('MXN', 'Mexican Peso', 'MX\$'),
  CurrencyOption('ZAR', 'South African Rand', 'R'),
  CurrencyOption('TRY', 'Turkish Lira', '₺'),
  CurrencyOption('RUB', 'Russian Ruble', '₽'),
  CurrencyOption('SEK', 'Swedish Krona', 'kr'),
  CurrencyOption('NOK', 'Norwegian Krone', 'kr'),
  CurrencyOption('DKK', 'Danish Krone', 'kr'),
  CurrencyOption('PLN', 'Polish Zloty', 'zł'),
  CurrencyOption('CZK', 'Czech Koruna', 'Kč'),
  CurrencyOption('HUF', 'Hungarian Forint', 'Ft'),
  CurrencyOption('RON', 'Romanian Leu', 'lei'),
  CurrencyOption('SGD', 'Singapore Dollar', 'S\$'),
  CurrencyOption('HKD', 'Hong Kong Dollar', 'HK\$'),
  CurrencyOption('KRW', 'South Korean Won', '₩'),
  CurrencyOption('THB', 'Thai Baht', '฿'),
  CurrencyOption('IDR', 'Indonesian Rupiah', 'Rp'),
  CurrencyOption('MYR', 'Malaysian Ringgit', 'RM'),
  CurrencyOption('PHP', 'Philippine Peso', '₱'),
  CurrencyOption('NGN', 'Nigerian Naira', '₦'),
  CurrencyOption('KES', 'Kenyan Shilling', 'KSh'),
  CurrencyOption('GHS', 'Ghanaian Cedi', '₵'),
  CurrencyOption('MAD', 'Moroccan Dirham', 'د.م.'),
  CurrencyOption('TND', 'Tunisian Dinar', 'د.ت'),
  CurrencyOption('PKR', 'Pakistani Rupee', '₨'),
  CurrencyOption('BDT', 'Bangladeshi Taka', '৳'),
];
