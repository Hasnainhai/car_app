import 'package:fl_carmax/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../helper/language_constant.dart';
import '../../utils/constant.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final _pageController = PageController();
  int _pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
                child: PageView(
              controller: _pageController,
              onPageChanged: (value) => setState(() => _pageIndex = value),
              children: List.generate(
                3,
                (index) => Column(
                  children: [
                    Image.asset(
                      index == 0
                          ? onBoard1
                          : index == 1
                              ? onBoard2
                              : onBoard3,
                      height: 64.h,
                      width: 100.w,
                      fit: BoxFit.fill,
                    ),
                    heightSpace20,
                    heightSpace2,
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: 3,
                      axisDirection: Axis.horizontal,
                      effect: SlideEffect(
                          spacing: 8.0,
                          // radius: 4.0,
                          dotWidth: 8.0,
                          dotHeight: 8.0,
                          // paintStyle: PaintingStyle.stroke,
                          strokeWidth: 1.5,
                          dotColor: color94,
                          activeDotColor: primaryColor),
                    ),
                    heightSpace45,
                    heightSpace3,
                    Text(
                        index == 0
                            ? translation(context).onBoardTitle1
                            : index == 1
                                ? translation(context).onBoardTitle2
                                : translation(context).onBoardTitle3,
                        style: primarySemiBold20),
                    heightSpace8,
                    Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Tristique nunc pellentesque in bibendum arcu. Aenean scelerisque viverra donec sed. Odio donec ',
                      style: color94Regular14,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: PrimaryButton(
                    title: translation(context).next,
                    onTap: () {
                      if (_pageIndex != 2) {
                        _pageController.animateToPage(_pageIndex + 1,
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.fastLinearToSlowEaseIn);
                      } else {
                        Navigator.pushReplacementNamed(context, '/LoginPage');
                      }
                    },
                  ),
                ),
                heightSpace10,
                heightSpace3,
                GestureDetector(
                    onTap: () {
                      if (_pageIndex != 2) {
                        _pageController.animateToPage(2,
                            duration: const Duration(milliseconds: 1500),
                            curve: Curves.fastLinearToSlowEaseIn);
                      }
                    },
                    child: Text(
                        _pageIndex != 2 ? translation(context).skip : '',
                        style: blackMedium14)),
                heightSpace20,
              ],
            )
          ],
        ),
      ),
    );
  }
}
