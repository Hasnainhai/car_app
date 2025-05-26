import 'package:fl_carmax/utils/constant.dart';
import '../../../common_libs.dart';
import '../../auth/login_page_email.dart';
import '../provider/home_provider.dart';

AppBar appBarMethod(HomeProvider homeProvider, BuildContext context) {
  return AppBar(
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      statusBarColor: primaryColor,
    ),
    titleSpacing: 0,
    automaticallyImplyLeading: false,
    shadowColor: colorForShadow.withOpacity(.25),
    backgroundColor: white,
    centerTitle: false,
    title: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              homeProvider.showLanguagesDialog(context);
            },
            child: Row(
              children: [
                Image.asset(
                  profile4,
                  height: 24,
                ),
                widthSpace10,
                Consumer<HomeProvider>(
                  builder: (context, provider, child) {
                    return Text(
                       provider.selectedLanguage != '' && provider.selectedLanguage != null
                          ? provider.selectedLanguage : 'English',
                      style: blackMedium17,
                    );
                  },
                ),
                const RotatedBox(
                    quarterTurns: 3,
                    child: Icon(
                      Icons.chevron_left,
                      color: black,
                      size: 20,
                    ))
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              final userId = prefs.getInt('user_id');

              if (userId == null || userId == 0) {
                // Not logged in → go to login page
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginPageEmail()),
                  );
                }
              } else {
                // Logged in → go to notifications
                if (context.mounted) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationPage()));
                }
              }
            },
            child: Image.asset(
              homeNotificationIcon,
              height: 2.6.h,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    ),
  );
}
