import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';
import '../services/database_service.dart';

class AppState extends ChangeNotifier {
  AppState(this._db, this._prefs);
  final DatabaseService _db;
  final SharedPreferences _prefs;
  bool loading = true;
  bool onboarded = false;
  bool darkMode = false;
  String localeCode = 'en';
  String currencyCode = 'USD';
  String currencySymbol = '\$';
  bool preferencesComplete = false;
  double buffer = 0;
  double monthlyBudget = 0;
  List<FixedExpense> expensesList = [];
  List<IncomeEntry> incomeList = [];
  List<String> categories = ['Freelance', 'Delivery', 'Online sales', 'Other'];

  double get target => expensesList.fold(0, (sum, item) => sum + item.amount);
  double get budgetRemaining =>
      (monthlyBudget - currentMonthTotal).clamp(0, double.infinity);
  double get budgetProgress =>
      monthlyBudget <= 0 ? 0 : (currentMonthTotal / monthlyBudget).clamp(0, 1);

  Future<void> setMonthlyBudget(double value) async {
    monthlyBudget = value.clamp(0, double.infinity);
    await _prefs.setDouble('monthlyBudget', monthlyBudget);
    notifyListeners();
  }

  String exportBackup() {
    return jsonEncode({
      'version': 1,
      'monthlyBudget': monthlyBudget,
      'buffer': buffer,
      'categories': categories,
      'expenses': expensesList.map((e) => e.toMap()).toList(),
      'income': incomeList.map((e) => e.toMap()).toList(),
    });
  }

  Future<bool> importBackup(String raw) async {
    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      final expenses = (data['expenses'] as List? ?? [])
          .cast<Map>()
          .map((e) => FixedExpense.fromMap(Map<String, Object?>.from(e)))
          .toList();
      final incomes = (data['income'] as List? ?? [])
          .cast<Map>()
          .map((e) => IncomeEntry.fromMap(Map<String, Object?>.from(e)))
          .toList();
      for (final e in expenses) await _db.addExpense(e);
      for (final i in incomes) await _db.addIncome(i);
      if (data['buffer'] is num)
        await _db.setBuffer((data['buffer'] as num).toDouble());
      if (data['monthlyBudget'] is num)
        await setMonthlyBudget((data['monthlyBudget'] as num).toDouble());
      if (data['categories'] is List) {
        categories = (data['categories'] as List)
            .map((e) => e.toString())
            .toSet()
            .toList();
        await _db.setPreference('categories', categories.join('|'));
      }
      await load();
      return true;
    } catch (_) {
      return false;
    }
  }

  String exportCsv() {
    final rows = <List<String>>[
      ['type', 'amount', 'category', 'date', 'note'],
      ...incomeList.map(
        (e) => [
          'income',
          e.amount.toStringAsFixed(2),
          e.category,
          e.date.toIso8601String(),
          e.note,
        ],
      ),
    ];
    String escape(String value) => '"${value.replaceAll('"', '""')}"';
    return rows.map((r) => r.map(escape).join(',')).join('\n');
  }

  Future<void> load() async {
    expensesList = await _db.expenses();
    incomeList = await _db.incomes();
    buffer = await _db.buffer();
    onboarded = _prefs.getBool('onboarded') ?? false;
    darkMode = _prefs.getBool('darkMode') ?? false;
    preferencesComplete = _prefs.getBool('preferencesComplete') ?? false;
    localeCode = _prefs.getString('localeCode') ?? 'en';
    currencyCode = _prefs.getString('currencyCode') ?? 'USD';
    currencySymbol = _prefs.getString('currencySymbol') ?? '\$';
    monthlyBudget = _prefs.getDouble('monthlyBudget') ?? 0;
    final storedCategories = await _db.preference('categories');
    if (storedCategories != null && storedCategories.isNotEmpty) {
      categories = storedCategories.split('|');
    }
    loading = false;
    notifyListeners();
  }

  List<IncomeEntry> get currentMonthIncome {
    final now = DateTime.now();
    return incomeList
        .where(
          (entry) =>
              entry.date.year == now.year && entry.date.month == now.month,
        )
        .toList();
  }

  double get currentMonthTotal =>
      currentMonthIncome.fold(0, (sum, item) => sum + item.amount);
  double totalFor(DateTime month) => incomeList
      .where((e) => e.date.year == month.year && e.date.month == month.month)
      .fold(0, (sum, item) => sum + item.amount);
  Future<void> finishOnboarding() async {
    onboarded = true;
    await _db.setPreference('onboarded', 'true');
    notifyListeners();
  }

  Future<void> finishPreferences() async {
    preferencesComplete = true;
    await _prefs.setBool('preferencesComplete', true);
    notifyListeners();
  }

  Future<void> addExpense(FixedExpense expense) async {
    await _db.addExpense(expense);
    expensesList = await _db.expenses();
    notifyListeners();
  }

  Future<void> updateExpense(FixedExpense expense) async {
    await _db.updateExpense(expense);
    expensesList = await _db.expenses();
    notifyListeners();
  }

  Future<void> deleteExpense(int id) async {
    await _db.deleteExpense(id);
    expensesList = await _db.expenses();
    notifyListeners();
  }

  Future<bool> addIncome(IncomeEntry entry) async {
    await _db.addIncome(entry);
    incomeList = await _db.incomes();
    notifyListeners();
    return currentMonthTotal > target && target > 0;
  }

  Future<bool> updateIncome(IncomeEntry entry) async {
    await _db.updateIncome(entry);
    incomeList = await _db.incomes();
    notifyListeners();
    return currentMonthTotal > target && target > 0;
  }

  Future<void> deleteIncome(int id) async {
    await _db.deleteIncome(id);
    incomeList = await _db.incomes();
    notifyListeners();
  }

  Future<void> changeBuffer(double delta) async {
    buffer = (buffer + delta).clamp(0, double.infinity);
    await _db.setBuffer(buffer);
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    darkMode = value;
    await _prefs.setBool('darkMode', value);
    notifyListeners();
  }

  Future<void> setLanguage(String value) async {
    localeCode = value;
    await _prefs.setString('localeCode', value);
    notifyListeners();
  }

  Future<void> setCurrency(String code, String symbol) async {
    currencyCode = code;
    currencySymbol = symbol;
    await _prefs.setString('currencyCode', code);
    await _prefs.setString('currencySymbol', symbol);
    notifyListeners();
  }

  Future<void> addCategory(String value) async {
    if (value.trim().isEmpty || categories.contains(value.trim())) return;
    categories = [...categories, value.trim()];
    await _db.setPreference('categories', categories.join('|'));
    notifyListeners();
  }
}
