import 'dart:convert';
import 'dart:developer';
import 'package:fl_carmax/bottom_nav_provider.dart';
import 'package:fl_carmax/pages/buy_car/car_detail/car_detail_provider.dart';
import 'package:fl_carmax/pages/buy_car/compare_page/compare_controller.dart';
import 'package:fl_carmax/pages/buy_car/provider/home_provider.dart';
import 'package:fl_carmax/pages/buy_car/search/search_provider.dart';
import 'package:http/http.dart' as http;

import 'package:fl_carmax/pages/buy_car/brand_related_cars/brand_related_cars_page.dart';
import 'package:fl_carmax/pages/sell_car/test_drive_or_inspection/test_drive_or_inspection_page.dart';
import 'package:fl_carmax/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'helper/language_constant.dart';
import 'models/car_listing_model.dart';
import 'pages/account/edit_profile/edit_profile.dart';
import 'pages/account/favourite/favourite_page.dart';
import 'pages/account/help/help_page.dart';
import 'pages/account/language/language_page.dart';
import 'pages/account/my_booking/my_booking_page.dart';
import 'pages/account/terms_and_condition/terms_and_condition_page.dart';
import 'pages/auth/login_page.dart';
import 'pages/auth/register_page.dart';
import 'pages/auth/verification_page.dart';
import 'bottom_navigation.dart';
import 'pages/buy_car/book_test_drive/book_test_drive_page.dart';
import 'pages/buy_car/brand/brand_page.dart';
import 'pages/buy_car/buy_car.dart';
import 'pages/buy_car/car_detail/car_detail_page.dart';
import 'pages/buy_car/check_out/check_out_page.dart';
import 'pages/buy_car/owner_details/owner_details_page.dart';
import 'pages/buy_car/payment/payment_page.dart';
import 'pages/buy_car/payment/payment_sucess_page.dart';
import 'pages/buy_car/recommend_recently_added/recommend_recently_added_page.dart';
import 'pages/buy_car/search/search_page.dart';
import 'pages/buy_car/location/confirm_location_page.dart';
import 'pages/buy_car/notification/notification_page.dart';
import 'pages/on_boarding/on_boarding_page.dart';
import 'pages/buy_car/reviews/reviews_page.dart';
import 'pages/sell_car/add_address/add_address_page.dart';
import 'pages/sell_car/basic_detail/basic_detail_page.dart';
import 'pages/sell_car/basic_detail/basic_detail_page2.dart';
import 'pages/sell_car/book_inspection/book_inspection_page.dart';
import 'pages/sell_car/book_inspection/book_inspection_with_location_page.dart';
import 'pages/sell_car/contact_detail/contact_detail_page.dart';
import 'pages/sell_car/model_select/model_select_page.dart';
import 'pages/sell_car/sell_car.dart';
import 'splash_page.dart';
import 'utils/constant.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// @pragma('vm:entry-point')
// Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await LocalNotificationService().requestPermissions();
  // await NotificationService().requestNotificationPermission();
  // await CarCacheService.getCachedCarList();

  // FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
 // SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

