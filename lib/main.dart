import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n/app_localizations.dart';
import 'providers/app_state.dart';
import 'screens/app_screens.dart';
import 'screens/splash_screen.dart';
import 'services/database_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  final state = AppState(DatabaseService(), preferences);
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
      onGenerateTitle: (_) => 'IncomePulse',
      debugShowCheckedModeBanner: false,
      locale: Locale(appState.localeCode),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      themeMode: appState.darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seed),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(filled: true),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(filled: true),
      ),
      home: SplashScreen(
        child: !appState.preferencesComplete
            ? const PreferencesSetupScreen()
            : appState.onboarded
            ? const AppShell()
            : const OnboardingScreen(),
      ),
    );
  }
}
