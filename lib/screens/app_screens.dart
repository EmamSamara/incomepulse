import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/models.dart';
import '../providers/app_state.dart';

AppLocalizations text(BuildContext context) => AppLocalizations.of(context)!;

String languageLabel(BuildContext context, String code) {
  switch (code) {
    case 'ar':
      return text(context).arabic;
    case 'es':
      return text(context).spanish;
    case 'fr':
      return text(context).french;
    case 'de':
      return text(context).german;
    case 'tr':
      return text(context).turkish;
    case 'he':
      return text(context).hebrew;
    default:
      return text(context).english;
  }
}

String categoryLabel(BuildContext context, String category) {
  switch (category.toLowerCase()) {
    case 'freelance':
      return text(context).categoryFreelance;
    case 'delivery':
      return text(context).categoryDelivery;
    case 'online sales':
      return text(context).categoryOnlineSales;
    case 'other':
      return text(context).categoryOther;
    default:
      return category;
  }
}

String formatMoney(BuildContext context, double value) {
  final state = context.read<AppState>();
  return NumberFormat.currency(
    locale: state.localeCode,
    name: state.currencyCode,
    symbol: state.currencySymbol,
  ).format(value);
}

class PreferencesSetupScreen extends StatefulWidget {
  const PreferencesSetupScreen({super.key});
  @override
  State<PreferencesSetupScreen> createState() => _PreferencesSetupScreenState();
}

class _PreferencesSetupScreenState extends State<PreferencesSetupScreen> {
  String language = 'en';
  CurrencyOption currency = currencyOptions.first;

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 40),
            Icon(
              Icons.auto_awesome,
              size: 58,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 20),
            Text(
              text(context).welcome,
              style: Theme.of(context).textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(text(context).chooseLanguageCurrency),
            const SizedBox(height: 28),
            Text(
              text(context).language,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: language,
              decoration: InputDecoration(labelText: text(context).language),
              items: const ['en', 'ar', 'es', 'fr', 'de', 'tr', 'he']
                  .map(
                    (code) => DropdownMenuItem(
                      value: code,
                      child: Text(languageLabel(context, code)),
                    ),
                  )
                  .toList(),
              onChanged: (value) async {
                if (value == null) return;
                setState(() => language = value);
                await state.setLanguage(language);
              },
            ),
            const SizedBox(height: 24),
            Text(
              text(context).currency,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () async {
                final result = await chooseCurrency(context, currency);
                if (result != null) setState(() => currency = result);
              },
              icon: const Icon(Icons.currency_exchange),
              label: Text(
                '${currency.name} (${currency.code}) ${currency.symbol}',
              ),
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: () async {
                await state.setCurrency(currency.code, currency.symbol);
                await state.finishPreferences();
              },
              child: Text(text(context).continueButton),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController();
  final amount = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: form,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 40),
              const Icon(
                Icons.wb_sunny_outlined,
                size: 58,
                color: Colors.orange,
              ),
              const SizedBox(height: 24),
              Text(
                text(context).onboardingTitle,
                style: Theme.of(context).textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(text(context).onboardingBody),
              const SizedBox(height: 28),
              TextFormField(
                controller: name,
                decoration: InputDecoration(
                  labelText: text(context).firstExpense,
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? text(context).requiredName
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: amount,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: text(context).monthlyAmount,
                  prefixText: '${state.currencySymbol} ',
                ),
                validator: (value) =>
                    double.tryParse(value ?? '') == null ||
                        double.parse(value!) <= 0
                    ? text(context).invalidAmount
                    : null,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () async {
                  if (!form.currentState!.validate()) return;
                  await state.addExpense(
                    FixedExpense(
                      name: name.text.trim(),
                      amount: double.parse(amount.text),
                    ),
                  );
                  await state.finishOnboarding();
                },
                child: Text(text(context).continueButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final labels = [
      text(context).home,
      text(context).history,
      text(context).buffer,
      text(context).settings,
    ];
    final pages = [
      const HomeScreen(),
      const HistoryScreen(),
      const BufferScreen(),
      const SettingsScreen(),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(labels[index])),
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: labels[0],
          ),
          NavigationDestination(
            icon: const Icon(Icons.insights_outlined),
            selectedIcon: const Icon(Icons.insights),
            label: labels[1],
          ),
          NavigationDestination(
            icon: const Icon(Icons.shield_outlined),
            selectedIcon: const Icon(Icons.shield),
            label: labels[2],
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: labels[3],
          ),
        ],
      ),
      floatingActionButton: index == 0
          ? FloatingActionButton.extended(
              onPressed: () => showIncomeDialog(context),
              icon: const Icon(Icons.add),
              label: Text(text(context).addIncome),
            )
          : null,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final now = DateTime.now();
    final target = state.target;
    final total = state.currentMonthTotal;
    final progress = target == 0 ? 0.0 : (total / target).clamp(0.0, 1.0);
    final days = DateUtils.getDaysInMonth(now.year, now.month);
    final ahead = target == 0 || total / target >= now.day / days;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      children: [
        Text(
          DateFormat.yMMMM(state.localeCode).format(now),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text(context).monthlyMinimum,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 6),
                Text(
                  formatMoney(context, target),
                  style: Theme.of(context).textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 18),
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 12,
                  borderRadius: BorderRadius.circular(8),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${formatMoney(context, total)} ${text(context).earnedThisMonth}',
                    ),
                    Text('${(progress * 100).round()}%'),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  target == 0
                      ? text(context).addExpensesTarget
                      : ahead
                      ? text(context).ahead
                      : text(context).behind,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _metric(context, text(context).daysLeft, '${days - now.day}'),
            _metric(
              context,
              text(context).stillNeeded,
              formatMoney(context, (target - total).clamp(0, double.infinity)),
            ),
            _metric(
              context,
              text(context).buffer,
              formatMoney(context, state.buffer),
            ),
          ],
        ),
        const SizedBox(height: 22),
        Text(
          text(context).recentIncome,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        if (state.incomeList.isEmpty)
          EmptyState(
            icon: Icons.receipt_long_outlined,
            text: text(context).noIncome,
          ),
        ...state.incomeList.take(8).map((entry) => incomeTile(context, entry)),
      ],
    );
  }
}

