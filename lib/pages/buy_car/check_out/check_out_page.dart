import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:fl_carmax/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../helper/language_constant.dart';
import '../../../utils/widgets.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({Key? key}) : super(key: key);

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  bool _isAppliedForEMI = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMethod(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            carDetailMethod(),
            applyEmailMethod(),
            ...summaryMethod(),
            ...whatHappensMethod(),
            heightSpace50,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: PrimaryButton(
                title: translation(context).proceedToPay,
                onTap: showPaymentTypeSheet,
              ),
            ),
            heightSpace20,
          ],
        ),
      ),
    );
  }

  Container applyEmailMethod() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13.5, horizontal: 20),
      color: colorED,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(translation(context).applyForEMI, style: blackMedium16),
          GestureDetector(
              onTap: () => setState(() => _isAppliedForEMI = !_isAppliedForEMI),
              child: Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    color: white,
                    borderRadius: myBorderRadius5,
                    boxShadow: [myBoxShadow]),
                child: Center(
                  child: _isAppliedForEMI
                      ? const Icon(
                          Icons.check,
                          color: primaryColor,
                          size: 13,
                        )
                      : const SizedBox(),
                ),
              ))
        ],
      ),
    );
  }

  PrimaryContainer carDetailMethod() {
    return PrimaryContainer(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            nissan1,
            height: 92,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
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
              ],
            ),
          )
        ],
      ),
    );
  }

  PreferredSize appBarMethod(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: CustomAppBar(
        title: translation(context).checkout,
      ),
    );
  }

  List<Widget> summaryMethod() {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heightSpace20,
            Text(translation(context).summary, style: blackMedium16),
            heightSpace15,
            Column(
              children: List.generate(3, (index) {
                Map summary = {
                  'Purchase amount': '฿5.44 lakh',
                  'Booking amount': '฿1000',
                  'Balance amount': '฿5.43 lakh',
                };
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(summary.keys.toList()[index],
                          style: colorA6Medium14),
                      Text(summary.values.toList()[index],
                          style: blackMedium14),
                    ],
                  ),
                );
              }),
            )
          ],
        ),
      ),
      heightSpace10,
      Container(
        decoration: DottedDecoration(color: color94, dash: const [2, 3]),
      )
    ];
  }

  whatHappensMethod() {
    return [
      heightSpace20,
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(translation(context).whatHappensNext, style: blackMedium16),
      ),
      SizedBox(
        height: 270,
        child: GridView.builder(
          itemCount: 4,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 1.7),
          itemBuilder: (context, index) {
            Map happendNext = {
              '1. Make Booking': happenedNext1,
              '2. Complete paperwork': happenedNext2,
              '3. Pay balance amount': happenedNext3,
              '4. Get home delivery': happenedNext4,
            };

            return PrimaryContainer(
              padding: const EdgeInsets.symmetric(horizontal: 6.5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    happendNext.values.toList()[index],
                    height: 40,
                  ),
                  heightSpace10,
                  Text(happendNext.keys.toList()[index], style: primaryMedium14)
                ],
              ),
            );
          },
        ),
      ),
    ];
  }

  void showPaymentTypeSheet() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      )),
      context: context,
      builder: (context) {
        return const PaymentTypeSheet();
      },
    );
  }
}

class PaymentTypeSheet extends StatefulWidget {
  const PaymentTypeSheet({Key? key}) : super(key: key);

  @override
  State<PaymentTypeSheet> createState() => _PaymentTypeSheetState();
}

class _PaymentTypeSheetState extends State<PaymentTypeSheet> {
  String? _selectedCity = 'Creditcard';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 23),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(translation(context).selectPaymentMethod, style: blackMedium18),
          heightSpace15,
          Column(
              children: ['Creditcard', 'UPI', 'Paytm'].map(
            (e) {
              return ListTile(
                  horizontalTitleGap: 0,
                  onTap: () {
                    setState(() {
                      _selectedCity = e;
                    });
                    Navigator.popAndPushNamed(context, '/PaymentPage');
                  },
                  contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                  leading: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 2.7.h,
                        width: 2.7.h,
                        decoration: BoxDecoration(
                          color: _selectedCity == e ? primaryColor : white,
                          shape: BoxShape.circle,
                          boxShadow: _selectedCity == e
                              ? [myPrimaryShadow]
                              : [myBoxShadow],
                        ),
                      ),
                      const CircleAvatar(
                        backgroundColor: white,
                        radius: 4,
                      )
                    ],
                  ),
                  title: Text(e, style: blackRegular16));
            },
          ).toList())
        ],
      ),
    );
  }
}
