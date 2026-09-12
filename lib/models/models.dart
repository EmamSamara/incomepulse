class FixedExpense {
  const FixedExpense({this.id, required this.name, required this.amount, this.category = ''});
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
  Map<String, Object?> toMap() => {'id': id, 'name': name, 'amount': amount, 'category': category};
}

class IncomeEntry {
  const IncomeEntry({this.id, required this.amount, required this.category, required this.date, this.note = ''});
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
