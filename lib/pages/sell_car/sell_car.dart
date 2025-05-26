import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:sizer/sizer.dart';

import '../../helper/cities_alert_dialog.dart';
import '../../helper/language_constant.dart';
import '../../main.dart';
import '../../utils/constant.dart';
import '../../utils/widgets.dart';

class SellCar extends StatefulWidget {
  const SellCar({Key? key}) : super(key: key);

  @override
  State<SellCar> createState() => _SellCarState();
}

List sliderList = [sellCarMain, sellCarMain, sellCarMain];

class _SellCarState extends State<SellCar> {
  String _currentCity = 'Surat';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMethod(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            carouselSliderMethod(context),
            inspectCarMethod(),
            selectBrandMethod(),
            sellWithEasyStepMethod(),
            ...faqMethod(),
            customerReviewMethod()
          ],
        ),
      ),
    );
  }

  Widget customerReviewMethod() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(translation(context).ourCustomerReview, style: blackMedium16),
            heightSpace15,
            Column(
                children: List.generate(
              3,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: colorA6.withOpacity(.10),
                          radius: 24,
                          backgroundImage: AssetImage(
                            index == 0
                                ? review1
                                : index == 1
                                    ? review2
                                    : review3,
                          ),
                        ),
                        widthSpace10,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                index == 0
                                    ? 'Leslie Alexander'
                                    : index == 1
                                        ? 'Bessie Cooper'
                                        : 'Jerome Bell',
                                style: blackRegular16),
                            Text('19 july 2022', style: colorA6Medium12),
                          ],
                        )
                      ],
                    ),
                    heightSpace15,
                    Text(
                        'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet. Velit Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit.',
                        style: colorA6Medium12)
                  ],
                ),
              ),
            )),
            PushNavigate(
              navigate: 'ReviewsPage',
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration:
                    BoxDecoration(color: colorF4, boxShadow: [myBoxShadow]),
                child: Center(
                    child: Text(translation(context).viewMore,
                        style: primaryMedium16)),
              ),
            ),
            heightSpace20
          ],
        ));
  }

  List<Widget> faqMethod() {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(translation(context).faqS, style: blackSemiBold16),
      ),
      heightSpace15,
      Column(
        children: List.generate(
            4,
            (index) => PrimaryContainer(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: ListTileTheme(
                  dense: true,
                  child: Theme(
                    data: ThemeData(dividerColor: transparent),
                    child: ExpansionTile(
                      iconColor: black,
                      collapsedIconColor: black,
                      childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                      title: Row(
                        children: [
                          Text('Does carmax offer home inspection?',
                              style: blackMedium14)
                        ],
                      ),
                      children: [
                        Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas amet ut eget eu nibh lorem velit. Id ornare lectus mauris, mauris. Pharetra, amet erat feugiat duis.Maecenas amet ut eget eu nibh lorem velit. Id ornare lectus mauris, mauris. Pharetra, amet erat feugiat duis.',
                            style: colorA6Regular14)
                      ],
                    ),
                  ),
                ))),
      )
    ];
  }

  Padding sellWithEasyStepMethod() {
    List stepList = [
      {
        'image': happenedNext2,
        'title': translation(context).carDetail,
        'subtitle':
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Turpis vitae, tempor nunc adipiscing velit viverra venenatis in. Nibh augue sed accumsan sociis praesent.',
      },
      {
        'image': happenedNext4,
        'title': translation(context).doorstepInspect,
        'subtitle':
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Turpis vitae, tempor nunc adipiscing velit viverra venenatis in. Nibh augue sed accumsan sociis praesent.',
      },
      {
        'image': happenedNext1,
        'title': translation(context).instantPayment,
        'subtitle':
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Turpis vitae, tempor nunc adipiscing velit viverra venenatis in. Nibh augue sed accumsan sociis praesent.',
      },
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(translation(context).sellInEasyStep, style: blackMedium16),
          heightSpace15,
          Column(
              children: stepList.map(
            (e) {
              var index = stepList.indexOf(e);
              var item = stepList[index];
              return PrimaryContainer(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 12),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          height: 7.3.h,
                          width: 7.3.h,
                          decoration: BoxDecoration(
                              color: colorF4,
                              shape: BoxShape.circle,
                              boxShadow: [myBoxShadow]),
                          child: Image.asset(item['image']),
                        ),
                        heightSpace5,
                        Text('Step ${index + 1}', style: blackMedium14)
                      ],
                    ),
                    widthSpace20,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['title'], style: blackMedium16),
                          Text(
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Turpis vitae, tempor nunc adipiscing velit viverra venenatis in. Nibh augue sed accumsan sociis praesent.',
                              style: colorA6Regular12),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ).toList()),
        ],
      ),
    );
  }

  Column selectBrandMethod() {
    List brandList = [brand2, brand6, brand8, brand5, brand9, brand1];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        heightSpace20,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child:
              Text(translation(context).selectCarBrand, style: blackMedium16),
        ),
        SizedBox(
          height: 285,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            itemCount: brandList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, mainAxisSpacing: 20, crossAxisSpacing: 20),
            itemBuilder: (context, index) {
              bool isLastIndex = index == brandList.length - 1;
              return PrimaryContainer(
                onTap: isLastIndex
                    ? () => Navigator.pushNamed(context, '/BrandPage')
                    : () => Navigator.pushNamed(context, '/ModelSelectPage'),
                padding: const EdgeInsets.all(20),
                child: isLastIndex
                    ? Center(child: Text('More', style: primaryMedium20))
                    : Image.asset(
                        brandList[index],
                        height: 62,
                        width: 62,
                      ),
              );
            },
          ),
        ),
        heightSpace5,
      ],
    );
  }

  Padding inspectCarMethod() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heightSpace20,
          Text(translation(context).yourInspectCar, style: blackMedium16),
          heightSpace15,
          PrimaryContainer(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 13),
            child: Row(children: [
              Image.asset(
                nissan1,
                height: 97,
              ),
              widthSpace20,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nissan Magnite', style: blackMedium16),
                    Text('฿5.44 lakh', style: primaryMedium14),
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Text('Diesel', style: colorA6Medium12),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: VerticalDivider(
                              thickness: 1,
                              width: 10,
                              color: colorD9,
                            ),
                          ),
                          Text('48020km', style: colorA6Medium12),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: VerticalDivider(
                              thickness: 1,
                              width: 10,
                              color: colorD9,
                            ),
                          ),
                          Text('2017', style: colorA6Medium12),
                        ],
                      ),
                    ),
                    heightSpace10,
                    PushNavigate(
                      navigate: 'TestDriveOrInspectionPage',
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 29, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text('Edit', style: whiteMedium16),
                      ),
                    )
                  ],
                ),
              )
            ]),
          )
        ],
      ),
    );
  }

  SizedBox carouselSliderMethod(BuildContext context) {
    return SizedBox(
      height: 229,
      child: CarouselSlider.builder(
          unlimitedMode: true,
          slideIndicator: CircularSlideIndicator(
            padding: const EdgeInsets.only(bottom: 10),
            indicatorRadius: 4.5,
            itemSpacing: 13,
            currentIndicatorColor: white,
            indicatorBackgroundColor: color94,
          ),
          autoSliderTransitionTime: const Duration(milliseconds: 500),
          autoSliderTransitionCurve: Curves.fastLinearToSlowEaseIn,
          slideBuilder: (index) {
            return Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.grey.withOpacity(.10)),
                child: Image.asset(
                  sliderList[index],
                  fit: BoxFit.cover,
                ));
          },
          itemCount: sliderList.length),
    );
  }

  AppBar appBarMethod() {
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
            // GestureDetector(
            //   onTap: showCitiesDialog,
            //   child: Row(
            //     children: [
            //       Image.asset(
            //         locationIcon,
            //         height: 2.h,
            //       ),
            //       widthSpace10,
            //       Text(_currentCity, style: blackMedium14),
            //       const RotatedBox(
            //           quarterTurns: 3,
            //           child: Icon(
            //             Icons.chevron_left,
            //             color: black,
            //           ))
            //     ],
            //   ),
            // ),
              GestureDetector(
              onTap:  (){ showLanguagesDialog(context);},
              child: Row(
                children: [
          
                  Icon(Icons.language,color: black,),
                  widthSpace10,

                  Text(_selectedLanguage, style: blackMedium14),
                  const RotatedBox(
                      quarterTurns: 3,
                      child: Icon(
                        Icons.chevron_left,
                        color: black,
                      ))
                ],
              ),
            ),
            PushNavigate(
              navigate: 'NotificationPage',
              child: Image.asset(
                homeNotificationIcon,
                height: 2.6.h,
              ),
            )
          ],
        ),
      ),
    );
  }

  void showCitiesDialog() async {
    _currentCity = await showDialog(
            context: context,
            builder: (context) =>
                CitiesAlertDialog(initialCity: _currentCity)) ??
        _currentCity;
    setState(() {});
  }
   String _selectedLanguage = 'English'; 
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
                padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 19),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 2.4.h,
                          width: 2.4.h,
                          decoration: BoxDecoration(
                            color: _selectedLanguage == lang
                                ? primaryColor
                                : white,
                            shape: BoxShape.circle,
                            boxShadow: _selectedLanguage == lang
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
    setState(() {
      _selectedLanguage = newLanguage;
    });

    // Update the app's locale
    Locale newLocale = Locale(languages[newLanguage]!);
    MyApp.setLocale(context, newLocale);
  }
}
final Map<String, String> languages = {
  'English': 'en',
  'Thai':'hi',
  'Bahasa': 'id',
  'Chinese': 'zh',
  'Arabic': 'ar',
};
}
