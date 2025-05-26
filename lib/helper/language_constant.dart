import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const String laguageCode = 'languageCode';

//languages code
const String english = 'en';
const String hindi = 'hi';
const String indonesian = 'id';
const String chinese = 'zh';
const String arabic = 'ar';

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(laguageCode, languageCode);
  return locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String languageCode = prefs.getString(laguageCode) ?? english;
  return locale(languageCode);
}

Locale locale(String languageCode) {
  switch (languageCode) {
    case english:
      return const Locale(english, "");
    case hindi:
      return const Locale(hindi, "");
    case indonesian:
      return const Locale(indonesian, "");
    case chinese:
      return const Locale(chinese, "");
    case arabic:
      return const Locale(arabic, "");
    default:
      return const Locale(english, "");
  }
}

AppLocalizations translation(BuildContext context) =>
    AppLocalizations.of(context)!;
