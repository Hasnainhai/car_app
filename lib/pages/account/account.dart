import 'package:fl_carmax/bottom_nav_provider.dart';
import 'package:fl_carmax/common_libs.dart';
import 'package:fl_carmax/helper/ui_helper.dart';
import 'package:fl_carmax/pages/auth/login_page_email.dart';
import 'package:fl_carmax/pages/buy_car/compare_page/compare_controller.dart';
import 'package:fl_carmax/utils/constant.dart';
import 'package:fl_carmax/utils/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../helper/language_constant.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String? userName;
  String? userPhone;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.wait([getUserData(),]);
  }

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('username');
      userPhone = prefs.getString('email'); // or 'phone' if you store phone
      isLoading = false;
    });
  }

  void navigateOrLogin(BuildContext context, String route) {
    if (userName == null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const LoginPageEmail()));
    } else {
      Navigator.pushNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : buildLoggedInBody(context);
  }

  Widget buildLoggedInBody(BuildContext context) {
    bool isLoggedIn = userName != null;

    List profileItems = [
      {
        'icon': profile1,
        'title': translation(context).profileItem1,
        'navigate': isLoggedIn ? '/EditProfile' : null,
      },
      {
        'icon': profile2,
        'title': translation(context).profileItem2,
        'navigate': isLoggedIn ? '/SearchPage' : null,
      },
      {
        'icon': profile4,
        'title': translation(context).profileItem4,
        'navigate': '/LanguagePage', // always accessible
      },
      {
        'icon': profile5,
        'title': translation(context).profileItem5,
        'navigate': isLoggedIn ? '/FavouritePage' : null,
      },
      {
        'icon': profile6,
        'title': translation(context).profileItem6,
        'navigate': '/HelpPage',
      },
      
    ];

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              heightSpace25,
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: colorE6,
                    backgroundImage: const AssetImage(
                      'assets/images/natural_avatar.png',
                    ),
                  ),
                  widthSpace15,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userName ?? 'Guest', style: blackMedium16),
                      Text(userPhone ?? '', style: colorA6Medium14),
                    ],
                  )
                ],
              ),
              heightSpace30,
              Column(
                children: profileItems.map((item) {
                  return PrimaryContainer(
                    onTap: () {
                      if (item['navigate'] == null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LoginPageEmail()),
                        );
                      }
                     else if(item['navigate'] == '/FavouritePage'){
                       BottomNavProvider prv = Provider.of<BottomNavProvider>(context, listen: false);
                       CompareProvider comp = Provider.of<CompareProvider>(context, listen: false);
                       prv.setCurrentIndex(2);
                       Future.wait([comp.loadWishlist(),]);
                     }
                      else if(item['navigate'] == '/SearchPage'){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ListingScreen()),
                        );
                      }
                      else {
                        Navigator.pushNamed(context, item['navigate']);
                      }
                    },
                    margin: const EdgeInsets.only(bottom: 25),
                    padding: const EdgeInsets.symmetric(
                        vertical: 13, horizontal: 18),
                    child: Row(
                      children: [
                        Image.asset(item['icon'], height: 2.3.h),
                        widthSpace12,
                        Text(item['title'], style: blackMedium15),
                        const Spacer(),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                  );
                }).toList(),
              ),
              if (isLoggedIn)
                PrimaryContainer(
                  onTap: () {
                    UiHelper.showLogOutDialog(context, onConfirm: () async {
                      BottomNavProvider bnPrv =
                          Provider.of<BottomNavProvider>(context, listen: false);
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.clear();
                      setState(() {
                        userName = null;
                        userPhone = null;
                        bnPrv.userName = null;
                      });
                      if(context.mounted){
                        Navigator.pop(context);
                      }// close dialog
                    });
                  },
                  margin: const EdgeInsets.only(bottom: 25),
                  padding:
                      const EdgeInsets.symmetric(vertical: 13, horizontal: 18),
                  child: Row(
                    children: [
                      Image.asset(profile8, height: 2.3.h, color: primaryColor),
                      widthSpace12,
                      Text(translation(context).profileItem8, style: orgMedium),
                      const Spacer(),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListingScreen extends StatelessWidget {
  const ListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Listing",
          style: blackSemiBold16,
        ),
        backgroundColor: white,
        centerTitle: false,
        leadingWidth: 30,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back,
                color: black,
              )),
        ),
        automaticallyImplyLeading: false,
      ),
      body:   Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: RichText(
              text: TextSpan(
                style: blackSemiBold16,
                children: [
                  const TextSpan(text: "Please visit the website "),
                  TextSpan(
                    text: 'wowcar.co.th',
                    style: blackSemiBold16.copyWith(
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        final Uri url = Uri.parse('https://www.wowcar.co.th/login-and-register/');
                        if (!await launchUrl(url)) {
                          if(context.mounted){
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Could not launch website')),
                            );
                          }
                        }
                      },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    /*const WebViewPage(
      url: 'https://www.wowcar.co.th/login-and-register/',
      title: 'Sell Car',
    );*/
  }

}
