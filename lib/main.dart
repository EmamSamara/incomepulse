import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/app_state.dart';
import 'screens/app_screens.dart';
import 'services/database_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state = AppState(DatabaseService());
  await state.load();
  runApp(ChangeNotifierProvider.value(value: state, child: const BudgetApp()));
}

class BudgetApp extends StatelessWidget {
  const BudgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    const seed = Color(0xFF176B5B);
    return MaterialApp(
      title: 'Steady',
      debugShowCheckedModeBanner: false,
      themeMode: appState.darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seed),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(filled: true),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(filled: true),
      ),
      home: appState.onboarded ? const AppShell() : const OnboardingScreen(),
    );
  }
}