Widget _metric(BuildContext context, String label, String value) => Expanded(
  child: Card(
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: 4),
          Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  ),
);
Widget incomeTile(BuildContext context, IncomeEntry entry) => Dismissible(
  key: ValueKey(entry.id),
  direction: DismissDirection.endToStart,
  background: Container(
    color: Theme.of(context).colorScheme.errorContainer,
    alignment: AlignmentDirectional.centerEnd,
    padding: const EdgeInsetsDirectional.only(end: 20),
    child: const Icon(Icons.delete_outline),
  ),
  onDismissed: (_) => context.read<AppState>().deleteIncome(entry.id!),
  child: ListTile(
    contentPadding: EdgeInsets.zero,
    leading: const CircleAvatar(child: Icon(Icons.work_outline)),
    title: Text(categoryLabel(context, entry.category)),
    subtitle: Text(
      '${DateFormat.yMMMd(context.read<AppState>().localeCode).format(entry.date)}${entry.note.isEmpty ? '' : ' · ${entry.note}'}',
    ),
    trailing: Text('+${formatMoney(context, entry.amount)}'),
    onTap: () => showIncomeDialog(context, existing: entry),
  ),
);

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(28),
    child: Column(
      children: [
        Icon(icon, size: 46, color: Theme.of(context).colorScheme.outline),
        const SizedBox(height: 10),
        Text(text, textAlign: TextAlign.center),
      ],
    ),
  );
}

Future<void> showIncomeDialog(BuildContext context, {IncomeEntry? existing}) =>
    showDialog(
      context: context,
      builder: (_) => IncomeDialog(existing: existing),
    );

