import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_state.dart';

String money(AppState state, double value) => '${state.currency}${value.toStringAsFixed(2)}';

class AppShell extends StatefulWidget { const AppShell({super.key}); @override State<AppShell> createState() => _AppShellState(); }
class _AppShellState extends State<AppShell> {
  int index = 0;
  @override Widget build(BuildContext context) {
    final screens = [const HomeScreen(), const HistoryScreen(), const BufferScreen(), const SettingsScreen()];
    return Scaffold(appBar: AppBar(title: Text(['Home', 'History', 'Safety Buffer', 'Settings'][index])), body: screens[index], bottomNavigationBar: NavigationBar(selectedIndex: index, onDestinationSelected: (value) => setState(() => index = value), destinations: const [NavigationDestination(icon: Icon(Icons.home), label: 'Home'), NavigationDestination(icon: Icon(Icons.history), label: 'History'), NavigationDestination(icon: Icon(Icons.shield), label: 'Buffer'), NavigationDestination(icon: Icon(Icons.settings), label: 'Settings')]), floatingActionButton: index == 0 ? FloatingActionButton(onPressed: () => showDialog(context: context, builder: (_) => const AddIncomeDialog()), child: const Icon(Icons.add)) : null);
  }
}

class HomeScreen extends StatelessWidget { const HomeScreen({super.key}); @override Widget build(BuildContext context) { final state = context.watch<AppState>(); final progress = state.target == 0 ? 0.0 : (state.currentMonthTotal / state.target).clamp(0.0, 1.0); return ListView(padding: const EdgeInsets.all(20), children: [Text('Monthly minimum', style: Theme.of(context).textTheme.titleLarge), Text(money(state, state.target), style: Theme.of(context).textTheme.displaySmall), const SizedBox(height: 16), LinearProgressIndicator(value: progress, minHeight: 12), const SizedBox(height: 8), Text('${money(state, state.currentMonthTotal)} earned this month'), const SizedBox(height: 24), Text('Recent income', style: Theme.of(context).textTheme.titleLarge), ...state.incomeList.take(8).map((entry) => ListTile(title: Text(entry.category), subtitle: Text(entry.note), trailing: Text(money(state, entry.amount))))]); } }

class AddIncomeDialog extends StatelessWidget {
  const AddIncomeDialog({super.key});
  @override Widget build(BuildContext context) => AlertDialog(title: const Text('Add income'), content: const Text('Use Settings to configure expenses and categories.'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))]);
}

class HistoryScreen extends StatelessWidget { const HistoryScreen({super.key}); @override Widget build(BuildContext context) { final state = context.watch<AppState>(); return ListView(padding: const EdgeInsets.all(20), children: [Text('Income history', style: Theme.of(context).textTheme.headlineSmall), ...state.incomeList.map((entry) => ListTile(title: Text(entry.category), trailing: Text(money(state, entry.amount))) ]); } }
class BufferScreen extends StatelessWidget { const BufferScreen({super.key}); @override Widget build(BuildContext context) { final state = context.watch<AppState>(); return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.shield, size: 64), Text(money(state, state.buffer), style: Theme.of(context).textTheme.displayMedium), FilledButton(onPressed: () => state.changeBuffer(20), child: const Text('Add 20'))])); } }
class SettingsScreen extends StatelessWidget { const SettingsScreen({super.key}); @override Widget build(BuildContext context) { final state = context.watch<AppState>(); return ListView(padding: const EdgeInsets.all(20), children: [SwitchListTile(title: const Text('Dark mode'), value: state.darkMode, onChanged: state.setDarkMode), Text('Fixed expenses', style: Theme.of(context).textTheme.titleLarge), ...state.expensesList.map((expense) => ListTile(title: Text(expense.name), trailing: Text(money(state, expense.amount))))]); } }
class OnboardingScreen extends StatelessWidget { const OnboardingScreen({super.key}); @override Widget build(BuildContext context) { final state = context.read<AppState>(); return Scaffold(body: Center(child: FilledButton(onPressed: state.finishOnboarding, child: const Text('Set up my tracker')))); } }
