import 'package:fl_carmax/helper/language_constant.dart';
import 'package:flutter/material.dart';

// class BookInspectionWithLocationPage extends StatelessWidget {
import 'package:fl_carmax/utils/constant.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/widgets.dart';

class BookInspectionWithLocationPage extends StatefulWidget {
  const BookInspectionWithLocationPage({Key? key}) : super(key: key);

  @override
  State<BookInspectionWithLocationPage> createState() =>
      _BookInspectionWithLocationPageState();
}

class _BookInspectionWithLocationPageState
    extends State<BookInspectionWithLocationPage> {
  final _pageController = PageController();
  int _selectedLocation = 0;
  int _selectedDate = 1;
  int _selectedTime = 0;
  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);
    bool isArabic = myLocale == const Locale('ar');
    return Scaffold(
      appBar: appBarMethod(context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          // color: amber,
          height: 87.6.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              heightSpace20,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text('Select location', style: blackMedium16),
                    Text.rich(TextSpan(
                        text: translation(context).selectPlaceOfInspection,
                        style: blackMedium16,
                        children: [
                          TextSpan(
                              text: '(${translation(context).free})',
                              style: TextStyle(
                                  color: const Color(0xff02730C),
                                  fontFamily: 'M',
                                  fontSize: 11.2.sp))
                        ])),
                    heightSpace15,
                    Row(
                        children: List.generate(
                      2,
                      (index) => Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _selectedLocation = index);
                            _pageController.animateToPage(index,
                                duration: const Duration(milliseconds: 700),
                                curve: Curves.fastLinearToSlowEaseIn);
                          },
                          child: AnimatedContainer(
                            curve: Curves.fastLinearToSlowEaseIn,
                            duration: const Duration(milliseconds: 700),
                            margin: isArabic
                                ? index == 0
                                    ? const EdgeInsets.only(left: 10)
                                    : const EdgeInsets.only(right: 10)
                                : index == 0
                                    ? const EdgeInsets.only(right: 10)
                                    : const EdgeInsets.only(left: 10),
                            padding: const EdgeInsets.symmetric(vertical: 10.5),
                            decoration: BoxDecoration(
                              color: _selectedLocation == index
                                  ? primaryColor
                                  : white,
                              boxShadow: [myBoxShadow],
                              borderRadius: myBorderRadius10,
                            ),
                            child: Center(
                                child: Text(
                                    index == 0
                                        ? translation(context).yourLocation
                                        : translation(context).nearestBranch,
                                    style: _selectedLocation == index
                                        ? whiteSemiBold16
                                        : colorA6SemiBold16)),
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
              ),
              heightSpace25,
              Expanded(
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  children: [
                    yourLocationPage(context),
                    carMaxHubPage(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget carMaxHubPage(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(translation(context).carmaxLocation, style: blackMedium16),
                heightSpace10,
                PrimaryContainer(
                  onTap: () =>
                      Navigator.pushNamed(context, '/ConfirmLocationPage'),
                  padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 7.5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 45.w,
                            child: Text(
                              '2715 Ash Dr. San Jose,South Dakota 83475',
                              style: colorA6Medium14,
                              maxLines: 2,
                            ),
                          ),
                          Text('1.4 km', style: primaryMedium14)
                        ],
                      ),
                      Image.asset(
                        locationIcon,
                        height: 16,
                        width: 16,
                        color: colorA6,
                      )
                    ],
                  ),
                ),
                heightSpace25,
                Text(translation(context).selectDate, style: blackMedium16),
              ],
            ),
          ),
          SizedBox(
            height: 205,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              itemCount: 5,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 3 / 2,
                  crossAxisCount: 3,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20),
              itemBuilder: (context, index) {
                Map dates = {
                  '18 Aug': 'Today',
                  '19 Aug': 'Tomorrow',
                  '20 Aug': 'Monday',
                  '21 Aug': 'Tuesday',
                  '22 Aug': 'Wednesday'
                };
                bool isSelected = _selectedDate == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedDate = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                        color: white,
                        borderRadius: myBorderRadius10,
                        border:
                            isSelected ? Border.all(color: primaryColor) : null,
                        boxShadow:
                            isSelected ? [myPrimaryShadow] : [myBoxShadow]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(dates.keys.toList()[index],
                            style:
                                isSelected ? primaryMedium14 : colorA6Medium14),
                        Text(dates.values.toList()[index],
                            style:
                                isSelected ? primaryMedium14 : colorA6Medium14),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          heightSpace10,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(translation(context).selectTime, style: blackMedium16),
          ),
          SizedBox(
            height: 145,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              itemCount: 4,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 4 / 1,
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20),
              itemBuilder: (context, index) {
                List time = [
                  '10.00am-12.00pm',
                  '12.00pm-1.00pm',
                  '2.00pm-3.00 pm',
                  '4.00am-6.00 pm'
                ];
                bool isSelected = _selectedTime == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedTime = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                        color: white,
                        borderRadius: myBorderRadius10,
                        border:
                            isSelected ? Border.all(color: primaryColor) : null,
                        boxShadow:
                            isSelected ? [myPrimaryShadow] : [myBoxShadow]),
                    child: Center(
                      child: Text(time[index],
                          style:
                              isSelected ? primaryMedium14 : colorA6Medium14),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 45),
            child: PrimaryButton(
              title: translation(context).proceed,
              onTap: () {
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushNamed(context, '/BottomNavigation');
                Navigator.pushReplacementNamed(context, '/PaymentSucessPage');
              },
            ),
          ),
          heightSpace20,
        ],
      ),
    );
  }

  Widget yourLocationPage(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(translation(context).yourLocation, style: blackMedium16),
                heightSpace10,
                PrimaryContainer(
                  onTap: () => Navigator.pushNamed(context, '/AddAddressPage'),
                  padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 70.w,
                        child: Text(
                          '4517 Washington Ave. Manchester,Kentucky 39495',
                          style: colorA6Medium14,
                          maxLines: 2,
                        ),
                      ),
                      Image.asset(
                        locationIcon,
                        height: 16,
                        width: 16,
                        color: colorA6,
                      )
                    ],
                  ),
                ),
                heightSpace25,
                Text(translation(context).selectDate, style: blackMedium16),
              ],
            ),
          ),
          SizedBox(
            height: 205,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              itemCount: 5,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 3 / 2,
                  crossAxisCount: 3,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20),
              itemBuilder: (context, index) {
                Map dates = {
                  '18 Aug': 'Today',
                  '19 Aug': 'Tomorrow',
                  '20 Aug': 'Monday',
                  '21 Aug': 'Tuesday',
                  '22 Aug': 'Wednesday'
                };
                bool isSelected = _selectedDate == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedDate = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                        color: white,
                        borderRadius: myBorderRadius10,
                        border:
                            isSelected ? Border.all(color: primaryColor) : null,
                        boxShadow:
                            isSelected ? [myPrimaryShadow] : [myBoxShadow]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(dates.keys.toList()[index],
                            style:
                                isSelected ? primaryMedium14 : colorA6Medium14),
                        Text(dates.values.toList()[index],
                            style:
                                isSelected ? primaryMedium14 : colorA6Medium14),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          heightSpace10,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(translation(context).selectTime, style: blackMedium16),
          ),
          SizedBox(
            height: 145,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              itemCount: 4,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 4 / 1,
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20),
              itemBuilder: (context, index) {
                List time = [
                  '10.00am-12.00pm',
                  '12.00pm-1.00pm',
                  '2.00pm-3.00 pm',
                  '4.00am-6.00 pm'
                ];
                bool isSelected = _selectedTime == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedTime = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                        color: white,
                        borderRadius: myBorderRadius10,
                        border:
                            isSelected ? Border.all(color: primaryColor) : null,
                        boxShadow:
                            isSelected ? [myPrimaryShadow] : [myBoxShadow]),
                    child: Center(
                      child: Text(time[index],
                          style:
                              isSelected ? primaryMedium14 : colorA6Medium14),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 45),
            child: PrimaryButton(
              title: translation(context).proceed,
              onTap: () {
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushNamed(context, '/BottomNavigation');
                Navigator.pushReplacementNamed(context, '/PaymentSucessPage',
                    arguments: 2);
              },
            ),
          ),
          heightSpace20,
        ],
      ),
    );
  }

  PreferredSize appBarMethod(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: CustomAppBar(
        title: translation(context).bookInspection,
      ),
    );
  }
}