class IncomeDialog extends StatefulWidget {
  const IncomeDialog({super.key, this.existing});
  final IncomeEntry? existing;
  @override
  State<IncomeDialog> createState() => _IncomeDialogState();
}

class _IncomeDialogState extends State<IncomeDialog> {
  final form = GlobalKey<FormState>();
  late final TextEditingController amount;
  late final TextEditingController note;
  late DateTime date;
  late String category;
  @override
  void initState() {
    super.initState();
    final item = widget.existing;
    amount = TextEditingController(text: item?.amount.toString() ?? '');
    note = TextEditingController(text: item?.note ?? '');
    date = item?.date ?? DateTime.now();
    category = item?.category ?? 'Freelance';
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();
    return AlertDialog(
      title: Text(
        widget.existing == null ? text(context).addIncome : text(context).edit,
      ),
      content: Form(
        key: form,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: amount,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(labelText: text(context).amount),
                validator: (value) =>
                    double.tryParse(value ?? '') == null ||
                        double.parse(value!) <= 0
                    ? text(context).invalidAmount
                    : null,
              ),
              DropdownButtonFormField<String>(
                initialValue: state.categories.contains(category)
                    ? category
                    : state.categories.first,
                decoration: InputDecoration(labelText: text(context).source),
                items: state.categories
                    .map(
                      (value) => DropdownMenuItem(
                        value: value,
                        child: Text(categoryLabel(context, value)),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => category = value!),
              ),
              TextFormField(
                controller: note,
                decoration: InputDecoration(
                  labelText: text(context).noteOptional,
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today),
                title: Text(DateFormat.yMMMd(state.localeCode).format(date)),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                    initialDate: date,
                    locale: Locale(state.localeCode),
                  );
                  if (picked != null) setState(() => date = picked);
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(text(context).cancel),
        ),
        FilledButton(
          onPressed: () async {
            if (!form.currentState!.validate()) return;
            final item = IncomeEntry(
              id: widget.existing?.id,
              amount: double.parse(amount.text),
              category: category,
              date: date,
              note: note.text.trim(),
            );
            final surplus = widget.existing == null
                ? await state.addIncome(item)
                : await state.updateIncome(item);
            if (!context.mounted) {
              return;
            }
            Navigator.pop(context);
            if (surplus && widget.existing == null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(text(context).overTarget)));
            }
          },
          child: Text(text(context).save),
        ),
      ],
    );
  }
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String? filter;
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final now = DateTime.now();
    final months = List.generate(
      6,
      (i) => DateTime(now.year, now.month - 5 + i),
    );
    final max = months.map(state.totalFor).fold(0.0, (a, b) => a > b ? a : b);
    final entries = state.incomeList
        .where((entry) => filter == null || entry.category == filter)
        .toList();
    final content = <Widget>[
      Text(
        text(context).lastSixMonths,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      const SizedBox(height: 12),
      SizedBox(
        height: 230,
        child: BarChart(
          BarChartData(
            maxY: max == 0 ? 100 : max * 1.2,
            barGroups: months
                .asMap()
                .entries
                .map(
                  (item) => BarChartGroupData(
                    x: item.key,
                    barRods: [
                      BarChartRodData(
                        toY: state.totalFor(item.value),
                        color: Theme.of(context).colorScheme.primary,
                        width: 24,
                      ),
                    ],
                  ),
                )
                .toList(),
            barTouchData: BarTouchData(
              touchCallback: (event, response) {
                if (response?.spot != null) {
                  _showMonth(
                    context,
                    months[response!.spot!.touchedBarGroupIndex],
                  );
                }
              },
            ),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, _) => Text(
                    DateFormat.MMM(state.localeCode)
                        .format(months[value.toInt()]),
                  ),
                ),
              ),
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
          ),
        ),
      ),
      const SizedBox(height: 12),
      DropdownButtonFormField<String>(
        initialValue: filter,
        decoration: InputDecoration(labelText: text(context).allCategories),
        items: [
          DropdownMenuItem<String>(
            value: null,
            child: Text(text(context).allCategories),
          ),
          ...state.categories.map(
            (value) => DropdownMenuItem(
              value: value,
              child: Text(categoryLabel(context, value)),
            ),
          ),
        ],
        onChanged: (value) => setState(() => filter = value),
      ),
    ];
    if (entries.isEmpty) {
      content.add(
        EmptyState(icon: Icons.bar_chart, text: text(context).noHistory),
      );
    }
    content.addAll(entries.map((entry) => incomeTile(context, entry)));
    return ListView(padding: const EdgeInsets.all(20), children: content);
  }

  void _showMonth(BuildContext context, DateTime month) {
    final state = context.read<AppState>();
    final items = state.incomeList
        .where(
          (entry) =>
              entry.date.year == month.year && entry.date.month == month.month,
        )
        .toList();
    final rows = items
        .map(
          (entry) => ListTile(
            title: Text(categoryLabel(context, entry.category)),
            trailing: Text(formatMoney(context, entry.amount)),
          ),
        )
        .toList();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(DateFormat.yMMMM(state.localeCode).format(month)),
        content: SizedBox(
          width: double.maxFinite,
          child: rows.isEmpty
              ? Text(text(context).noHistory)
              : ListView(shrinkWrap: true, children: rows),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(text(context).cancel),
          ),
        ],
      ),
    );
  }
}

