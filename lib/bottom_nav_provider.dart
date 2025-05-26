

import 'package:fl_carmax/helper/language_constant.dart';
import 'package:fl_carmax/pages/account/account.dart';
import 'package:fl_carmax/sell_car_screen.dart';
import 'package:fl_carmax/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bindings/pages_lib.dart';

class BottomNavProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndx => _currentIndex;

  final List<Widget> widgetOptions = <Widget>[
    const BuyCar(),
    const SellCarScreen(),
    // const ComparePage(
    //   showBackButton: false,
    // ),
    const FavouritePage(showAppBar: false,),
    const Account(),
  ];

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  goToFirstTab(){
    _currentIndex = 0;
    notifyListeners();
  }
  String? userName;
  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      userName = prefs.getString('username');
      notifyListeners();
  }

  DateTime? currentBackPressTime;
  bool onWillPopAction(BuildContext context) {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: primaryColor,
        content:
        Text(translation(context).pressBackAgain, style: whiteMedium14),
        duration: const Duration(seconds: 1),
      ));
      return false;
    } else {
      return true;
    }
  }

}