@override
void initState() {
  super.initState();

 // NotificationService().requestNotificationPermission();

  // Delay to ensure context is available
  // Future.delayed(Duration.zero, () {
  //   NotificationService().firebaseInit(context);
  //   NotificationService().setupInteractMessage(context);
  // });
}

  @override
  void didChangeDependencies() {
    getLocale().then((locale) => setLocale(locale));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, Orientation orientation,
              DeviceType deviceType) =>
          AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
          statusBarColor: primaryColor,
        ),
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => SearchProvider()),
            ChangeNotifierProvider(create: (_) => HomeProvider()),
            ChangeNotifierProvider(create: (_) => CompareProvider()),
            ChangeNotifierProvider(create: (_) => CarDetailProvider()),
            ChangeNotifierProvider(create: (_) => BottomNavProvider()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'WowCar',
            initialRoute: '/SplashPage',
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: _locale,
            theme: ThemeData(
              scaffoldBackgroundColor: scaffoldColor,
              primarySwatch: Colors.blue,
            ),
            onGenerateRoute: (settings) {
              final arguments = settings.arguments;
              switch (settings.name) {
                case '/SplashPage':
                  return PageTransition(
                      isIos: true,
                      child: const SplashPage(),
                      type: PageTransitionType.rightToLeft);
                case '/OnBoardingPage':
                  return PageTransition(
                      isIos: true,
                      child: const OnBoardingPage(),
                      type: PageTransitionType.rightToLeft);
                case '/LoginPage':
                  return PageTransition(
                      isIos: true,
                      child: const LoginPage(),
                      type: PageTransitionType.rightToLeft);
                case '/RegisterPage':
                  return PageTransition(
                      isIos: true,
                      child: const RegisterPage(),
                      type: PageTransitionType.rightToLeft);
                case '/VerificationPage':
                  return PageTransition(
                      isIos: true,
                      child: const VerificationPage(),
                      type: PageTransitionType.rightToLeft);
                case '/BottomNavigation':
                  return PageTransition(
                      isIos: true,
                      child: const BottomNavigation(),
                      type: PageTransitionType.rightToLeft);
                case '/BuyCarPage':
                  return PageTransition(
                      isIos: true,
                      child: const BuyCar(),
                      type: PageTransitionType.rightToLeft);
                case '/RecommendRecentlyAddedPage':
                  return PageTransition(
                      isIos: true,
                      child: arguments == 0
                          ? const RecommendRecentlyAddedPage(pageWithLogic: 0)
                          : const RecommendRecentlyAddedPage(pageWithLogic: 1),
                      type: PageTransitionType.rightToLeft);
                case '/BrandPage':
                  return PageTransition(
                      isIos: true,
                      child: const BrandPage(),
                      type: PageTransitionType.rightToLeft);
                case '/BrandRelatedCarsPage':
                  return PageTransition(
                      isIos: true,
                      child: const BrandRelatedCarsPage(),
                      type: PageTransitionType.rightToLeft);
                // case '/CarDetailPage':
                //   return PageTransition(
                //       isIos: true,
                //       child: CarDetailPage(carId: arguments as String),
                //       type: PageTransitionType.rightToLeft);
                case '/OwnerDetailsPage':
                  return PageTransition(
                      isIos: true,
                      child: const OwnerDetailsPage(),
                      type: PageTransitionType.rightToLeft);
                case '/BookTestDrivePage':
                  return PageTransition(
                      isIos: true,
                      child: const BookTestDrivePage(),
                      type: PageTransitionType.rightToLeft);
                case '/CheckOutPage':
                  return PageTransition(
                      isIos: true,
                      child: const CheckOutPage(),
                      type: PageTransitionType.rightToLeft);
                case '/PaymentPage':
                  return PageTransition(
                      isIos: true,
                      child: const PaymentPage(),
                      type: PageTransitionType.rightToLeft);
                case '/PaymentSucessPage':
                  return PageTransition(
                      isIos: true,
                      child: arguments == 0
                          ? const PaymentSucessPage(pageFor: 0)
                          : arguments == 1
                              ? const PaymentSucessPage(pageFor: 1)
                              : const PaymentSucessPage(pageFor: 2),
                      type: PageTransitionType.rightToLeft);
                case '/ConfirmLocationPage':
                  return PageTransition(
                      isIos: true,
                      child: const ConfirmLocationPage(),
                      type: PageTransitionType.rightToLeft);
                case '/SearchPage':
                  return PageTransition(
                      isIos: true,
                      child: const SearchPage(),
                      type: PageTransitionType.rightToLeft);
                case '/NotificationPage':
                  return PageTransition(
                      isIos: true,
                      child: const NotificationPage(),
                      type: PageTransitionType.rightToLeft);
                case '/ReviewsPage':
                  return PageTransition(
                      isIos: true,
                      child: const ReviewsPage(),
                      type: PageTransitionType.rightToLeft);
                case '/SellCarPage':
                  return PageTransition(
                      isIos: true,
                      child: const SellCar(),
                      type: PageTransitionType.rightToLeft);
                case '/TestDriveOrInspectionPage':
                  return PageTransition(
                      isIos: true,
                      child: arguments == 'testDrive'
                          ? const TestDriveOrInspectionPage(pageFor: 'Testdrive')
                          : const TestDriveOrInspectionPage(
                              pageFor: 'Book inspection'),
                      type: PageTransitionType.rightToLeft);
                case '/AddAddressPage':
                  return PageTransition(
                      isIos: true,
                      child: arguments == false
                          ? const AddAddressPage(navigateBack: false)
                          : const AddAddressPage(navigateBack: true),
                      type: PageTransitionType.rightToLeft);
                case '/ModelSelectPage':
                  return PageTransition(
                      isIos: true,
                      child: const ModelSelectPage(),
                      type: PageTransitionType.rightToLeft);
                case '/BasicDetailPage':
                  return PageTransition(
                      isIos: true,
                      child: const BasicDetailPage(),
                      type: PageTransitionType.rightToLeft);
                case '/BasicDetailPage2':
                  return PageTransition(
                      isIos: true,
                      child: const BasicDetailPage2(),
                      type: PageTransitionType.rightToLeft);
                case '/ContactDetailPage':
                  return PageTransition(
                      isIos: true,
                      child: const ContactDetailPage(),
                      type: PageTransitionType.rightToLeft);
                case '/BookInspectionPage':
                  return PageTransition(
                      isIos: true,
                      child: const BookInspectionPage(),
                      type: PageTransitionType.rightToLeft);
                case '/BookInspectionWithLocationPage':
                  return PageTransition(
                      isIos: true,
                      child: const BookInspectionWithLocationPage(),
                      type: PageTransitionType.rightToLeft);
                case '/EditProfile':
                  return PageTransition(
                      isIos: true,
                      child: const EditProfile(),
                      type: PageTransitionType.rightToLeft);
                case '/MyBookingPage':
                  return PageTransition(
                      isIos: true,
                      child: const MyBookingPage(),
                      type: PageTransitionType.rightToLeft);
                case '/FavouritePage':
                  return PageTransition(
                      isIos: true,
                      child: const FavouritePage(showAppBar: true,),
                      type: PageTransitionType.rightToLeft);
                case '/HelpPage':
                  return PageTransition(
                      isIos: true,
                      child: const HelpPage(),
                      type: PageTransitionType.rightToLeft);
                case '/TermsAndConditionPage':
                  return PageTransition(
                      isIos: true,
                      child: const TermsAndConditionPage(),
                      type: PageTransitionType.rightToLeft);
                case '/LanguagePage':
                  return PageTransition(
                      isIos: true,
                      child: const LanguagePage(),
                      type: PageTransitionType.rightToLeft);
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}

class CarCacheService {
  static Future<List<CarListing>>? _cachedCarList;

  /// Get cached or fresh car list
  static Future<List<CarListing>> getCachedCarList({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedCarList != null) return _cachedCarList!;
    _cachedCarList = _fetchFromAPI();
    return await _cachedCarList!;
  }

  /// Fetch data from API
  static Future<List<CarListing>> _fetchFromAPI() async {
    final url = Uri.parse('https://www.wowcar.app/wp-json/listivo/v1/all-listings-with-guids');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final jsonData = data["results"];

      if (jsonData is List) {
        final cars = jsonData
            .map((e) => CarListing.fromJson(e))
            .whereType<CarListing>()
            .toList();

        // Sort by post date DESC
        cars.sort((a, b) {
          final aDate = DateTime.tryParse(a.postDate ?? '') ?? DateTime(2000);
          final bDate = DateTime.tryParse(b.postDate ?? '') ?? DateTime(2000);
          return bDate.compareTo(aDate);
        });

        return cars;
      } else {
        throw Exception("Unexpected data format: 'results' is not a list");
      }
    } else {
      throw Exception("Failed to fetch cars: ${response.statusCode}");
    }
  }
}
