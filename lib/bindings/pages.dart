
import '../common_libs.dart';

import '../pages/buy_car/car_detail/car_detail_page.dart';

class Pages {
  static Route<dynamic> onGeneratingRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    switch (settings.name) {
      case Routes.splashPage:
        return PageTransition(
            isIos: true,
            child: const SplashPage(),
            type: PageTransitionType.rightToLeft);
      case Routes.onBoardingPage:
        return PageTransition(
            isIos: true,
            child: const OnBoardingPage(),
            type: PageTransitionType.rightToLeft);
      case Routes.loginPage:
        return PageTransition(
            isIos: true,
            child: const LoginPage(),
            type: PageTransitionType.rightToLeft);
      case Routes.registerPage:
        return PageTransition(
            isIos: true,
            child: const RegisterPage(),
            type: PageTransitionType.rightToLeft);
      case Routes.verificationPage:
        return PageTransition(
            isIos: true,
            child: const VerificationPage(),
            type: PageTransitionType.rightToLeft);
      case Routes.bottomNavigation:
        return PageTransition(
            isIos: true,
            child: const BottomNavigation(),
            type: PageTransitionType.rightToLeft);
      case Routes.buyCarPage:
        return PageTransition(
            isIos: true,
            child: const BuyCar(),
            type: PageTransitionType.rightToLeft);
      case Routes.recommendRecentlyAddedPage:
        return PageTransition(
            isIos: true,
            child: arguments == 0
                ? const RecommendRecentlyAddedPage(pageWithLogic: 0)
                : const RecommendRecentlyAddedPage(pageWithLogic: 1),
            type: PageTransitionType.rightToLeft);
      case Routes.brandPage:
        return PageTransition(
            isIos: true,
            child: const BrandPage(),
            type: PageTransitionType.rightToLeft);
      case Routes.brandRelatedCarsPage:
        return PageTransition(
            isIos: true,
            child: const BrandRelatedCarsPage(),
            type: PageTransitionType.rightToLeft);
    // case Routes.carDetailPage:
    //   return PageTransition(
    //       isIos: true,
    //       child: CarDetailPage(carId: arguments as String),
    //       type: PageTransitionType.rightToLeft
    //   );
      case Routes.ownerDetailsPage:
        return PageTransition(
            isIos: true,
            child: const OwnerDetailsPage(),
            type: PageTransitionType.rightToLeft);
      case Routes.bookTestDrivePage:
        return PageTransition(
            isIos: true,
            child: const BookTestDrivePage(),
            type: PageTransitionType.rightToLeft);
      case Routes.checkOutPage:
        return PageTransition(
            isIos: true,
            child: const CheckOutPage(),
            type: PageTransitionType.rightToLeft);
      case Routes.paymentPage:
        return PageTransition(
            isIos: true,
            child: const PaymentPage(),
            type: PageTransitionType.rightToLeft);
      case Routes.paymentSucessPage:
        return PageTransition(
            isIos: true,
            child: arguments == 0
                ? const PaymentSucessPage(pageFor: 0)
                : arguments == 1
                ? const PaymentSucessPage(pageFor: 1)
                : const PaymentSucessPage(pageFor: 2),
            type: PageTransitionType.rightToLeft);
      case Routes.confirmLocationPage:
        return PageTransition(
            isIos: true,
            child: const ConfirmLocationPage(),
            type: PageTransitionType.rightToLeft);
      case Routes.searchPage:
        return PageTransition(
            isIos: true,
            child: const SearchPage(),
            type: PageTransitionType.rightToLeft);
      case Routes.notificationPage:
        return PageTransition(
            isIos: true,
            child: const NotificationPage(),
            type: PageTransitionType.rightToLeft);
      case Routes.reviewsPage:
        return PageTransition(
            isIos: true,
            child: const ReviewsPage(),
            type: PageTransitionType.rightToLeft);
      case Routes.sellCarPage:
        return PageTransition(
            isIos: true,
            child: const SellCar(),
            type: PageTransitionType.rightToLeft);
      case Routes.testDriveOrInspectionPage:
        return PageTransition(
            isIos: true,
            child: arguments == 'testDrive'
                ? const TestDriveOrInspectionPage(pageFor: 'Testdrive')
                : const TestDriveOrInspectionPage(pageFor: 'Book inspection'),
            type: PageTransitionType.rightToLeft);
      case Routes.addAddressPage:
        return PageTransition(
            isIos: true,
            child: arguments == false
                ? const AddAddressPage(navigateBack: false)
                : const AddAddressPage(navigateBack: true),
            type: PageTransitionType.rightToLeft);
      case Routes.modelSelectPage:
        return PageTransition(
            isIos: true,
            child: const ModelSelectPage(),
            type: PageTransitionType.rightToLeft);
      case Routes.basicDetailPage:
        return PageTransition(
            isIos: true,
            child: const BasicDetailPage(),
            type: PageTransitionType.rightToLeft);
      case Routes.basicDetailPage2:
        return PageTransition(
            isIos: true,
            child: const BasicDetailPage2(),
            type: PageTransitionType.rightToLeft);
      case Routes.contactDetailPage:
        return PageTransition(
            isIos: true,
            child: const ContactDetailPage(),
            type: PageTransitionType.rightToLeft);
      case Routes.bookInspectionPage:
        return PageTransition(
            isIos: true,
            child: const BookInspectionPage(),
            type: PageTransitionType.rightToLeft);
      case Routes.bookInspectionWithLocationPage:
        return PageTransition(
            isIos: true,
            child: const BookInspectionWithLocationPage(),
            type: PageTransitionType.rightToLeft);
      case Routes.editProfile:
        return PageTransition(
            isIos: true,
            child: const EditProfile(),
            type: PageTransitionType.rightToLeft);
      case Routes.myBookingPage:
        return PageTransition(
            isIos: true,
            child: const MyBookingPage(),
            type: PageTransitionType.rightToLeft);
      case Routes.favouritePage:
        return PageTransition(
            isIos: true,
            child:  FavouritePage(showAppBar: false,),
            type: PageTransitionType.rightToLeft);
      case Routes.helpPage:
        return PageTransition(
            isIos: true,
            child: const HelpPage(),
            type: PageTransitionType.rightToLeft);
      case Routes.termsAndConditionPage:
        return PageTransition(
            isIos: true,
            child: const TermsAndConditionPage(),
            type: PageTransitionType.rightToLeft);
      case Routes.languagePage:
        return PageTransition(
            isIos: true,
            child: const LanguagePage(),
            type: PageTransitionType.rightToLeft);
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(child: Text('No route found')),
      ),
    );
  }
}