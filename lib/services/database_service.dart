import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/models.dart';

class DatabaseService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    final directory = await getApplicationDocumentsDirectory();
    _database = await openDatabase(
      join(directory.path, 'irregular_income.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('CREATE TABLE transactions (id INTEGER PRIMARY KEY AUTOINCREMENT, type TEXT NOT NULL, amount REAL NOT NULL, category TEXT NOT NULL, date TEXT NOT NULL, note TEXT)');
        await db.execute('CREATE TABLE fixed_expenses (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, amount REAL NOT NULL, category TEXT)');
        await db.execute('CREATE TABLE safety_buffer (id INTEGER PRIMARY KEY, balance REAL NOT NULL)');
        await db.insert('safety_buffer', {'id': 1, 'balance': 0.0});
        await db.execute('CREATE TABLE preferences (key TEXT PRIMARY KEY, value TEXT NOT NULL)');
      },
    );
    return _database!;
  }

  Future<List<FixedExpense>> expenses() async => (await (await database).query('fixed_expenses', orderBy: 'id DESC')).map(FixedExpense.fromMap).toList();
  Future<int> addExpense(FixedExpense expense) async => (await database).insert('fixed_expenses', expense.toMap()..remove('id'));
  Future<void> updateExpense(FixedExpense expense) async => (await database).update('fixed_expenses', expense.toMap()..remove('id'), where: 'id = ?', whereArgs: [expense.id]);
  Future<void> deleteExpense(int id) async => (await database).delete('fixed_expenses', where: 'id = ?', whereArgs: [id]);

  Future<List<IncomeEntry>> incomes() async => (await (await database).query('transactions', where: 'type = ?', whereArgs: ['income'], orderBy: 'date DESC')).map(IncomeEntry.fromMap).toList();
  Future<int> addIncome(IncomeEntry income) async => (await database).insert('transactions', income.toMap()..remove('id'));
  Future<void> updateIncome(IncomeEntry income) async => (await database).update('transactions', income.toMap()..remove('id'), where: 'id = ?', whereArgs: [income.id]);
  Future<void> deleteIncome(int id) async => (await database).delete('transactions', where: 'id = ?', whereArgs: [id]);
  Future<double> buffer() async { final rows = await (await database).query('safety_buffer', where: 'id = ?', whereArgs: [1]); return (rows.first['balance'] as num).toDouble(); }
  Future<void> setBuffer(double value) async => (await database).update('safety_buffer', {'balance': value}, where: 'id = ?', whereArgs: [1]);
  Future<String?> preference(String key) async { final rows = await (await database).query('preferences', where: 'key = ?', whereArgs: [key]); return rows.isEmpty ? null : rows.first['value'] as String; }
  Future<void> setPreference(String key, String value) async => (await database).insert('preferences', {'key': key, 'value': value}, conflictAlgorithm: ConflictAlgorithm.replace);
}
