import 'dart:io';

import 'package:fl_carmax/bottom_nav_provider.dart';
import 'package:fl_carmax/common_libs.dart';
import 'package:fl_carmax/helper/language_constant.dart';
import 'package:fl_carmax/pages/account/account.dart';
import 'package:fl_carmax/pages/auth/login_page_email.dart';

import 'package:fl_carmax/pages/buy_car/compare_page/compare_controller.dart';
import 'package:fl_carmax/pages/buy_car/component/buy_car_appbar.dart';
import 'package:fl_carmax/pages/buy_car/provider/home_provider.dart';
import 'package:fl_carmax/sell_car_screen.dart';

import 'pages/buy_car/compare_page/compare_page.dart';
import 'utils/constant.dart';

GlobalKey<State<BottomNavigation>> bottomNavigationKey = GlobalKey();

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  late BottomNavProvider bottomNavProvider;

  @override
  void initState() {
    super.initState();
    bottomNavProvider = Provider.of<BottomNavProvider>(context, listen: false);
    Provider.of<HomeProvider>(context, listen: false).loadSavedLanguage();
    Future.wait([bottomNavProvider.getUserData(),]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool backStatus = bottomNavProvider.onWillPopAction(context);
        if (backStatus) {
          exit(0);
        }
        return false;
      },
      child: Consumer3<HomeProvider, CompareProvider,BottomNavProvider>(
          builder: (context, provider, compareProvider,bNavProvider, _) {
        return Scaffold(
          appBar: bNavProvider.currentIndx == 0
              ? appBarMethod(provider, context)
              : AppBar(
                  title: Text(
                    _switchTitle(bNavProvider.currentIndx),
                    style: blackSemiBold16,
                  ),

                  actions: bNavProvider.currentIndx == 2
                      ? [
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.grey,
                            ),
                            tooltip: 'Reset',
                            onPressed: () {
                              compareProvider.clear();
                            },
                          ),
                        ]
                      : [],
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 14),
                    child: GestureDetector(
                        onTap: () {
                          bNavProvider.goToFirstTab();
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: black,
                        )),
                  ),
                  automaticallyImplyLeading: false,
                  backgroundColor: white,
                  leadingWidth: 35,
                ),
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(canvasColor: white, splashColor: transparent),
            child: BottomNavigationBar(
              elevation: 20,
              items: [
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: SizedBox(
                        height: 2.6.h,
                        child: Image.asset(home1,
                            color: bNavProvider.currentIndx == 0 ? primaryColor : colorB4),
                      ),
                    ),
                    label: translation(context).buyCar),
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: SizedBox(
                        height: 3.h,
                        child: Image.asset(bN2,
                            color: bNavProvider.currentIndx == 1 ? primaryColor : colorB4),
                      ),
                    ),
                    label: translation(context).sellCar),
                /*BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: SizedBox(
                        height: 2.7.h,
                        child: Icon(Icons.compare_arrows,
                            color: selectedIndex == 2 ? primaryColor : colorB4),
                      ),
                    ),
                    label: translation(context).favourite),*/
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: SizedBox(
                        height: 2.7.h,
                        child: Icon(Icons.favorite_outline,
                            color: bNavProvider.currentIndx == 2 ? primaryColor : colorB4),
                      ),
                    ),
                    label: 'Favorites'),
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: SizedBox(
                        height: 2.7.h,
                        child: Image.asset(userIcon,
                            color: bNavProvider.currentIndx == 3 ? primaryColor : colorB4),
                      ),
                    ),
                    label: translation(context).account),
              ],
              onTap: (int index) {
                bNavProvider.setCurrentIndex(index);
                if(index == 2){
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if(bNavProvider.userName==null){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const LoginPageEmail()),
                      );
                      return;
                    }else{
                      Future.wait([compareProvider.loadWishlist(),]);
                    }
                  });
                }
                /*if(index==3){
                  if(bNavProvider.userName==null){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const LoginPageEmail()),
                    );
                  }else{
                     bNavProvider.setCurrentIndex(index);
                  }
                }else{
                  bNavProvider.setCurrentIndex(index);
                }*/
              },
              currentIndex: bNavProvider.currentIndx,
              selectedItemColor: primaryColor,
              unselectedItemColor: color94,
              showUnselectedLabels: true,
              selectedLabelStyle: primaryMedium14,
              unselectedLabelStyle: color94Medium14,
              type: BottomNavigationBarType.fixed,
            ),
          ),
          body: bNavProvider.widgetOptions.elementAt(bNavProvider.currentIndx),
        );
      }),
    );
  }

  String _switchTitle(int index) {
    switch (index) {
      case 0:
        return "Home";
      case 1:
        return "Sale Car";
      case 2:
        return "Favorites";
      case 3:
        return "Profile";
      default:
        return '';
    }
    // case 2:
    //   return "Compare";
  }

}
