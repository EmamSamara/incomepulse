import 'package:flutter_test/flutter_test.dart';

import 'package:incomepulse/models/models.dart';

void main() {
  test('project test harness is available', () {
    expect(true, isTrue);
  });

  test('fixed expense maps to and from database values', () {
    const expense = FixedExpense(
      id: 7,
      name: 'Rent',
      amount: 900,
      category: 'Housing',
    );

    final restored = FixedExpense.fromMap(expense.toMap());

    expect(restored.id, 7);
    expect(restored.name, 'Rent');
    expect(restored.amount, 900);
    expect(restored.category, 'Housing');
  });

  test('income entry preserves amount, category, date, and note', () {
    final date = DateTime(2026, 9, 14, 10, 30);
    final entry = IncomeEntry(
      id: 3,
      amount: 1600,
      category: 'Freelance',
      date: date,
      note: 'New design project',
    );

    final restored = IncomeEntry.fromMap(entry.toMap());

    expect(restored.id, 3);
    expect(restored.amount, 1600);
    expect(restored.category, 'Freelance');
    expect(restored.date, date);
    expect(restored.note, 'New design project');
  });

  test('currency options include common currencies', () {
    final codes = currencyOptions.map((option) => option.code).toSet();

    expect(codes, containsAll(<String>['USD', 'EUR', 'JOD', 'SAR']));
    expect(currencyOptions.first.symbol, r'$');
  });
}
