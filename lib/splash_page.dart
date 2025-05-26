import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _navigateAfterDelay();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // When app returns from background, restart the splash flow
      _navigateAfterDelay();
    }
  }

  void _navigateAfterDelay() {
        Future.delayed(const Duration(seconds: 3)).then(
        (value) {
          if(mounted){
            Navigator.pushReplacementNamed(context, '/BottomNavigation');
          }
        }

        // Navigator.pushReplacementNamed(context, '/OnBoardingPage')
         //Navigator.pushReplacementNamed(context, '/RegisterPage')
         );
    // Future.delayed(const Duration(seconds: 3), () {
    //   if (mounted) {
    //     Navigator.pushNamedAndRemoveUntil(
    //       context,
    //       '/BottomNavigation',
    //       (Route<dynamic> route) => false,
    //     );
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Image.asset(
            'assets/images/logo1.jpg',
            height: 30.h,
            width: 30.h,
          ),
        ),
      ),
    );
  }
}