class BufferScreen extends StatefulWidget {
  const BufferScreen({super.key});
  @override
  State<BufferScreen> createState() => _BufferScreenState();
}

class _BufferScreenState extends State<BufferScreen> {
  final amount = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Icon(Icons.shield_outlined, size: 56),
                const SizedBox(height: 10),
                Text(
                  text(context).buffer,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  formatMoney(context, state.buffer),
                  style: Theme.of(context).textTheme.displaySmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(text(context).bufferMessage, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        TextField(
          controller: amount,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: text(context).bufferAmount),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: () => change(true),
                icon: const Icon(Icons.add),
                label: Text(text(context).addToBuffer),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => change(false),
                icon: const Icon(Icons.remove),
                label: Text(text(context).withdrawFromBuffer),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void change(bool add) {
    final value = double.tryParse(amount.text);
    if (value == null || value <= 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(text(context).invalidBuffer)));
      return;
    }
    context.read<AppState>().changeBuffer(add ? value : -value);
    amount.clear();
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          text(context).preferences,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(text(context).darkMode),
          value: state.darkMode,
          onChanged: state.setDarkMode,
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(text(context).language),
          trailing: DropdownButton<String>(
            value: state.localeCode,
            items: const ['en', 'ar', 'es', 'fr', 'de', 'tr', 'he']
                .map(
                  (code) => DropdownMenuItem(
                    value: code,
                    child: Text(languageLabel(context, code)),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) state.setLanguage(value);
            },
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(text(context).currency),
          trailing: OutlinedButton(
            onPressed: () async {
              final selected = await chooseCurrency(
                context,
                currencyOptions.firstWhere(
                  (item) => item.code == state.currencyCode,
                ),
              );
              if (selected != null) {
                state.setCurrency(selected.code, selected.symbol);
              }
            },
            child: Text('${state.currencyCode} ${state.currencySymbol}'),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text(context).fixedExpenses,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            IconButton(
              onPressed: () => showExpenseDialog(context),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        if (state.expensesList.isEmpty) Text(text(context).noExpenses),
        ...state.expensesList.map(
          (expense) => ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(expense.name),
            subtitle: Text(expense.category),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(formatMoney(context, expense.amount)),
                IconButton(
                  onPressed: () =>
                      showExpenseDialog(context, existing: expense),
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  onPressed: () => state.deleteExpense(expense.id!),
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          text(context).categories,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        ...state.categories.map(
          (category) => ListTile(title: Text(categoryLabel(context, category))),
        ),
        TextButton.icon(
          onPressed: () => showCategoryDialog(context),
          icon: const Icon(Icons.add),
          label: Text(text(context).addCategory),
        ),
      ],
    );
  }
}

Future<CurrencyOption?> chooseCurrency(
  BuildContext context,
  CurrencyOption selected,
) => showModalBottomSheet<CurrencyOption>(
  context: context,
  isScrollControlled: true,
  builder: (_) => CurrencyPicker(selected: selected),
);

class CurrencyPicker extends StatefulWidget {
  const CurrencyPicker({super.key, required this.selected});
  final CurrencyOption selected;
  @override
  State<CurrencyPicker> createState() => _CurrencyPickerState();
}

class _CurrencyPickerState extends State<CurrencyPicker> {
  String query = '';
  @override
  Widget build(BuildContext context) {
    final list = currencyOptions
        .where(
          (item) => '${item.code} ${item.name} ${item.symbol}'
              .toLowerCase()
              .contains(query.toLowerCase()),
        )
        .toList();
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * .8,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  labelText: text(context).searchCurrencies,
                ),
                onChanged: (value) => setState(() => query = value),
              ),
            ),
            Expanded(
              child: list.isEmpty
                  ? Center(child: Text(text(context).noCurrencies))
                  : ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (_, index) {
                        final item = list[index];
                        return ListTile(
                          title: Text(item.name),
                          subtitle: Text(item.code),
                          trailing: Text(item.symbol),
                          selected: item.code == widget.selected.code,
                          onTap: () => Navigator.pop(context, item),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showExpenseDialog(
  BuildContext context, {
  FixedExpense? existing,
}) => showDialog(
  context: context,
  builder: (_) => ExpenseDialog(existing: existing),
);

class ExpenseDialog extends StatefulWidget {
  const ExpenseDialog({super.key, this.existing});
  final FixedExpense? existing;
  @override
  State<ExpenseDialog> createState() => _ExpenseDialogState();
}

class _ExpenseDialogState extends State<ExpenseDialog> {
  final form = GlobalKey<FormState>();
  late final TextEditingController name;
  late final TextEditingController amount;
  late final TextEditingController category;
  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.existing?.name);
    amount = TextEditingController(text: widget.existing?.amount.toString());
    category = TextEditingController(text: widget.existing?.category);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();
    return AlertDialog(
      title: Text(
        widget.existing == null ? text(context).addExpense : text(context).edit,
      ),
      content: Form(
        key: form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: name,
              decoration: InputDecoration(labelText: text(context).expenseName),
              validator: (value) => value == null || value.trim().isEmpty
                  ? text(context).requiredName
                  : null,
            ),
            TextFormField(
              controller: amount,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: text(context).monthlyAmount,
              ),
              validator: (value) =>
                  double.tryParse(value ?? '') == null ||
                      double.parse(value!) <= 0
                  ? text(context).invalidAmount
                  : null,
            ),
            TextField(
              controller: category,
              decoration: InputDecoration(labelText: text(context).categories),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(text(context).cancel),
        ),
        FilledButton(
          onPressed: () async {
            if (!form.currentState!.validate()) return;
            final item = FixedExpense(
              id: widget.existing?.id,
              name: name.text.trim(),
              amount: double.parse(amount.text),
              category: category.text.trim(),
            );
            if (widget.existing == null) {
              await state.addExpense(item);
            } else {
              await state.updateExpense(item);
            }
            if (context.mounted) Navigator.pop(context);
          },
          child: Text(text(context).save),
        ),
      ],
    );
  }
}

Future<void> showCategoryDialog(BuildContext context) async {
  final controller = TextEditingController();
  final form = GlobalKey<FormState>();
  final state = context.read<AppState>();
  await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(text(context).addCategory),
      content: Form(
        key: form,
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(labelText: text(context).categoryName),
          validator: (value) => value == null || value.trim().isEmpty
              ? text(context).requiredName
              : null,
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () async {
            if (!form.currentState!.validate()) return;
            await state.addCategory(controller.text);
            if (context.mounted) Navigator.pop(context);
          },
          child: Text(text(context).save),
        ),
      ],
    ),
  );
}
