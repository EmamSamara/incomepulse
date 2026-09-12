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
  List<FixedExpense> expensesList = [];
  List<IncomeEntry> incomeList = [];
  List<String> categories = ['Freelance', 'Delivery', 'Online sales', 'Other'];

  double get target => expensesList.fold(0, (sum, item) => sum + item.amount);
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
