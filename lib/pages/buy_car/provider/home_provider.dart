import 'dart:convert';
import 'dart:developer';
import '../../../common_libs.dart';
import '../../../helper/cities_alert_dialog.dart';
import '../../../helper/language_constant.dart';
import '../../../main.dart';
import '../../../models/car_listing_model.dart';
import '../../../utils/constant.dart';
import '../../../utils/widgets.dart';
import 'package:http/http.dart' as http;

import '../compare_page/compare_controller.dart';

class HomeProvider extends ChangeNotifier {
  final Set recentlyAddedFav = {};
  final Set<int> recommendedFav = {};
  Set<int> recommendedFav1 = {};
  List<CarListing> cars = [];
  String currentCity = 'Surat';
  String selectedLanguage = 'English'; // Default to English
  final Map<String, String> languages = {
    // 'English': 'en',
    // 'Thai': 'hi',
    // 'Bahasa': 'id',
    // 'Chinese': 'zh',
    // 'Arabic': 'ar',
    'English': 'en',
    'Arabic': 'ar',
    //  'Bahasa': 'id',
    'Chinese': 'zh',
    'Thai': 'hi',
    //  'Turkish': 'tr'
  };

  Future<void> loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLangCode = prefs.getString(laguageCode) ?? 'en';

    // Reverse lookup: get the key (visible name) by value (lang code)
    final matchingEntry = languages.entries.firstWhere(
          (entry) => entry.value == savedLangCode,
      orElse: () => const MapEntry('English', 'en'),
    );

    selectedLanguage = matchingEntry.key;
    notifyListeners();
  }

  bool isLoading = true;
  void showLanguagesDialog(BuildContext context) async {
    String? newLanguage = await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: languages.keys.map((lang) {
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context, lang);
                },
                child: PrimaryContainer(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding:
                      const EdgeInsets.symmetric(vertical: 13, horizontal: 19),
                  child: Row(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 2.4.h,
                            width: 2.4.h,
                            decoration: BoxDecoration(
                              color: selectedLanguage == lang
                                  ? primaryColor
                                  : white,
                              shape: BoxShape.circle,
                              boxShadow: selectedLanguage == lang
                                  ? [myPrimaryShadow]
                                  : [myBoxShadow],
                            ),
                          ),
                          const CircleAvatar(
                            backgroundColor: white,
                            radius: 3,
                          )
                        ],
                      ),
                      widthSpace15,
                      Text(lang, style: blackMedium16),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );

    if (newLanguage != null) {
      selectedLanguage = newLanguage;
      // Update the app's locale
      Locale newLocale = Locale(languages[newLanguage]!);
      if(context.mounted){
        MyApp.setLocale(context, newLocale);
      }
      notifyListeners();
    }
  }
Future<List<CarListing>>? get recentlyAddedCars => _recentlyAddedCars;

  Future<List<CarListing>>? _cachedRecentlyAddedCars;
  Future<List<CarListing>>? _recentlyAddedCars;
Future<List<CarListing>> getRecentlyAddedCarsOnce() {
  _recentlyAddedCars ??= fetchRecentlyAddedCars(); 
  return _recentlyAddedCars!;
}

Future<List<CarListing>> refreshRecentlyAddedCars() async {
  _recentlyAddedCars = fetchRecentlyAddedCars(); // this already returns Future<List<CarListing>>
  final data = await _recentlyAddedCars!;
  notifyListeners();
  return data; // ✅ return list of cars so UI can use it
}



  // Future<List<CarListing>> getRecentlyAddedCarsOnce() {
  //   if (_cachedRecentlyAddedCars != null) {
  //     return _cachedRecentlyAddedCars!;
  //   }

  //   _cachedRecentlyAddedCars = fetchRecentlyAddedCars();
  //   return _cachedRecentlyAddedCars!;
  // }

  Future<List<CarListing>> fetchRecentlyAddedCars() async {
    log("WOTKIGN HERE");
    final url = Uri.parse(
        'https://www.wowcar.app/wp-json/listivo/v1/all-listings-with-guids');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final data = jsonData["results"];
        if (data is! List) {
          log("❌ Expected 'results' to be a List but got: ${data.runtimeType}");
          return [];
        }
        cars = data
            .map((e) {
              try {
                return CarListing.fromJson(e);
              } catch (e) {
                log("❌ Error parsing car: $e");
                return null;
              }
            })
            .whereType<CarListing>()
            .toList();
        // Sort by postDate DESC
        cars.sort((a, b) {
          final dateA = DateTime.tryParse(a.postDate ?? '') ?? DateTime(2000);
          final dateB = DateTime.tryParse(b.postDate ?? '') ?? DateTime(2000);
          return dateB.compareTo(dateA); // Newest first
        });
        log("Manan ${cars.first.modelsListD![0]}");
        return cars.toList(); // Return top 10 recent cars
      } else {
        log("❌ Failed with status code: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      log("❌ Exception during fetch: $e");
      return [];
    } finally {
      notifyListeners();
    }
  }

  void toggleRecommendedFavorite(
      int index, CarListing car, BuildContext context) {
    if (recommendedFav.contains(index)) {
      recommendedFav.remove(index);
      _showSnackBar(context, '${car.title} ${translation(context).removedFav}');
    } else {
      recommendedFav.add(index);
      _showSnackBar(context, '${car.title} ${translation(context).addedFav}');
    }
    notifyListeners();
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: primaryColor,
        duration: const Duration(seconds: 2),
        content: Text(message, style: whiteMedium14),
      ),
    );
  }

  void showCitiesDialog(context) async {
    currentCity = await showDialog(
            context: context,
            builder: (context) =>
                CitiesAlertDialog(initialCity: currentCity)) ??
        currentCity;
    notifyListeners();
  }

  void toggleCompare(context, CarListing car) {
    final provider = Provider.of<CompareProvider>(context, listen: false);
    provider.toggleCar(car);
  }
}
