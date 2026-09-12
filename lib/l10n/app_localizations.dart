import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_he.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('he'),
    Locale('tr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Steady'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @buffer.
  ///
  /// In en, this message translates to:
  /// **'Safety Buffer'**
  String get buffer;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @monthlyMinimum.
  ///
  /// In en, this message translates to:
  /// **'Monthly minimum'**
  String get monthlyMinimum;

  /// No description provided for @earnedThisMonth.
  ///
  /// In en, this message translates to:
  /// **'earned this month'**
  String get earnedThisMonth;

  /// No description provided for @recentIncome.
  ///
  /// In en, this message translates to:
  /// **'Recent income'**
  String get recentIncome;

  /// No description provided for @noIncome.
  ///
  /// In en, this message translates to:
  /// **'No income logged yet'**
  String get noIncome;

  /// No description provided for @daysLeft.
  ///
  /// In en, this message translates to:
  /// **'Days left'**
  String get daysLeft;

  /// No description provided for @stillNeeded.
  ///
  /// In en, this message translates to:
  /// **'Still needed'**
  String get stillNeeded;

  /// No description provided for @ahead.
  ///
  /// In en, this message translates to:
  /// **'You are ahead of your expected pace.'**
  String get ahead;

  /// No description provided for @behind.
  ///
  /// In en, this message translates to:
  /// **'You are a little behind pace. There is still time this month.'**
  String get behind;

  /// No description provided for @addExpensesTarget.
  ///
  /// In en, this message translates to:
  /// **'Add fixed expenses to set your monthly target.'**
  String get addExpensesTarget;

  /// No description provided for @addIncome.
  ///
  /// In en, this message translates to:
  /// **'Add income'**
  String get addIncome;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get source;

  /// No description provided for @noteOptional.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get noteOptional;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @invalidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount greater than zero'**
  String get invalidAmount;

  /// No description provided for @requiredName.
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get requiredName;

  /// No description provided for @incomeSaved.
  ///
  /// In en, this message translates to:
  /// **'Income saved'**
  String get incomeSaved;

  /// No description provided for @overTarget.
  ///
  /// In en, this message translates to:
  /// **'You are over target. Consider setting aside 20% of this surplus into your Safety Buffer.'**
  String get overTarget;

  /// No description provided for @lastSixMonths.
  ///
  /// In en, this message translates to:
  /// **'Last six months'**
  String get lastSixMonths;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'Log income to see your patterns.'**
  String get noHistory;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All categories'**
  String get allCategories;

  /// No description provided for @fixedExpenses.
  ///
  /// In en, this message translates to:
  /// **'Fixed expenses'**
  String get fixedExpenses;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add fixed expense'**
  String get addExpense;

  /// No description provided for @expenseName.
  ///
  /// In en, this message translates to:
  /// **'Expense name'**
  String get expenseName;

  /// No description provided for @monthlyAmount.
  ///
  /// In en, this message translates to:
  /// **'Monthly amount'**
  String get monthlyAmount;

  /// No description provided for @noExpenses.
  ///
  /// In en, this message translates to:
  /// **'Add rent, bills, subscriptions, and other monthly essentials.'**
  String get noExpenses;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Income categories'**
  String get categories;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add category'**
  String get addCategory;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get categoryName;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Make variable income feel more predictable.'**
  String get onboardingTitle;

  /// No description provided for @onboardingBody.
  ///
  /// In en, this message translates to:
  /// **'Start with your monthly essentials. You can add or change them anytime.'**
  String get onboardingBody;

  /// No description provided for @firstExpense.
  ///
  /// In en, this message translates to:
  /// **'First fixed expense'**
  String get firstExpense;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Steady'**
  String get welcome;

  /// No description provided for @chooseLanguageCurrency.
  ///
  /// In en, this message translates to:
  /// **'Choose your language and currency.'**
  String get chooseLanguageCurrency;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get spanish;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get french;

  /// No description provided for @german.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get german;

  /// No description provided for @turkish.
  ///
  /// In en, this message translates to:
  /// **'Türkçe'**
  String get turkish;

  /// No description provided for @hebrew.
  ///
  /// In en, this message translates to:
  /// **'עברית'**
  String get hebrew;

  /// No description provided for @selectCurrency.
  ///
  /// In en, this message translates to:
  /// **'Select currency'**
  String get selectCurrency;

  /// No description provided for @searchCurrencies.
  ///
  /// In en, this message translates to:
  /// **'Search currencies'**
  String get searchCurrencies;

  /// No description provided for @noCurrencies.
  ///
  /// In en, this message translates to:
  /// **'No currencies found'**
  String get noCurrencies;

  /// No description provided for @bufferMessage.
  ///
  /// In en, this message translates to:
  /// **'A little extra set aside can make slower months feel more manageable.'**
  String get bufferMessage;

  /// No description provided for @addToBuffer.
  ///
  /// In en, this message translates to:
  /// **'Add to buffer'**
  String get addToBuffer;

  /// No description provided for @withdrawFromBuffer.
  ///
  /// In en, this message translates to:
  /// **'Withdraw from buffer'**
  String get withdrawFromBuffer;

  /// No description provided for @bufferAmount.
  ///
  /// In en, this message translates to:
  /// **'Buffer amount'**
  String get bufferAmount;

  /// No description provided for @invalidBuffer.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get invalidBuffer;

  /// No description provided for @monthTransactions.
  ///
  /// In en, this message translates to:
  /// **'transactions'**
  String get monthTransactions;

  /// No description provided for @categoryFreelance.
  ///
  /// In en, this message translates to:
  /// **'Freelance'**
  String get categoryFreelance;

  /// No description provided for @categoryDelivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get categoryDelivery;

  /// No description provided for @categoryOnlineSales.
  ///
  /// In en, this message translates to:
  /// **'Online sales'**
  String get categoryOnlineSales;

  /// No description provided for @categoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOther;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'he',
    'tr',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'he':
      return AppLocalizationsHe();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
