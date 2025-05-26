import 'package:fl_carmax/utils/constant.dart';
import 'package:fl_carmax/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../helper/language_constant.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(children: [
                //Image.asset(helpMain),
                Container(
                  width: 100.h,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: primaryColor,
                  ),
                  alignment: Alignment.center, // Align image at the center
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Image.asset(
                      'assets/images/support.png',
                      color: white,
                      height: 100,
                      width: 100,
                      fit: BoxFit.contain, 
                    ),
                  ),
                ),

                Positioned(
                  top: 50,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: white,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(translation(context).profileItem6,
                          style: whiteSemiBold16)
                    ],
                  ),
                )
              ]),
              heightSpace50,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Text(translation(context).helpTitle,
                        style: blackSemiBold18),
                    heightSpace10,
                  
                    Text(
                      'WowCar is dedicated to making your used car experience seamless. Whether you’re buying or selling, we’re committed to exceeding your expectations. Reach out to us, and let us WOW you.',
                      style: colorA6Regular14,
                      textAlign: TextAlign.center,
                    ),
                    heightSpace40,
                    PrimaryContainer(
                      padding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 21),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            height: 5.2.h,
                            decoration: BoxDecoration(
                                color: white,
                                shape: BoxShape.circle,
                                boxShadow: [myBoxShadow]),
                            child: Image.asset(
                              phoneIcon,
                              color: primaryColor,
                            ),
                          ),
                          widthSpace15,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(translation(context).phoneNumber,
                                  style: blackMedium16),
                              Text('(+66) 094-351-6600', style: blackRegular14),
                            ],
                          )
                        ],
                      ),
                    ),
                    heightSpace30,
                    PrimaryContainer(
                      padding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 21),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            height: 5.2.h,
                            decoration: BoxDecoration(
                                color: white,
                                shape: BoxShape.circle,
                                boxShadow: [myBoxShadow]),
                            child: Image.asset(
                              mailIcon,
                              color: primaryColor,
                            ),
                          ),
                          widthSpace15,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(translation(context).emailId,
                                  style: blackMedium16),
                              Text('support@wowcar.co.th', style: blackRegular14),
                            ],
                          )
                        ],
                      ),
                    ),
                    heightSpace20,
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
