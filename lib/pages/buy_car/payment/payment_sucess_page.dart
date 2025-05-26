import 'package:fl_carmax/helper/language_constant.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/constant.dart';

class PaymentSucessPage extends StatelessWidget {
  //0 for car booked sucess
  //1 for testdrive booked sucess
  //2 for inspection booked sucess
  final int pageFor;
  const PaymentSucessPage({Key? key, required this.pageFor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: const EdgeInsets.only(bottom: 20),
            child: Center(
              child: GestureDetector(
                onTap: () => Navigator.pushReplacementNamed(
                    context, '/BottomNavigation'),
                child: Text(
                  translation(context).backToHome,
                  style: primaryMedium16,
                ),
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              paymentSuccess,
              height: 8.5.h,
            ),
            heightSpace25,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                  pageFor == 0
                      ? '${translation(context).congretulationYour} Maruti suzuki alto 800 Lxi ${translation(context).bookSuccessfully}'
                      : pageFor == 1
                          ? translation(context).testDriveBookedSuccess
                          : '${translation(context).congretulationYour} Maruti suzuki alto 800 Lxi ${translation(context).inspectionSuccessfullyBook}',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: blackMedium16),
            )
          ],
        ),
      ),
    );
  }
}
