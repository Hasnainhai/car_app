import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_zh.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('hi'),
    Locale('id'),
    Locale('tr'),
    Locale('zh')
  ];

  /// No description provided for @onBoardTitle1.
  ///
  /// In en, this message translates to:
  /// **'Welcome WowCar'**
  String get onBoardTitle1;

  /// No description provided for @onBoardTitle2.
  ///
  /// In en, this message translates to:
  /// **'Sell refurbished car'**
  String get onBoardTitle2;

  /// No description provided for @onBoardTitle3.
  ///
  /// In en, this message translates to:
  /// **'Buy refurbished car'**
  String get onBoardTitle3;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get login;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please Confirm Your Email and Password'**
  String get loginSubtitle;

  /// No description provided for @enterMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Mobile Number'**
  String get enterMobileNumber;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterPhoneNumber;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please Create Your Account to Associated With Application'**
  String get registerSubtitle;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Name'**
  String get enterYourName;

  /// No description provided for @enterYourEmailId.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Email Address'**
  String get enterYourEmailId;

  /// No description provided for @enterYourAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter Your address'**
  String get enterYourAddress;

  /// No description provided for @enterYourCity.
  ///
  /// In en, this message translates to:
  /// **'Enter your city'**
  String get enterYourCity;

  /// No description provided for @enterYourPincode.
  ///
  /// In en, this message translates to:
  /// **'Enter your pincode'**
  String get enterYourPincode;

  /// No description provided for @otpVerification.
  ///
  /// In en, this message translates to:
  /// **'OTP Verification'**
  String get otpVerification;

  /// No description provided for @otpVerificationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Otp Has Been Sent to You on Your Mobile Number Please Enter it Below'**
  String get otpVerificationSubtitle;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @reSend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get reSend;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait'**
  String get pleaseWait;

  /// No description provided for @buyCar.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get buyCar;

  /// No description provided for @sellCar.
  ///
  /// In en, this message translates to:
  /// **'Sell Car'**
  String get sellCar;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @selectCity.
  ///
  /// In en, this message translates to:
  /// **'Select City'**
  String get selectCity;

  /// No description provided for @surat.
  ///
  /// In en, this message translates to:
  /// **'Surat'**
  String get surat;

  /// No description provided for @mumbai.
  ///
  /// In en, this message translates to:
  /// **'Mumbai'**
  String get mumbai;

  /// No description provided for @delhi.
  ///
  /// In en, this message translates to:
  /// **'Delhi'**
  String get delhi;

  /// No description provided for @hyderabad.
  ///
  /// In en, this message translates to:
  /// **'Hyderabad'**
  String get hyderabad;

  /// No description provided for @pune.
  ///
  /// In en, this message translates to:
  /// **'Pune'**
  String get pune;

  /// No description provided for @jaipur.
  ///
  /// In en, this message translates to:
  /// **'Jaipur'**
  String get jaipur;

  /// No description provided for @ahemdabad.
  ///
  /// In en, this message translates to:
  /// **'Ahemdabad'**
  String get ahemdabad;

  /// No description provided for @anand.
  ///
  /// In en, this message translates to:
  /// **'Anand'**
  String get anand;

  /// No description provided for @jetpur.
  ///
  /// In en, this message translates to:
  /// **'Jetpur'**
  String get jetpur;

  /// No description provided for @nagpur.
  ///
  /// In en, this message translates to:
  /// **'Nagpur'**
  String get nagpur;

  /// No description provided for @vadodara.
  ///
  /// In en, this message translates to:
  /// **'Vadodara'**
  String get vadodara;

  /// No description provided for @gaziyabad.
  ///
  /// In en, this message translates to:
  /// **'Gaziyabad'**
  String get gaziyabad;

  /// No description provided for @agra.
  ///
  /// In en, this message translates to:
  /// **'Agra'**
  String get agra;

  /// No description provided for @nashik.
  ///
  /// In en, this message translates to:
  /// **'Nashik'**
  String get nashik;

  /// No description provided for @searchYourCar.
  ///
  /// In en, this message translates to:
  /// **'Search Your Car'**
  String get searchYourCar;

  /// No description provided for @recentlyAddedCar.
  ///
  /// In en, this message translates to:
  /// **'Recently Added Cars'**
  String get recentlyAddedCar;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @recommendedForYou.
  ///
  /// In en, this message translates to:
  /// **'Featured Cars'**
  String get recommendedForYou;

  /// No description provided for @mostPopularBrand.
  ///
  /// In en, this message translates to:
  /// **'Most Popular Brands'**
  String get mostPopularBrand;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @easyFinancing.
  ///
  /// In en, this message translates to:
  /// **'Easy Financing'**
  String get easyFinancing;

  /// No description provided for @doorStepDelivery.
  ///
  /// In en, this message translates to:
  /// **'Doorstep delivery'**
  String get doorStepDelivery;

  /// No description provided for @dayReturn.
  ///
  /// In en, this message translates to:
  /// **'7 day return'**
  String get dayReturn;

  /// No description provided for @yearWarranty.
  ///
  /// In en, this message translates to:
  /// **'1 Year warranty'**
  String get yearWarranty;

  /// No description provided for @ourCustomerReview.
  ///
  /// In en, this message translates to:
  /// **'Our customer review'**
  String get ourCustomerReview;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @writeYourReview.
  ///
  /// In en, this message translates to:
  /// **'Write your review'**
  String get writeYourReview;

  /// No description provided for @viewMore.
  ///
  /// In en, this message translates to:
  /// **'View more'**
  String get viewMore;

  /// No description provided for @brand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get brand;

  /// No description provided for @nissan.
  ///
  /// In en, this message translates to:
  /// **'Nissan'**
  String get nissan;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @sortBy1.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy1;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @minPrice.
  ///
  /// In en, this message translates to:
  /// **'Min price'**
  String get minPrice;

  /// No description provided for @maxPrice.
  ///
  /// In en, this message translates to:
  /// **'Max price'**
  String get maxPrice;

  /// No description provided for @kmDriven.
  ///
  /// In en, this message translates to:
  /// **'KM Driven'**
  String get kmDriven;

  /// No description provided for @fuelType.
  ///
  /// In en, this message translates to:
  /// **'Fuel type'**
  String get fuelType;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Colour'**
  String get color;

  /// No description provided for @transmission.
  ///
  /// In en, this message translates to:
  /// **'Transmission'**
  String get transmission;

  /// No description provided for @seat.
  ///
  /// In en, this message translates to:
  /// **'Seat'**
  String get seat;

  /// No description provided for @owner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get owner;

  /// No description provided for @ownerDetail.
  ///
  /// In en, this message translates to:
  /// **'Owner detail'**
  String get ownerDetail;

  /// No description provided for @bodyType.
  ///
  /// In en, this message translates to:
  /// **'Body Type'**
  String get bodyType;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @addedFav.
  ///
  /// In en, this message translates to:
  /// **'Added to Favourites'**
  String get addedFav;

  /// No description provided for @removedFav.
  ///
  /// In en, this message translates to:
  /// **'Removed from Favourites'**
  String get removedFav;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notification;

  /// No description provided for @notificationRemoved.
  ///
  /// In en, this message translates to:
  /// **'Notification Removed'**
  String get notificationRemoved;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterDay.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterDay;

  /// No description provided for @emptyNotificationMsg.
  ///
  /// In en, this message translates to:
  /// **'No notification yet'**
  String get emptyNotificationMsg;

  /// No description provided for @allInclusivePrice.
  ///
  /// In en, this message translates to:
  /// **'All inclusive price'**
  String get allInclusivePrice;

  /// No description provided for @customizeEMIPlans.
  ///
  /// In en, this message translates to:
  /// **'Customize EMI Plans'**
  String get customizeEMIPlans;

  /// No description provided for @benefits.
  ///
  /// In en, this message translates to:
  /// **'Benefits'**
  String get benefits;

  /// No description provided for @inculudesInPrice.
  ///
  /// In en, this message translates to:
  /// **'inculudes in price'**
  String get inculudesInPrice;

  /// No description provided for @carOverview.
  ///
  /// In en, this message translates to:
  /// **'Car overview'**
  String get carOverview;

  /// No description provided for @moreImage.
  ///
  /// In en, this message translates to:
  /// **'More Image'**
  String get moreImage;

  /// No description provided for @carCondition.
  ///
  /// In en, this message translates to:
  /// **'Car Condition'**
  String get carCondition;

  /// No description provided for @faqS.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get faqS;

  /// No description provided for @continueBooking.
  ///
  /// In en, this message translates to:
  /// **'Continue Booking'**
  String get continueBooking;

  /// No description provided for @bookTestdrive.
  ///
  /// In en, this message translates to:
  /// **'Book testdrive'**
  String get bookTestdrive;

  /// No description provided for @conti.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get conti;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @applyForEMI.
  ///
  /// In en, this message translates to:
  /// **'Apply for EMI'**
  String get applyForEMI;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// No description provided for @whatHappensNext.
  ///
  /// In en, this message translates to:
  /// **'What happens next'**
  String get whatHappensNext;

  /// No description provided for @proceedToPay.
  ///
  /// In en, this message translates to:
  /// **'Proceed to pay'**
  String get proceedToPay;

  /// No description provided for @selectPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Select payment method'**
  String get selectPaymentMethod;

  /// No description provided for @creditCard.
  ///
  /// In en, this message translates to:
  /// **'CreditCard'**
  String get creditCard;

  /// No description provided for @upi.
  ///
  /// In en, this message translates to:
  /// **'UPI'**
  String get upi;

  /// No description provided for @paytm.
  ///
  /// In en, this message translates to:
  /// **'Paytm'**
  String get paytm;

  /// No description provided for @cardNumber.
  ///
  /// In en, this message translates to:
  /// **'Card number'**
  String get cardNumber;

  /// No description provided for @expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry date'**
  String get expiryDate;

  /// No description provided for @cvv.
  ///
  /// In en, this message translates to:
  /// **'CVV'**
  String get cvv;

  /// No description provided for @cardName.
  ///
  /// In en, this message translates to:
  /// **'Card name'**
  String get cardName;

  /// No description provided for @congretulationYour.
  ///
  /// In en, this message translates to:
  /// **'Congretulation your'**
  String get congretulationYour;

  /// No description provided for @bookSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'book successfully'**
  String get bookSuccessfully;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get backToHome;

  /// No description provided for @selectLocation.
  ///
  /// In en, this message translates to:
  /// **'Select location'**
  String get selectLocation;

  /// No description provided for @carmaxHub.
  ///
  /// In en, this message translates to:
  /// **'Wowcar hub'**
  String get carmaxHub;

  /// No description provided for @yourLocation.
  ///
  /// In en, this message translates to:
  /// **'Your location'**
  String get yourLocation;

  /// No description provided for @carmaxLocation.
  ///
  /// In en, this message translates to:
  /// **'Wowcar location'**
  String get carmaxLocation;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @selectTime.
  ///
  /// In en, this message translates to:
  /// **'Select time'**
  String get selectTime;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @testDriveBookedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Congretulation your testdrive is successfully book'**
  String get testDriveBookedSuccess;

  /// No description provided for @yourInspectCar.
  ///
  /// In en, this message translates to:
  /// **'Your inspect Car'**
  String get yourInspectCar;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @selectCarBrand.
  ///
  /// In en, this message translates to:
  /// **'Select your car brand to get started'**
  String get selectCarBrand;

  /// No description provided for @sellInEasyStep.
  ///
  /// In en, this message translates to:
  /// **'Sell in 3 easy step'**
  String get sellInEasyStep;

  /// No description provided for @carDetail.
  ///
  /// In en, this message translates to:
  /// **'Car details'**
  String get carDetail;

  /// No description provided for @doorstepInspect.
  ///
  /// In en, this message translates to:
  /// **'Doorstep inspect'**
  String get doorstepInspect;

  /// No description provided for @instantPayment.
  ///
  /// In en, this message translates to:
  /// **'Instant payment'**
  String get instantPayment;

  /// No description provided for @step.
  ///
  /// In en, this message translates to:
  /// **'Step'**
  String get step;

  /// No description provided for @bookInspection.
  ///
  /// In en, this message translates to:
  /// **'Book inspection'**
  String get bookInspection;

  /// No description provided for @testDrive.
  ///
  /// In en, this message translates to:
  /// **'Testdrive'**
  String get testDrive;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @cancelInspection.
  ///
  /// In en, this message translates to:
  /// **'Cancel inspection'**
  String get cancelInspection;

  /// No description provided for @cancelTestDrive.
  ///
  /// In en, this message translates to:
  /// **'Cancel testdrive'**
  String get cancelTestDrive;

  /// No description provided for @enterDate.
  ///
  /// In en, this message translates to:
  /// **'Enter date'**
  String get enterDate;

  /// No description provided for @enterTime.
  ///
  /// In en, this message translates to:
  /// **'Enter time'**
  String get enterTime;

  /// No description provided for @areYouSureTestDrive.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want cancel testdrive?'**
  String get areYouSureTestDrive;

  /// No description provided for @areYouSureInspection.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want cancel inspection?'**
  String get areYouSureInspection;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @selectCarModel.
  ///
  /// In en, this message translates to:
  /// **'Select car model'**
  String get selectCarModel;

  /// No description provided for @allModels.
  ///
  /// In en, this message translates to:
  /// **'All models'**
  String get allModels;

  /// No description provided for @carBasicDetail.
  ///
  /// In en, this message translates to:
  /// **'Car basic detail'**
  String get carBasicDetail;

  /// No description provided for @cbd1.
  ///
  /// In en, this message translates to:
  /// **'Registration Number'**
  String get cbd1;

  /// No description provided for @cbd2.
  ///
  /// In en, this message translates to:
  /// **'Kilometers driven'**
  String get cbd2;

  /// No description provided for @cbd3.
  ///
  /// In en, this message translates to:
  /// **'Number of owner'**
  String get cbd3;

  /// No description provided for @cbd3hintText.
  ///
  /// In en, this message translates to:
  /// **'Select number of owner'**
  String get cbd3hintText;

  /// No description provided for @cbd4.
  ///
  /// In en, this message translates to:
  /// **'Car manufacturing year'**
  String get cbd4;

  /// No description provided for @cbd4hintText.
  ///
  /// In en, this message translates to:
  /// **'Select car manufacturing year'**
  String get cbd4hintText;

  /// No description provided for @cbd5.
  ///
  /// In en, this message translates to:
  /// **'Fuel type'**
  String get cbd5;

  /// No description provided for @cbd5hintText.
  ///
  /// In en, this message translates to:
  /// **'Select car fuel type'**
  String get cbd5hintText;

  /// No description provided for @cbd6.
  ///
  /// In en, this message translates to:
  /// **'Transmission type'**
  String get cbd6;

  /// No description provided for @cbd6hintText.
  ///
  /// In en, this message translates to:
  /// **'Select car transmission type'**
  String get cbd6hintText;

  /// No description provided for @cbd7.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get cbd7;

  /// No description provided for @cbd7hintText.
  ///
  /// In en, this message translates to:
  /// **'Select car registration state'**
  String get cbd7hintText;

  /// No description provided for @cbd8.
  ///
  /// In en, this message translates to:
  /// **'Car condition'**
  String get cbd8;

  /// No description provided for @cbd8hintText.
  ///
  /// In en, this message translates to:
  /// **'Select car condition'**
  String get cbd8hintText;

  /// No description provided for @cbd9.
  ///
  /// In en, this message translates to:
  /// **'Car insurance type'**
  String get cbd9;

  /// No description provided for @cbd9hintText.
  ///
  /// In en, this message translates to:
  /// **'Select car insurance'**
  String get cbd9hintText;

  /// No description provided for @cbd10.
  ///
  /// In en, this message translates to:
  /// **'Active loan'**
  String get cbd10;

  /// No description provided for @cbd10hintText.
  ///
  /// In en, this message translates to:
  /// **'Select active loan'**
  String get cbd10hintText;

  /// No description provided for @cbd11.
  ///
  /// In en, this message translates to:
  /// **'Ownership type'**
  String get cbd11;

  /// No description provided for @cbd11hintText.
  ///
  /// In en, this message translates to:
  /// **'Select car owner type'**
  String get cbd11hintText;

  /// No description provided for @manufacturingYear.
  ///
  /// In en, this message translates to:
  /// **'Manufacturing year'**
  String get manufacturingYear;

  /// No description provided for @petrol.
  ///
  /// In en, this message translates to:
  /// **'Petrol'**
  String get petrol;

  /// No description provided for @diesel.
  ///
  /// In en, this message translates to:
  /// **'Diesel'**
  String get diesel;

  /// No description provided for @cng.
  ///
  /// In en, this message translates to:
  /// **'CNG'**
  String get cng;

  /// No description provided for @manual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get manual;

  /// No description provided for @automatic.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get automatic;

  /// No description provided for @carRegistrationState.
  ///
  /// In en, this message translates to:
  /// **'Car registration state'**
  String get carRegistrationState;

  /// No description provided for @state1.
  ///
  /// In en, this message translates to:
  /// **'Delhi'**
  String get state1;

  /// No description provided for @state2.
  ///
  /// In en, this message translates to:
  /// **'Gujrat'**
  String get state2;

  /// No description provided for @state3.
  ///
  /// In en, this message translates to:
  /// **'Maharashtra'**
  String get state3;

  /// No description provided for @state4.
  ///
  /// In en, this message translates to:
  /// **'Haryana'**
  String get state4;

  /// No description provided for @state5.
  ///
  /// In en, this message translates to:
  /// **'Karnataka'**
  String get state5;

  /// No description provided for @state6.
  ///
  /// In en, this message translates to:
  /// **'Andhra Pradesh'**
  String get state6;

  /// No description provided for @state7.
  ///
  /// In en, this message translates to:
  /// **'Uttar Pradesh'**
  String get state7;

  /// No description provided for @state8.
  ///
  /// In en, this message translates to:
  /// **'Rajsthan'**
  String get state8;

  /// No description provided for @state9.
  ///
  /// In en, this message translates to:
  /// **'Punjab'**
  String get state9;

  /// No description provided for @condition1.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get condition1;

  /// No description provided for @condition2.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get condition2;

  /// No description provided for @condition3.
  ///
  /// In en, this message translates to:
  /// **'Very good'**
  String get condition3;

  /// No description provided for @condition4.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get condition4;

  /// No description provided for @insuranceType.
  ///
  /// In en, this message translates to:
  /// **'Insurance type'**
  String get insuranceType;

  /// No description provided for @insurance1.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive'**
  String get insurance1;

  /// No description provided for @insurance2.
  ///
  /// In en, this message translates to:
  /// **'Third party'**
  String get insurance2;

  /// No description provided for @insurance3.
  ///
  /// In en, this message translates to:
  /// **'Zero depreciation'**
  String get insurance3;

  /// No description provided for @insurance4.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get insurance4;

  /// No description provided for @anyActiveLoan.
  ///
  /// In en, this message translates to:
  /// **'Any active loan'**
  String get anyActiveLoan;

  /// No description provided for @contactDetails.
  ///
  /// In en, this message translates to:
  /// **'Contact details'**
  String get contactDetails;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @editLocation.
  ///
  /// In en, this message translates to:
  /// **'Edit location'**
  String get editLocation;

  /// No description provided for @addressTitle1.
  ///
  /// In en, this message translates to:
  /// **'House/Building  number'**
  String get addressTitle1;

  /// No description provided for @addressTitle2.
  ///
  /// In en, this message translates to:
  /// **'House/Building  name'**
  String get addressTitle2;

  /// No description provided for @addressTitle3.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get addressTitle3;

  /// No description provided for @addressTitle3hintText.
  ///
  /// In en, this message translates to:
  /// **'City name'**
  String get addressTitle3hintText;

  /// No description provided for @addressTitle4.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get addressTitle4;

  /// No description provided for @addressTitle4hintText.
  ///
  /// In en, this message translates to:
  /// **'Country name'**
  String get addressTitle4hintText;

  /// No description provided for @addressTitle5.
  ///
  /// In en, this message translates to:
  /// **'Address type-i.e Home , office,etc'**
  String get addressTitle5;

  /// No description provided for @addressTitle5hintText.
  ///
  /// In en, this message translates to:
  /// **'Address type'**
  String get addressTitle5hintText;

  /// No description provided for @saveAddress.
  ///
  /// In en, this message translates to:
  /// **'Save address'**
  String get saveAddress;

  /// No description provided for @congretulations.
  ///
  /// In en, this message translates to:
  /// **'Congretulations!'**
  String get congretulations;

  /// No description provided for @assuredBestCarPrice.
  ///
  /// In en, this message translates to:
  /// **'Assured best car price'**
  String get assuredBestCarPrice;

  /// No description provided for @thisIsNotFinalPrice.
  ///
  /// In en, this message translates to:
  /// **'*this is not final price final price  will be fix after end of the inspection'**
  String get thisIsNotFinalPrice;

  /// No description provided for @selectPlaceOfInspection.
  ///
  /// In en, this message translates to:
  /// **'Select place of inspection'**
  String get selectPlaceOfInspection;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @nearestBranch.
  ///
  /// In en, this message translates to:
  /// **'Nearest branch'**
  String get nearestBranch;

  /// No description provided for @proceed.
  ///
  /// In en, this message translates to:
  /// **'Proceed'**
  String get proceed;

  /// No description provided for @confirmLocation.
  ///
  /// In en, this message translates to:
  /// **'Confirm location'**
  String get confirmLocation;

  /// No description provided for @inspectionSuccessfullyBook.
  ///
  /// In en, this message translates to:
  /// **'inspection successfully book '**
  String get inspectionSuccessfullyBook;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @profileItem1.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get profileItem1;

  /// No description provided for @profileItem2.
  ///
  /// In en, this message translates to:
  /// **'My Listings'**
  String get profileItem2;

  /// No description provided for @profileItem3.
  ///
  /// In en, this message translates to:
  /// **'Wowcar Location'**
  String get profileItem3;

  /// No description provided for @profileItem4.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileItem4;

  /// No description provided for @profileItem5.
  ///
  /// In en, this message translates to:
  /// **'My Favorites'**
  String get profileItem5;

  /// No description provided for @profileItem6.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get profileItem6;

  /// No description provided for @profileItem7.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get profileItem7;

  /// No description provided for @profileItem8.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get profileItem8;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @goDetail.
  ///
  /// In en, this message translates to:
  /// **'Go detail'**
  String get goDetail;

  /// No description provided for @emptyFavList.
  ///
  /// In en, this message translates to:
  /// **'Empty favourite list'**
  String get emptyFavList;

  /// No description provided for @helpTitle.
  ///
  /// In en, this message translates to:
  /// **'How Can WowCar Help You?'**
  String get helpTitle;

  /// No description provided for @emailId.
  ///
  /// In en, this message translates to:
  /// **'Email id'**
  String get emailId;

  /// No description provided for @areYouSureSignout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to Log Out?'**
  String get areYouSureSignout;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @pressBackAgain.
  ///
  /// In en, this message translates to:
  /// **'Press back again to exit'**
  String get pressBackAgain;

  /// No description provided for @yourBenefits.
  ///
  /// In en, this message translates to:
  /// **'Your benefits'**
  String get yourBenefits;

  /// No description provided for @included.
  ///
  /// In en, this message translates to:
  /// **'INCLUDED'**
  String get included;

  /// No description provided for @emiCalculator.
  ///
  /// In en, this message translates to:
  /// **'EMI Calculator'**
  String get emiCalculator;

  /// No description provided for @intrestRate.
  ///
  /// In en, this message translates to:
  /// **'Intrest rate'**
  String get intrestRate;

  /// No description provided for @loanAmount.
  ///
  /// In en, this message translates to:
  /// **'Loan amount'**
  String get loanAmount;

  /// No description provided for @downPayment.
  ///
  /// In en, this message translates to:
  /// **'Down payment'**
  String get downPayment;

  /// No description provided for @loanPeriod.
  ///
  /// In en, this message translates to:
  /// **'Loan period'**
  String get loanPeriod;

  /// No description provided for @perMonth.
  ///
  /// In en, this message translates to:
  /// **'per month'**
  String get perMonth;

  /// No description provided for @selectImage.
  ///
  /// In en, this message translates to:
  /// **'Select Image'**
  String get selectImage;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get takePhoto;

  /// No description provided for @chooseFromLib.
  ///
  /// In en, this message translates to:
  /// **'Choose from library'**
  String get chooseFromLib;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get removePhoto;

  /// No description provided for @favourite.
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get favourite;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en', 'hi', 'id', 'tr', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
    case 'hi': return AppLocalizationsHi();
    case 'id': return AppLocalizationsId();
    case 'tr': return AppLocalizationsTr();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
